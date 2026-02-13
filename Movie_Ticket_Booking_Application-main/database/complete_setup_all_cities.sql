     -- Complete Setup: Theatres, Screens, Seats, and Shows for ALL CITIES
-- FIXED VERSION - Correct column names

USE antipromovie;

-- ============================================
-- 1. ADD THEATRES IN ALL MAJOR CITIES
-- ============================================
INSERT INTO theatres (name, city, address) VALUES
-- Mumbai
('PVR Phoenix Palladium', 'Mumbai', 'Phoenix Palladium Mall, Lower Parel'),
('INOX R-City Mall', 'Mumbai', 'R-City Mall, Ghatkopar'),
-- Delhi
('PVR Select City Walk', 'Delhi', 'Saket District Centre'),
('INOX Connaught Place', 'Delhi', 'CP, Inner Circle'),
-- Bangalore  
('PVR Forum Mall', 'Bangalore', 'Forum Mall, Koramangala'),
('INOX Lido Mall', 'Bangalore', 'MG Road'),
-- Hyderabad
('PVR Next Galleria', 'Hyderabad', 'Panjagutta'),
('AMB Cinemas', 'Hyderabad', 'Gachibowli'),
-- Chennai
('PVR Grand Galada', 'Chennai', 'Pallavaram'),
('INOX Escape', 'Chennai', 'Express Avenue Mall'),
-- Pune
('PVR Phoenix Marketcity', 'Pune', 'Viman Nagar'),
('INOX Bund Garden', 'Pune', 'Bund Garden Road'),
-- Kolkata
('INOX South City', 'Kolkata', 'Prince Anwar Shah Road'),
('PVR Mani Square', 'Kolkata', 'EM Bypass'),
-- Ahmedabad
('PVR Acropolis Mall', 'Ahmedabad', 'Thaltej'),
('Cinepolis Ahmedabad One', 'Ahmedabad', 'Vastrapur'),
-- Tirupati
('SVC Cinemas', 'Tirupati', 'Air Bypass Road'),
('Cinepolis Tirupati', 'Tirupati', 'Grand World Mall'),
-- Vijayawada
('PVR Vijayawada', 'Vijayawada', 'PVP Square Mall'),
-- Visakhapatnam
('INOX CMR Central', 'Visakhapatnam', 'Maddilapalem')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- ============================================
-- 2. ADD SCREENS TO ALL THEATRES (3 per theatre)
-- ============================================
INSERT INTO screens (theatre_id, screen_number, total_seats)
SELECT t.id, 1, 150 FROM theatres t
ON DUPLICATE KEY UPDATE screen_number=VALUES(screen_number);

INSERT INTO screens (theatre_id, screen_number, total_seats)
SELECT t.id, 2, 200 FROM theatres t
ON DUPLICATE KEY UPDATE screen_number=VALUES(screen_number);

INSERT INTO screens (theatre_id, screen_number, total_seats)
SELECT t.id, 3, 120 FROM theatres t
ON DUPLICATE KEY UPDATE screen_number=VALUES(screen_number);

-- ============================================
-- 3. ADD SEATS TO ALL SCREENS
-- ============================================
INSERT IGNORE INTO seats (screen_id, `row_number`, seat_number, seat_type)
SELECT s.id, 
       CHAR(64 + FLOOR((n-1)/15) + 1) as `row_number`,
       ((n-1) % 15) + 1 as seat_number,
       CASE 
           WHEN FLOOR((n-1)/15) >= FLOOR(s.total_seats/15) - 2 THEN 'PREMIUM'
           ELSE 'REGULAR'
       END as seat_type
FROM screens s
CROSS JOIN (
    SELECT a.N + b.N * 10 + c.N * 100 + 1 as n
    FROM 
        (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
        (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
        (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
) numbers
WHERE n <= s.total_seats;

-- ============================================
-- 4. CREATE SHOWS FOR ALL MOVIES IN ALL CITIES
-- ============================================
-- Today - Morning (10:00 AM)
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '10:00:00',
       CASE WHEN m.language = 'English' THEN 250.00 ELSE 180.00 END
FROM movies m
CROSS JOIN screens s
WHERE m.status = 'NOW_SHOWING' AND s.screen_number = 1;

-- Today - Afternoon (14:30 PM)
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '14:30:00',
       CASE WHEN m.language = 'English' THEN 300.00 ELSE 220.00 END
FROM movies m
CROSS JOIN screens s
WHERE m.status = 'NOW_SHOWING' AND s.screen_number = 2;

-- Today - Evening (18:30 PM)
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '18:30:00',
       CASE WHEN m.language = 'English' THEN 350.00 ELSE 270.00 END
FROM movies m
CROSS JOIN screens s
WHERE m.status = 'NOW_SHOWING' AND s.screen_number = 3;

-- Today - Night (21:45 PM)
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '21:45:00',
       CASE WHEN m.language = 'English' THEN 400.00 ELSE 320.00 END
FROM movies m
CROSS JOIN screens s
WHERE m.status = 'NOW_SHOWING' AND s.screen_number = 1;

-- Tomorrow - All Shows
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, DATE_ADD(CURDATE(), INTERVAL 1 DAY), t.show_time, t.price
FROM movies m
CROSS JOIN screens s
CROSS JOIN (
    SELECT '10:00:00' as show_time, 180 as price UNION
    SELECT '14:30:00', 220 UNION
    SELECT '18:30:00', 270 UNION
    SELECT '21:45:00', 320
) t
WHERE m.status = 'NOW_SHOWING';

-- ============================================
-- SUMMARY
-- ============================================
SELECT '✅ COMPLETE SETUP DONE!' AS Status;
SELECT COUNT(*) AS 'Total Theatres' FROM theatres;
SELECT COUNT(*) AS 'Total Screens' FROM screens;
SELECT COUNT(*) AS 'Total Seats' FROM seats;
SELECT COUNT(*) AS 'Total Shows' FROM shows;
SELECT GROUP_CONCAT(DISTINCT city ORDER BY city SEPARATOR ', ') AS 'Cities with Movies' FROM theatres LIMIT 1;
