package com.bookmyshow.controller;

import com.bookmyshow.dto.ScreenRequest;
import com.bookmyshow.dto.SeatRequest;
import com.bookmyshow.dto.TheatreRequest;
import com.bookmyshow.entity.Screen;
import com.bookmyshow.entity.Theatre;
import com.bookmyshow.service.TheatreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/theatres")
@CrossOrigin(origins = "http://localhost:3000")
public class TheatreController {

    @Autowired
    private TheatreService theatreService;

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Theatre> createTheatre(@Valid @RequestBody TheatreRequest request) {
        return ResponseEntity.ok(theatreService.createTheatre(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Theatre> updateTheatre(@PathVariable Long id, @Valid @RequestBody TheatreRequest request) {
        return ResponseEntity.ok(theatreService.updateTheatre(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteTheatre(@PathVariable Long id) {
        theatreService.deleteTheatre(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Theatre> getTheatreById(@PathVariable Long id) {
        return ResponseEntity.ok(theatreService.getTheatreById(id));
    }

    @GetMapping
    public ResponseEntity<List<Theatre>> getAllTheatres() {
        return ResponseEntity.ok(theatreService.getAllTheatres());
    }

    @GetMapping("/city/{city}")
    public ResponseEntity<List<Theatre>> getTheatresByCity(@PathVariable String city) {
        return ResponseEntity.ok(theatreService.getTheatresByCity(city));
    }

    @PostMapping("/screens")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Screen> createScreen(@Valid @RequestBody ScreenRequest request) {
        System.out.println("=====================================");
        System.out.println("CREATE SCREEN CONTROLLER CALLED!");
        System.out.println("Request: " + request);
        System.out.println("Theatre ID: " + request.getTheatreId());
        System.out.println("Screen Number: " + request.getScreenNumber());
        System.out.println("Total Seats: " + request.getTotalSeats());
        System.out.println("Rows: " + request.getRows());
        System.out.println("SeatsPerRow: " + request.getSeatsPerRow());
        System.out.println("=====================================");
        try {
            Screen result = theatreService.createScreen(request);
            System.out.println("Screen created successfully: " + result.getId());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error creating screen: " + e.getMessage());
            throw e;
        }
    }

    @PostMapping("/screens/{screenId}/seats")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createSeats(@PathVariable Long screenId, @RequestBody Map<String, Integer> request) {
        int rows = request.getOrDefault("rows", 10);
        int seatsPerRow = request.getOrDefault("seatsPerRow", 15);
        theatreService.createSeatsForScreen(screenId, rows, seatsPerRow, "");
        return ResponseEntity.ok().build();
    }

    @PutMapping("/screens/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Screen> updateScreen(@PathVariable Long id, @Valid @RequestBody ScreenRequest request) {
        System.out.println("=====================================");
        System.out.println("UPDATE SCREEN CONTROLLER CALLED!");
        System.out.println("Screen ID: " + id);
        System.out.println("Request: " + request);
        System.out.println("=====================================");
        try {
            Screen result = theatreService.updateScreen(id, request);
            System.out.println("Screen updated successfully: " + result.getId());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error updating screen: " + e.getMessage());
            throw e;
        }
    }

    @DeleteMapping("/screens/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteScreen(@PathVariable Long id) {
        theatreService.deleteScreen(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{theatreId}/screens")
    public ResponseEntity<List<Screen>> getScreensByTheatreId(@PathVariable Long theatreId) {
        return ResponseEntity.ok(theatreService.getScreensByTheatreId(theatreId));
    }

    @GetMapping("/screens/all")
    public ResponseEntity<List<com.bookmyshow.dto.ScreenDTO>> getAllScreens() {
        return ResponseEntity.ok(theatreService.getAllScreens());
    }

    /**
     * Bulk create seats for a screen with custom layout
     * Deletes existing seats and creates new ones based on request
     */
    @PostMapping("/screens/{screenId}/seats/bulk")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createBulkSeats(@PathVariable Long screenId, @RequestBody List<SeatRequest> seats) {
        theatreService.createBulkSeats(screenId, seats);
        return ResponseEntity.ok(Map.of("message", "Seats created successfully", "count", seats.size()));
    }

    /**
     * Delete all seats for a screen
     */
    @DeleteMapping("/screens/{screenId}/seats")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteAllSeatsForScreen(@PathVariable Long screenId) {
        theatreService.deleteAllSeatsForScreen(screenId);
        return ResponseEntity.ok(Map.of("message", "All seats deleted successfully"));
    }

    /**
     * Get all seats for a screen (for admin editing)
     */
    @GetMapping("/screens/{screenId}/seats")
    public ResponseEntity<?> getSeatsForScreen(@PathVariable Long screenId) {
        return ResponseEntity.ok(theatreService.getSeatsForScreen(screenId));
    }
}
