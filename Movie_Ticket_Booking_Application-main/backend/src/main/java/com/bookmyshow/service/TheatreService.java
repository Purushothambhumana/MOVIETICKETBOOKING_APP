package com.bookmyshow.service;

import com.bookmyshow.dto.ScreenRequest;
import com.bookmyshow.dto.SeatRequest;
import com.bookmyshow.dto.TheatreRequest;
import com.bookmyshow.entity.Booking;
import com.bookmyshow.entity.Payment;
import com.bookmyshow.entity.Screen;
import com.bookmyshow.entity.Seat;
import com.bookmyshow.entity.Show;
import com.bookmyshow.entity.Theatre;
import com.bookmyshow.exception.ResourceNotFoundException;
import com.bookmyshow.repository.BookingRepository;
import com.bookmyshow.repository.BookingSeatRepository;
import com.bookmyshow.repository.PaymentRepository;
import com.bookmyshow.repository.ScreenRepository;
import com.bookmyshow.repository.SeatRepository;
import com.bookmyshow.repository.ShowRepository;
import com.bookmyshow.repository.TheatreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class TheatreService {

    @Autowired
    private TheatreRepository theatreRepository;

    @Autowired
    private ScreenRepository screenRepository;

    @Autowired
    private SeatRepository seatRepository;

    @Autowired
    private ShowRepository showRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private BookingSeatRepository bookingSeatRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @CacheEvict(value = { "theatres", "screens" }, allEntries = true)
    public Theatre createTheatre(TheatreRequest request) {
        Theatre theatre = new Theatre();
        theatre.setName(request.getName());
        theatre.setCity(request.getCity());
        theatre.setAddress(request.getAddress());
        return theatreRepository.save(theatre);
    }

    @CacheEvict(value = { "theatres", "screens" }, allEntries = true)
    public Theatre updateTheatre(Long id, TheatreRequest request) {
        Theatre theatre = theatreRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Theatre not found with id: " + id));

        theatre.setName(request.getName());
        theatre.setCity(request.getCity());
        theatre.setAddress(request.getAddress());
        return theatreRepository.save(theatre);
    }

    @Transactional
    @CacheEvict(value = { "theatres", "screens", "shows", "seats" }, allEntries = true)
    public void deleteTheatre(Long id) {
        Theatre theatre = theatreRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Theatre not found with id: " + id));

        // Get all screens for this theatre
        List<Screen> screens = screenRepository.findByTheatreId(id);

        // Delete each screen and its dependencies
        for (Screen screen : screens) {
            // Get all shows for this screen
            List<Show> shows = showRepository.findByScreenId(screen.getId());

            // Delete all shows and their dependencies
            for (Show show : shows) {
                // Get all bookings for this show
                List<Booking> bookings = bookingRepository.findByShowId(show.getId());

                // Delete all booking seats and bookings
                for (Booking booking : bookings) {
                    // Delete payment first if exists
                    Payment payment = paymentRepository.findByBookingId(booking.getId()).orElse(null);
                    if (payment != null) {
                        paymentRepository.delete(payment);
                    }

                    bookingSeatRepository.deleteAll(bookingSeatRepository.findByBookingId(booking.getId()));
                    bookingRepository.delete(booking);
                }

                // Delete the show
                showRepository.delete(show);
            }

            // Delete all seats for this screen
            seatRepository.deleteByScreenId(screen.getId());

            // Delete the screen itself
            screenRepository.delete(screen);
        }

        // Finally delete the theatre
        theatreRepository.delete(theatre);
    }

    @Cacheable(value = "theatres", key = "#id")
    public Theatre getTheatreById(Long id) {
        return theatreRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Theatre not found with id: " + id));
    }

    @Cacheable(value = "theatres", key = "'all'")
    public List<Theatre> getAllTheatres() {
        return theatreRepository.findAll();
    }

    @Cacheable(value = "theatres", key = "#city")
    public List<Theatre> getTheatresByCity(String city) {
        return theatreRepository.findByCity(city);
    }

    @Transactional
    @CacheEvict(value = { "screens", "seats" }, allEntries = true)
    public Screen createScreen(ScreenRequest request) {
        Theatre theatre = theatreRepository.findById(request.getTheatreId())
                .orElseThrow(
                        () -> new ResourceNotFoundException("Theatre not found with id: " + request.getTheatreId()));

        Screen screen = new Screen();
        screen.setTheatre(theatre);
        screen.setScreenNumber(request.getScreenNumber());
        screen.setTotalSeats(request.getTotalSeats());
        Screen savedScreen = screenRepository.save(screen);

        // If rows and seatsPerRow are provided, automatically create seats
        if (request.getRows() != null && request.getSeatsPerRow() != null) {
            createSeatsForScreen(savedScreen.getId(), request.getRows(), request.getSeatsPerRow(), "");
        }

        return savedScreen;
    }

    @Transactional
    @CacheEvict(value = "screens", allEntries = true)
    public Screen updateScreen(Long id, ScreenRequest request) {
        System.out.println("TheatreService.updateScreen called for screen ID: " + id);

        Screen screen = screenRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Screen not found with id: " + id));

        Theatre theatre = theatreRepository.findById(request.getTheatreId())
                .orElseThrow(
                        () -> new ResourceNotFoundException("Theatre not found with id: " + request.getTheatreId()));

        // Update screen properties
        screen.setTheatre(theatre);
        screen.setScreenNumber(request.getScreenNumber());
        screen.setTotalSeats(request.getTotalSeats());

        Screen updatedScreen = screenRepository.save(screen);
        System.out.println("Screen updated: " + updatedScreen.getId());

        // If rows and seatsPerRow are provided, recreate seats
        if (request.getRows() != null && request.getSeatsPerRow() != null) {
            System.out.println(
                    "Recreating seats with rows=" + request.getRows() + ", seatsPerRow=" + request.getSeatsPerRow());
            createSeatsForScreen(id, request.getRows(), request.getSeatsPerRow(), "");
        }

        return updatedScreen;
    }

    @Transactional
    @CacheEvict(value = { "screens", "seats", "shows" }, allEntries = true)
    public void deleteScreen(Long id) {
        Screen screen = screenRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Screen not found with id: " + id));

        // Get all shows for this screen
        List<Show> shows = showRepository.findByScreenId(id);

        // Delete all shows and their dependencies
        for (Show show : shows) {
            // Get all bookings for this show
            List<Booking> bookings = bookingRepository.findByShowId(show.getId());

            // Delete all booking seats and bookings
            for (Booking booking : bookings) {
                // Delete payment first if exists
                Payment payment = paymentRepository.findByBookingId(booking.getId()).orElse(null);
                if (payment != null) {
                    paymentRepository.delete(payment);
                }

                bookingSeatRepository.deleteAll(bookingSeatRepository.findByBookingId(booking.getId()));
                bookingRepository.delete(booking);
            }

            // Delete the show
            showRepository.delete(show);
        }

        // Delete all seats for this screen
        seatRepository.deleteByScreenId(id);

        // Finally delete the screen
        screenRepository.delete(screen);
    }

    @Transactional
    @CacheEvict(value = { "seats", "availableSeats" }, allEntries = true)
    public void createSeatsForScreen(Long screenId, int rows, int seatsPerRow, String seatTypeDistribution) {
        Screen screen = screenRepository.findById(screenId)
                .orElseThrow(() -> new ResourceNotFoundException("Screen not found with id: " + screenId));

        // Validate inputs - only check for positive values
        if (rows <= 0) {
            throw new IllegalArgumentException("Rows must be at least 1");
        }
        if (seatsPerRow <= 0) {
            throw new IllegalArgumentException("Seats per row must be at least 1");
        }

        List<Seat> seats = new ArrayList<>();

        try {
            for (int i = 0; i < rows; i++) {
                Seat.SeatType seatType = getSeatTypeForRow(i, rows);
                String rowLabel = generateRowLabel(i);
                for (int j = 1; j <= seatsPerRow; j++) {
                    Seat seat = new Seat();
                    seat.setScreen(screen);
                    seat.setRowNumber(rowLabel);
                    seat.setSeatNumber(j);
                    seat.setSeatType(seatType);
                    seats.add(seat);
                }
            }

            // Save in batches to avoid memory issues
            int batchSize = 50;
            for (int i = 0; i < seats.size(); i += batchSize) {
                int end = Math.min(i + batchSize, seats.size());
                seatRepository.saveAll(seats.subList(i, end));
            }
        } catch (Exception e) {
            throw new RuntimeException("Error creating seats: " + e.getMessage(), e);
        }
    }

    private Seat.SeatType getSeatTypeForRow(int rowIndex, int totalRows) {
        if (rowIndex < totalRows / 3) {
            return Seat.SeatType.PLATINUM;
        } else if (rowIndex < (2 * totalRows) / 3) {
            return Seat.SeatType.GOLD;
        } else {
            return Seat.SeatType.SILVER;
        }
    }

    /**
     * Generates row labels dynamically: A, B, C...Z, AA, AB...ZZ, AAA, etc.
     * 
     * @param rowIndex Zero-based row index
     * @return Row label string
     */
    private String generateRowLabel(int rowIndex) {
        StringBuilder label = new StringBuilder();
        int index = rowIndex;

        do {
            label.insert(0, (char) ('A' + (index % 26)));
            index = (index / 26) - 1;
        } while (index >= 0);

        return label.toString();
    }

    @Cacheable(value = "screens", key = "#theatreId")
    public List<Screen> getScreensByTheatreId(Long theatreId) {
        return screenRepository.findByTheatreId(theatreId);
    }

    @Cacheable(value = "screens", key = "'all'")
    public List<com.bookmyshow.dto.ScreenDTO> getAllScreens() {
        List<Screen> screens = screenRepository.findAll();
        return screens.stream().map(screen -> new com.bookmyshow.dto.ScreenDTO(
                screen.getId(),
                screen.getScreenNumber(),
                screen.getTotalSeats(),
                screen.getTheatre().getId(),
                screen.getTheatre().getName(),
                screen.getTheatre().getCity())).collect(java.util.stream.Collectors.toList());
    }

    /**
     * Create bulk seats for a screen with custom layout
     * Deletes existing seats first, then creates new ones
     */
    @Transactional
    @CacheEvict(value = { "seats", "availableSeats" }, allEntries = true)
    public void createBulkSeats(Long screenId, List<SeatRequest> seatRequests) {
        Screen screen = screenRepository.findById(screenId)
                .orElseThrow(() -> new ResourceNotFoundException("Screen not found with id: " + screenId));

        // Delete booking_seats first (foreign key constraint)
        List<Seat> existingSeats = seatRepository.findByScreenId(screenId);
        for (Seat seat : existingSeats) {
            bookingSeatRepository.deleteBySeatId(seat.getId());
        }

        // Now delete seats
        seatRepository.deleteByScreenId(screenId);

        // Create new seats from requests
        List<Seat> seats = new ArrayList<>();
        for (SeatRequest request : seatRequests) {
            Seat seat = new Seat();
            seat.setScreen(screen);
            seat.setRowNumber(request.getRowNumber());
            seat.setSeatNumber(request.getSeatNumber());
            seat.setSeatType(Seat.SeatType.valueOf(request.getSeatType()));
            seats.add(seat);
        }

        seatRepository.saveAll(seats);

        // Update screen total seats
        screen.setTotalSeats(seats.size());
        screenRepository.save(screen);

        System.out.println("✓ Created " + seats.size() + " seats for screen " + screenId);
    }

    /**
     * Delete all seats for a screen
     */
    @Transactional
    @CacheEvict(value = "seats", key = "#screenId")
    public void deleteAllSeatsForScreen(Long screenId) {
        seatRepository.deleteByScreenId(screenId);
        System.out.println("✓ Deleted all seats for screen " + screenId);
    }

    /**
     * Get all seats for a screen (for admin editing)
     */
    public List<Seat> getSeatsForScreen(Long screenId) {
        return seatRepository.findByScreenId(screenId);
    }
}
