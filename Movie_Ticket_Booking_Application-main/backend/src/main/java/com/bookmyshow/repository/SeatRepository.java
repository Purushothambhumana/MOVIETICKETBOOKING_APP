package com.bookmyshow.repository;

import com.bookmyshow.entity.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SeatRepository extends JpaRepository<Seat, Long> {
    List<Seat> findByScreenId(Long screenId);

    List<Seat> findByScreenIdOrderByRowNumberAscSeatNumberAsc(Long screenId);

    void deleteByScreenId(Long screenId);
}
