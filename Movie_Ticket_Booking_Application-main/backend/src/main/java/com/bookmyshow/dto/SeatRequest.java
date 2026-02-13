package com.bookmyshow.dto;

import lombok.Data;

@Data
public class SeatRequest {
    private String rowNumber;
    private Integer seatNumber;
    private String seatType; // PLATINUM, GOLD, SILVER
}
