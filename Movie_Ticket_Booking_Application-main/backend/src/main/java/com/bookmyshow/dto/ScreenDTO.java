package com.bookmyshow.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScreenDTO {
    private Long id;
    private Integer screenNumber;
    private Integer totalSeats;
    private Long theatreId;
    private String theatreName;
    private String theatreCity;
}
