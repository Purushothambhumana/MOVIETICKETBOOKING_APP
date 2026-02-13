package com.bookmyshow.controller;

import com.bookmyshow.dto.ShowRequest;
import com.bookmyshow.dto.ShowResponse;
import com.bookmyshow.service.ShowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/shows")
@CrossOrigin(origins = "http://localhost:3000")
public class ShowController {

    @Autowired
    private ShowService showService;

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ShowResponse> createShow(@Valid @RequestBody ShowRequest request) {
        return ResponseEntity.ok(showService.createShow(request));
    }

    @PostMapping("/bulk")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createBulkShows(@Valid @RequestBody List<ShowRequest> requests) {
        System.out.println("=====================================");
        System.out.println("BULK CREATE SHOWS CALLED!");
        System.out.println("Number of shows to create: " + requests.size());
        System.out.println("=====================================");

        List<ShowResponse> createdShows = showService.createBulkShows(requests);

        return ResponseEntity.ok(java.util.Map.of(
                "message", "Shows created successfully",
                "count", createdShows.size(),
                "shows", createdShows));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ShowResponse> updateShow(@PathVariable Long id, @Valid @RequestBody ShowRequest request) {
        return ResponseEntity.ok(showService.updateShow(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteShow(@PathVariable Long id) {
        showService.deleteShow(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ShowResponse> getShowById(@PathVariable Long id) {
        return ResponseEntity.ok(showService.getShowById(id));
    }

    @GetMapping
    public ResponseEntity<List<ShowResponse>> getAllShows() {
        return ResponseEntity.ok(showService.getAllShows());
    }

    @GetMapping("/movie/{movieId}")
    public ResponseEntity<List<ShowResponse>> getShowsByMovieId(@PathVariable Long movieId) {
        return ResponseEntity.ok(showService.getShowsByMovieId(movieId));
    }

    @GetMapping("/movie/{movieId}/city/{city}")
    public ResponseEntity<List<ShowResponse>> getShowsByMovieAndCity(@PathVariable Long movieId,
            @PathVariable String city) {
        return ResponseEntity.ok(showService.getShowsByMovieAndCity(movieId, city));
    }
}
