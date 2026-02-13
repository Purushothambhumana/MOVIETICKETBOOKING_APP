package com.bookmyshow.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Table(name = "screens")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Screen {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "theatre_id", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private Theatre theatre;

    @Column(name = "screen_number", nullable = false)
    private Integer screenNumber;

    @Column(name = "total_seats", nullable = false)
    private Integer totalSeats;
}
