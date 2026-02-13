package com.bookmyshow.config;

import com.bookmyshow.entity.Movie;
import com.bookmyshow.entity.Screen;
import com.bookmyshow.entity.Seat;
import com.bookmyshow.repository.MovieRepository;
import com.bookmyshow.repository.ScreenRepository;
import com.bookmyshow.repository.SeatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class DatabaseInitializer implements CommandLineRunner {

    @Autowired
    private SeatRepository seatRepository;

    @Autowired
    private ScreenRepository screenRepository;

    @Autowired
    private MovieRepository movieRepository;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("========================================");
        System.out.println("DATABASE INITIALIZATION");
        System.out.println("========================================");

        // Check if seats already exist
        long seatCount = seatRepository.count();
        if (seatCount > 0) {
            System.out.println("✓ Seats already exist (" + seatCount + " seats)");
        } else {
            System.out.println("\n1. Adding seats to all screens...");
            addSeatsToAllScreens();
        }

        // Fix movie status
        System.out.println("\n2. Fixing movie status...");
        fixMovieStatus();

        System.out.println("\n========================================");
        System.out.println("✓ DATABASE INITIALIZATION COMPLETE");
        System.out.println("========================================\n");
    }

    private void addSeatsToAllScreens() {
        List<Screen> screens = screenRepository.findAll();
        System.out.println("Found " + screens.size() + " screens");

        if (screens.isEmpty()) {
            System.out.println("⚠ No screens found in database");
            return;
        }

        String[] premiumRows = { "A", "B", "C" };
        String[] regularRows = { "D", "E", "F", "G" };
        String[] economyRows = { "H", "I", "J" };
        int seatsPerRow = 15;

        List<Seat> allSeats = new ArrayList<>();
        int totalSeats = 0;

        for (Screen screen : screens) {
            // Premium seats (rows A, B, C)
            for (String row : premiumRows) {
                for (int seatNum = 1; seatNum <= seatsPerRow; seatNum++) {
                    Seat seat = new Seat();
                    seat.setScreen(screen);
                    seat.setRowNumber(row);
                    seat.setSeatNumber(seatNum);
                    seat.setSeatType(Seat.SeatType.PLATINUM);
                    allSeats.add(seat);
                    totalSeats++;
                }
            }

            // Regular seats (rows D, E, F, G)
            for (String row : regularRows) {
                for (int seatNum = 1; seatNum <= seatsPerRow; seatNum++) {
                    Seat seat = new Seat();
                    seat.setScreen(screen);
                    seat.setRowNumber(row);
                    seat.setSeatNumber(seatNum);
                    seat.setSeatType(Seat.SeatType.GOLD);
                    allSeats.add(seat);
                    totalSeats++;
                }
            }

            // Economy seats (rows H, I, J)
            for (String row : economyRows) {
                for (int seatNum = 1; seatNum <= seatsPerRow; seatNum++) {
                    Seat seat = new Seat();
                    seat.setScreen(screen);
                    seat.setRowNumber(row);
                    seat.setSeatNumber(seatNum);
                    seat.setSeatType(Seat.SeatType.SILVER);
                    allSeats.add(seat);
                    totalSeats++;
                }
            }

            // Save in batches to improve performance
            if (allSeats.size() >= 500) {
                seatRepository.saveAll(allSeats);
                allSeats.clear();
            }
        }

        // Save remaining seats
        if (!allSeats.isEmpty()) {
            seatRepository.saveAll(allSeats);
        }

        System.out.println("✓ Added " + totalSeats + " seats to " + screens.size() + " screens");
    }

    private void fixMovieStatus() {
        List<Movie> movies = movieRepository.findAll();
        int updated = 0;

        for (Movie movie : movies) {
            if (movie.getStatus() == null || !movie.getStatus().equals(Movie.MovieStatus.NOW_SHOWING)) {
                movie.setStatus(Movie.MovieStatus.NOW_SHOWING);
                movieRepository.save(movie);
                updated++;
            }
        }

        if (updated > 0) {
            System.out.println("✓ Updated " + updated + " movies to NOW_SHOWING status");
        } else {
            System.out.println("✓ All movies already have NOW_SHOWING status");
        }
    }
}
