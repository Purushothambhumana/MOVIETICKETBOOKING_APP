package com.bookmyshow.service;

import com.bookmyshow.dto.ShowRequest;
import com.bookmyshow.dto.ShowResponse;
import com.bookmyshow.entity.Booking;
import com.bookmyshow.entity.Movie;
import com.bookmyshow.entity.Payment;
import com.bookmyshow.entity.Screen;
import com.bookmyshow.entity.Show;
import com.bookmyshow.exception.ResourceNotFoundException;
import com.bookmyshow.repository.BookingRepository;
import com.bookmyshow.repository.BookingSeatRepository;
import com.bookmyshow.repository.MovieRepository;
import com.bookmyshow.repository.PaymentRepository;
import com.bookmyshow.repository.ScreenRepository;
import com.bookmyshow.repository.ShowRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShowService {

        @Autowired
        private ShowRepository showRepository;

        @Autowired
        private MovieRepository movieRepository;

        @Autowired
        private ScreenRepository screenRepository;

        @Autowired
        private BookingRepository bookingRepository;

        @Autowired
        private BookingSeatRepository bookingSeatRepository;

        @Autowired
        private PaymentRepository paymentRepository;

        @CacheEvict(value = { "shows", "availableSeats" }, allEntries = true)
        public ShowResponse createShow(ShowRequest request) {
                Movie movie = movieRepository.findById(request.getMovieId())
                                .orElseThrow(() -> new ResourceNotFoundException(
                                                "Movie not found with id: " + request.getMovieId()));

                Screen screen = screenRepository.findById(request.getScreenId())
                                .orElseThrow(() -> new ResourceNotFoundException(
                                                "Screen not found with id: " + request.getScreenId()));

                Show show = new Show();
                show.setMovie(movie);
                show.setScreen(screen);
                show.setShowDate(request.getShowDate());
                show.setShowTime(request.getShowTime());
                show.setPrice(request.getPrice());
                show.setPlatinumPrice(request.getPlatinumPrice());
                show.setGoldPrice(request.getGoldPrice());
                show.setSilverPrice(request.getSilverPrice());

                Show savedShow = showRepository.save(show);
                return mapToResponse(savedShow);
        }

        @Transactional
        @CacheEvict(value = { "shows", "availableSeats" }, allEntries = true)
        public List<ShowResponse> createBulkShows(List<ShowRequest> requests) {
                System.out.println("Creating " + requests.size() + " shows in bulk...");

                List<ShowResponse> createdShows = new java.util.ArrayList<>();

                for (ShowRequest request : requests) {
                        Movie movie = movieRepository.findById(request.getMovieId())
                                        .orElseThrow(() -> new ResourceNotFoundException(
                                                        "Movie not found with id: " + request.getMovieId()));

                        Screen screen = screenRepository.findById(request.getScreenId())
                                        .orElseThrow(() -> new ResourceNotFoundException(
                                                        "Screen not found with id: " + request.getScreenId()));

                        Show show = new Show();
                        show.setMovie(movie);
                        show.setScreen(screen);
                        show.setShowDate(request.getShowDate());
                        show.setShowTime(request.getShowTime());
                        show.setPrice(request.getPrice());
                        show.setPlatinumPrice(request.getPlatinumPrice());
                        show.setGoldPrice(request.getGoldPrice());
                        show.setSilverPrice(request.getSilverPrice());

                        Show savedShow = showRepository.save(show);
                        createdShows.add(mapToResponse(savedShow));
                }

                System.out.println("✓ Successfully created " + createdShows.size() + " shows");
                return createdShows;
        }

        @CacheEvict(value = { "shows", "availableSeats" }, allEntries = true)
        public ShowResponse updateShow(Long id, ShowRequest request) {
                Show show = showRepository.findById(id)
                                .orElseThrow(() -> new ResourceNotFoundException("Show not found with id: " + id));

                Movie movie = movieRepository.findById(request.getMovieId())
                                .orElseThrow(() -> new ResourceNotFoundException(
                                                "Movie not found with id: " + request.getMovieId()));

                Screen screen = screenRepository.findById(request.getScreenId())
                                .orElseThrow(() -> new ResourceNotFoundException(
                                                "Screen not found with id: " + request.getScreenId()));

                show.setMovie(movie);
                show.setScreen(screen);
                show.setShowDate(request.getShowDate());
                show.setShowTime(request.getShowTime());
                show.setPrice(request.getPrice());
                show.setPlatinumPrice(request.getPlatinumPrice());
                show.setGoldPrice(request.getGoldPrice());
                show.setSilverPrice(request.getSilverPrice());

                Show updatedShow = showRepository.save(show);
                return mapToResponse(updatedShow);
        }

        @Transactional
        @CacheEvict(value = { "shows", "availableSeats" }, allEntries = true)
        public void deleteShow(Long id) {
                Show show = showRepository.findById(id)
                                .orElseThrow(() -> new ResourceNotFoundException("Show not found with id: " + id));

                // Get all bookings for this show
                List<Booking> bookings = bookingRepository.findByShowId(id);

                // Delete all booking seats and bookings
                for (Booking booking : bookings) {
                        // Delete payment first if exists
                        Payment payment = paymentRepository.findByBookingId(booking.getId()).orElse(null);
                        if (payment != null) {
                                paymentRepository.delete(payment);
                        }

                        // Delete all booking seats for this booking
                        bookingSeatRepository.deleteAll(bookingSeatRepository.findByBookingId(booking.getId()));

                        // Delete the booking
                        bookingRepository.delete(booking);
                }

                // Finally delete the show
                showRepository.delete(show);
        }

        @Cacheable(value = "shows", key = "#id")
        public ShowResponse getShowById(Long id) {
                Show show = showRepository.findById(id)
                                .orElseThrow(() -> new ResourceNotFoundException("Show not found with id: " + id));
                return mapToResponse(show);
        }

        @Cacheable(value = "shows", key = "'all'")
        public List<ShowResponse> getAllShows() {
                return showRepository.findAll().stream()
                                .map(this::mapToResponse)
                                .collect(Collectors.toList());
        }

        @Cacheable(value = "shows", key = "#movieId + '-' + #city")
        public List<ShowResponse> getShowsByMovieAndCity(Long movieId, String city) {
                LocalDate today = LocalDate.now();
                return showRepository.findByMovieIdAndCityAndShowDateAfter(movieId, city, today).stream()
                                .map(this::mapToResponse)
                                .collect(Collectors.toList());
        }

        @Cacheable(value = "shows", key = "#movieId")
        public List<ShowResponse> getShowsByMovieId(Long movieId) {
                return showRepository.findByMovieId(movieId).stream()
                                .map(this::mapToResponse)
                                .collect(Collectors.toList());
        }

        private ShowResponse mapToResponse(Show show) {
                ShowResponse response = new ShowResponse();
                response.setId(show.getId());
                response.setMovieId(show.getMovie().getId());
                response.setMovieTitle(show.getMovie().getTitle());
                response.setScreenId(show.getScreen().getId());
                response.setScreenNumber(show.getScreen().getScreenNumber());
                response.setTheatreId(show.getScreen().getTheatre().getId());
                response.setTheatreName(show.getScreen().getTheatre().getName());
                response.setCity(show.getScreen().getTheatre().getCity());
                response.setShowDate(show.getShowDate());
                response.setShowTime(show.getShowTime());
                response.setPrice(show.getPrice());
                response.setPlatinumPrice(show.getPlatinumPrice());
                response.setGoldPrice(show.getGoldPrice());
                response.setSilverPrice(show.getSilverPrice());
                return response;
        }
}
