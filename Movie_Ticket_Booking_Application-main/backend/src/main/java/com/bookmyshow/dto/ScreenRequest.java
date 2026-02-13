package com.bookmyshow.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ScreenRequest {

    @NotNull(message = "Theatre ID is required")
    private Long theatreId;

    @NotNull(message = "Screen number is required")
    private Integer screenNumber;

    @NotNull(message = "Total seats is required")
    private Integer totalSeats;

    private Integer rows;

    private Integer seatsPerRow;
}
