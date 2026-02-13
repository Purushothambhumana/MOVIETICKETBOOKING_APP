package com.bookmyshow.service;

import com.bookmyshow.dto.MovieRequest;
import com.bookmyshow.dto.MovieResponse;
import com.bookmyshow.entity.Booking;
import com.bookmyshow.entity.Movie;
import com.bookmyshow.entity.Payment;
import com.bookmyshow.entity.Show;
import com.bookmyshow.exception.ResourceNotFoundException;
import com.bookmyshow.repository.BookingRepository;
import com.bookmyshow.repository.BookingSeatRepository;
import com.bookmyshow.repository.MovieRepository;
import com.bookmyshow.repository.PaymentRepository;
import com.bookmyshow.repository.ShowRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class MovieService {

    @Autowired
    private MovieRepository movieRepository;

    @Autowired
    private ShowRepository showRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private BookingSeatRepository bookingSeatRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @CacheEvict(value = "movies", allEntries = true)
    public MovieResponse createMovie(MovieRequest request) {
        Movie movie = new Movie();
        movie.setTitle(request.getTitle());
        movie.setDescription(request.getDescription());
        movie.setDuration(request.getDuration());
        movie.setLanguage(request.getLanguage());
        movie.setGenre(request.getGenre());
        movie.setPosterUrl(request.getPosterUrl());
        movie.setReleaseDate(request.getReleaseDate());
        movie.setStatus(Movie.MovieStatus.valueOf(request.getStatus()));
        movie.setCertification(request.getCertification());

        Movie savedMovie = movieRepository.save(movie);
        return mapToResponse(savedMovie);
    }

    @CacheEvict(value = "movies", allEntries = true)
    public MovieResponse updateMovie(Long id, MovieRequest request) {
        Movie movie = movieRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Movie not found with id: " + id));

        movie.setTitle(request.getTitle());
        movie.setDescription(request.getDescription());
        movie.setDuration(request.getDuration());
        movie.setLanguage(request.getLanguage());
        movie.setGenre(request.getGenre());
        movie.setPosterUrl(request.getPosterUrl());
        movie.setReleaseDate(request.getReleaseDate());
        movie.setStatus(Movie.MovieStatus.valueOf(request.getStatus()));
        movie.setCertification(request.getCertification());

        Movie updatedMovie = movieRepository.save(movie);
        return mapToResponse(updatedMovie);
    }

    @Transactional
    @CacheEvict(value = "movies", allEntries = true)
    public void deleteMovie(Long id) {
        Movie movie = movieRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Movie not found with id: " + id));

        // Get all shows for this movie
        List<Show> shows = showRepository.findByMovieId(id);

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

        // Finally delete the movie
        movieRepository.delete(movie);
    }

    @Cacheable(value = "movies", key = "#id")
    public MovieResponse getMovieById(Long id) {
        Movie movie = movieRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Movie not found with id: " + id));
        return mapToResponse(movie);
    }

    @Cacheable(value = "movies", key = "'all'")
    public List<MovieResponse> getAllMovies() {
        return movieRepository.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "movies", key = "#status")
    public List<MovieResponse> getMoviesByStatus(String status) {
        Movie.MovieStatus movieStatus = Movie.MovieStatus.valueOf(status);
        return movieRepository.findByStatusOrderByReleaseDateDesc(movieStatus).stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    private MovieResponse mapToResponse(Movie movie) {
        MovieResponse response = new MovieResponse();
        response.setId(movie.getId());
        response.setTitle(movie.getTitle());
        response.setDescription(movie.getDescription());
        response.setDuration(movie.getDuration());
        response.setLanguage(movie.getLanguage());
        response.setGenre(movie.getGenre());
        response.setPosterUrl(movie.getPosterUrl());
        response.setReleaseDate(movie.getReleaseDate());
        response.setStatus(movie.getStatus().name());
        response.setCertification(movie.getCertification());
        return response;
    }
}
