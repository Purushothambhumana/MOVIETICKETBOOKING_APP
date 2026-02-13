package com.bookmyshow.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShowResponse {
    private Long id;
    private Long movieId;
    private String movieTitle;
    private Long screenId;
    private Integer screenNumber;
    private Long theatreId;
    private String theatreName;
    private String city;
    private LocalDate showDate;
    private LocalTime showTime;
    private BigDecimal price;
    private BigDecimal platinumPrice;
    private BigDecimal goldPrice;
    private BigDecimal silverPrice;
}
