package com.bookmyshow.service;

import com.bookmyshow.dto.BookingRequest;
import com.bookmyshow.dto.BookingResponse;
import com.bookmyshow.dto.SeatResponse;
import com.bookmyshow.entity.*;
import com.bookmyshow.exception.BadRequestException;
import com.bookmyshow.exception.ResourceNotFoundException;
import com.bookmyshow.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private BookingSeatRepository bookingSeatRepository;

    @Autowired
    private ShowRepository showRepository;

    @Autowired
    private SeatRepository seatRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Transactional
    @CacheEvict(value = "availableSeats", key = "#request.showId")
    public BookingResponse createBooking(BookingRequest request) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Show show = showRepository.findById(request.getShowId())
                .orElseThrow(() -> new ResourceNotFoundException("Show not found with id: " + request.getShowId()));

        // Check if seats are available
        List<BookingSeat> bookedSeats = bookingSeatRepository.findBookedSeatsByShowId(show.getId());
        List<Long> bookedSeatIds = bookedSeats.stream()
                .map(bs -> bs.getSeat().getId())
                .collect(Collectors.toList());

        for (Long seatId : request.getSeatIds()) {
            if (bookedSeatIds.contains(seatId)) {
                throw new BadRequestException("Seat with ID " + seatId + " is already booked");
            }
        }

        // Create booking
        Booking booking = new Booking();
        booking.setUser(user);
        booking.setShow(show);

        BigDecimal totalAmount = show.getPrice().multiply(BigDecimal.valueOf(request.getSeatIds().size()));
        booking.setTotalAmount(totalAmount);
        booking.setStatus(Booking.BookingStatus.CONFIRMED);

        Booking savedBooking = bookingRepository.save(booking);

        // Create booking seats
        List<BookingSeat> bookingSeats = new ArrayList<>();
        for (Long seatId : request.getSeatIds()) {
            Seat seat = seatRepository.findById(seatId)
                    .orElseThrow(() -> new ResourceNotFoundException("Seat not found with id: " + seatId));

            BookingSeat bookingSeat = new BookingSeat();
            bookingSeat.setBooking(savedBooking);
            bookingSeat.setSeat(seat);
            bookingSeats.add(bookingSeat);
        }
        bookingSeatRepository.saveAll(bookingSeats);

        // Create mock payment
        Payment payment = new Payment();
        payment.setBooking(savedBooking);
        payment.setAmount(totalAmount);
        payment.setPaymentMethod(request.getPaymentMethod());
        payment.setPaymentStatus(Payment.PaymentStatus.SUCCESS);
        paymentRepository.save(payment);

        return mapToResponse(savedBooking, bookingSeats);
    }

    public List<BookingResponse> getUserBookings() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        List<Booking> bookings = bookingRepository.findByUserIdOrderByBookingDateDesc(user.getId());
        return bookings.stream()
                .map(booking -> {
                    List<BookingSeat> bookingSeats = bookingSeatRepository.findByBookingId(booking.getId());
                    return mapToResponse(booking, bookingSeats);
                })
                .collect(Collectors.toList());
    }

    @Transactional
    @CacheEvict(value = "availableSeats", allEntries = true)
    public void cancelBooking(Long bookingId) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

        if (!booking.getUser().getId().equals(user.getId())) {
            throw new BadRequestException("You can only cancel your own bookings");
        }

        if (booking.getStatus() == Booking.BookingStatus.CANCELLED) {
            throw new BadRequestException("Booking is already cancelled");
        }

        booking.setStatus(Booking.BookingStatus.CANCELLED);
        bookingRepository.save(booking);
    }

    @Cacheable(value = "availableSeats", key = "#showId")
    public List<SeatResponse> getAvailableSeats(Long showId) {
        Show show = showRepository.findById(showId)
                .orElseThrow(() -> new ResourceNotFoundException("Show not found with id: " + showId));

        List<Seat> allSeats = seatRepository.findByScreenIdOrderByRowNumberAscSeatNumberAsc(show.getScreen().getId());

        List<BookingSeat> bookedSeats = bookingSeatRepository.findBookedSeatsByShowId(showId);
        List<Long> bookedSeatIds = bookedSeats.stream()
                .map(bs -> bs.getSeat().getId())
                .collect(Collectors.toList());

        return allSeats.stream()
                .map(seat -> {
                    SeatResponse response = new SeatResponse();
                    response.setId(seat.getId());
                    response.setRowNumber(seat.getRowNumber());
                    response.setSeatNumber(seat.getSeatNumber());
                    response.setSeatType(seat.getSeatType().name());
                    response.setBooked(bookedSeatIds.contains(seat.getId()));
                    return response;
                })
                .collect(Collectors.toList());
    }

    private BookingResponse mapToResponse(Booking booking, List<BookingSeat> bookingSeats) {
        BookingResponse response = new BookingResponse();
        response.setId(booking.getId());
        response.setUserId(booking.getUser().getId());
        response.setUsername(booking.getUser().getUsername());
        response.setShowId(booking.getShow().getId());
        response.setMovieTitle(booking.getShow().getMovie().getTitle());
        response.setTheatreName(booking.getShow().getScreen().getTheatre().getName());
        response.setShowDate(booking.getShow().getShowDate().toString());
        response.setShowTime(booking.getShow().getShowTime().toString());
        response.setTotalAmount(booking.getTotalAmount());
        response.setStatus(booking.getStatus().name());
        response.setBookingDate(booking.getBookingDate());

        List<BookingResponse.SeatInfo> seatInfos = bookingSeats.stream()
                .map(bs -> new BookingResponse.SeatInfo(
                        bs.getSeat().getId(),
                        bs.getSeat().getRowNumber(),
                        bs.getSeat().getSeatNumber(),
                        bs.getSeat().getSeatType().name()))
                .collect(Collectors.toList());
        response.setSeats(seatInfos);

        return response;
    }
}
