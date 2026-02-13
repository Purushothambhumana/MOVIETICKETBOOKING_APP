package com.bookmyshow.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingResponse {
    private Long id;
    private Long userId;
    private String username;
    private Long showId;
    private String movieTitle;
    private String theatreName;
    private String showDate;
    private String showTime;
    private List<SeatInfo> seats;
    private BigDecimal totalAmount;
    private String status;
    private LocalDateTime bookingDate;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SeatInfo {
        private Long seatId;
        private String rowNumber;
        private Integer seatNumber;
        private String seatType;
    }
}
