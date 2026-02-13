package com.bookmyshow.repository;

import com.bookmyshow.entity.Show;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ShowRepository extends JpaRepository<Show, Long> {
    List<Show> findByMovieId(Long movieId);

    List<Show> findByScreenId(Long screenId);

    @Query("SELECT s FROM Show s WHERE s.movie.id = :movieId AND s.showDate = :showDate")
    List<Show> findByMovieIdAndShowDate(@Param("movieId") Long movieId, @Param("showDate") LocalDate showDate);

    @Query("SELECT s FROM Show s WHERE s.movie.id = :movieId AND s.screen.theatre.city = :city AND s.showDate >= :showDate")
    List<Show> findByMovieIdAndCityAndShowDateAfter(@Param("movieId") Long movieId, @Param("city") String city,
            @Param("showDate") LocalDate showDate);

    void deleteByScreenId(Long screenId);
}
