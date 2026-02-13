-- Combined fix: Add seats and fix movie status
USE antipromovie;

-- ========================================
-- PART 1: Add Seats to All Screens
-- ========================================

-- Clear existing seats
DELETE FROM seats;

-- Add seats to ALL screens using UNION ALL
INSERT INTO seats (screen_id, row_number, seat_number, seat_type)
SELECT s.id, 'A', 1, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 2, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 3, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 4, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 5, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 6, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 7, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 8, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 9, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 10, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 11, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 12, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 13, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 14, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'A', 15, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 1, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 2, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 3, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 4, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 5, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 6, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 7, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 8, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 9, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 10, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 11, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 12, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 13, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 14, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'B', 15, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 1, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 2, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 3, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 4, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 5, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 6, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 7, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 8, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 9, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 10, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 11, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 12, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 13, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 14, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'C', 15, 'PREMIUM' FROM screens s UNION ALL
SELECT s.id, 'D', 1, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 2, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 3, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 4, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 5, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 6, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 7, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 8, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 9, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 10, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 11, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 12, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 13, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 14, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'D', 15, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 1, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 2, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 3, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 4, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 5, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 6, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 7, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 8, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 9, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 10, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 11, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 12, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 13, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 14, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'E', 15, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 1, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 2, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 3, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 4, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 5, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 6, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 7, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 8, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 9, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 10, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 11, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 12, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 13, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 14, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'F', 15, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 1, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 2, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 3, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 4, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 5, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 6, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 7, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 8, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 9, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 10, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 11, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 12, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 13, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 14, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'G', 15, 'REGULAR' FROM screens s UNION ALL
SELECT s.id, 'H', 1, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 2, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 3, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 4, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 5, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 6, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 7, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 8, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 9, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 10, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 11, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 12, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 13, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 14, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'H', 15, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 1, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 2, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 3, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 4, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 5, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 6, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 7, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 8, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 9, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 10, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 11, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 12, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 13, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 14, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'I', 15, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 1, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 2, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 3, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 4, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 5, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 6, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 7, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 8, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 9, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 10, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 11, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 12, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 13, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 14, 'ECONOMY' FROM screens s UNION ALL
SELECT s.id, 'J', 15, 'ECONOMY' FROM screens s;

-- ========================================
-- PART 2: Fix Movie Status
-- ========================================

-- Update all movies to NOW_SHOWING status
UPDATE movies 
SET status = 'NOW_SHOWING'
WHERE status IS NULL OR status != 'NOW_SHOWING';

-- ========================================
-- VERIFICATION
-- ========================================

-- Show seats added
SELECT 
    'Seats Added' as check_type,
    COUNT(*) as count
FROM seats
UNION ALL
SELECT 
    'Movies with NOW_SHOWING status',
    COUNT(*)
FROM movies
WHERE status = 'NOW_SHOWING';

-- Show detailed results
SELECT 
    sc.id as screen_id,
    t.name as theatre,
    sc.screen_number,
    COUNT(st.id) as seats
FROM screens sc
LEFT JOIN theatres t ON sc.theatre_id = t.id
LEFT JOIN seats st ON sc.id = st.screen_id
GROUP BY sc.id, t.name, sc.screen_number
ORDER BY sc.id
LIMIT 10;

SELECT 
    id,
    title,
    status,
    genre
FROM movies
WHERE status = 'NOW_SHOWING'
LIMIT 10;
