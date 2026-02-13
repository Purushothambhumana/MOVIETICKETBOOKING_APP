-- Quick Sample Data for BookMyShow Clone
USE antipromovie;

-- Insert Sample Movies (Now Showing)
INSERT INTO movies (title, description, duration, language, genre, poster_url, release_date, status, certification) VALUES
('Pushpa 2: The Rule', 'The clash is on as Pushpa and Bhanwar Singh continue their rivalry in this epic conclusion.', 180, 'Telugu', 'Action, Drama', 'https://image.tmdb.org/t/p/w500/deLWkOLZmBNkm8p16igfapQyqeq.jpg', '2024-12-05', 'NOW_SHOWING', 'UA'),
('Fighter', 'An adrenaline-pumping story of top IAF aviators on a secret mission.', 166, 'Hindi', 'Action, Thriller', 'https://image.tmdb.org/t/p/w500/w2nFc2Rsm93PDkvRrL5gEbSEOfA.jpg', '2024-01-25', 'NOW_SHOWING', 'UA'),
('Salaar', 'The fate of a violently contested kingdom hangs on the fraught bond between two friends-turned-foes.', 175, 'Kannada', 'Action', 'https://image.tmdb.org/t/p/w500/rvJL9JMkYs9rNNJtqjuLhRYpbQN.jpg', '2023-12-22', 'NOW_SHOWING', 'UA'),
('Animal', 'This is the story of a son whose love for his father knows no bounds.', 204, 'Hindi', 'Action, Crime, Drama', 'https://image.tmdb.org/t/p/w500/6xt7BDn7GGfDJRIJLqd1v55tz3R.jpg', '2023-12-01', 'NOW_SHOWING', 'A'),
('Dunki', 'A man journeys through life pursuing his dream to immigrate abroad.', 161, 'Hindi', 'Comedy, Drama', 'https://image.tmdb.org/t/p/w500/xJZjrxPCF4B2xvvPdHkd1eNQOVu.jpg', '2023-12-21', 'NOW_SHOWING', 'UA');

-- Insert Theatres  
INSERT INTO theatres (name, city, address) VALUES
('PVR Phoenix', 'Mumbai', 'High Street Phoenix, Lower Parel'),
('INOX Nariman Point', 'Mumbai', 'Eros Cinema, Nariman Point'),
('Cinepolis Andheri', 'Mumbai', 'Fun Republic Mall, Andheri West'),
('PVR Juhu', 'Mumbai', 'Juhu Beach'),
('Carnival Imax Wadala', 'Mumbai', 'Wadala East');

-- Insert Screens for each theatre
INSERT INTO screens (theatre_id, screen_number, total_seats) VALUES
(1, 1, 150), (1, 2, 200), (1, 3, 120),
(2, 1, 180), (2, 2, 150),
(3, 1, 200), (3, 2, 160),
(4, 1, 140), (4, 2, 180),
(5, 1, 250);

-- Create seats for Screen 1 (you can add more via admin panel)
-- Generate 150 seats for Screen 1 (10 rows, 15 seats per row)
INSERT INTO seats (screen_id, row_number, seat_number, seat_type) 
SELECT 
    1 as screen_id,
    CHAR(64 + FLOOR((n-1)/15) + 1) as row_number,
    ((n-1) % 15) + 1 as seat_number,
    CASE 
        WHEN FLOOR((n-1)/15) + 1 <= 3 THEN 'PLATINUM'
        WHEN FLOOR((n-1)/15) + 1 <= 7 THEN 'GOLD'
        ELSE 'SILVER'
    END as seat_type
FROM (
    SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION
    SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION
    SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
    SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
    SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
    SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION
    SELECT 31 UNION SELECT 32 UNION SELECT 33 UNION SELECT 34 UNION SELECT 35 UNION
    SELECT 36 UNION SELECT 37 UNION SELECT 38 UNION SELECT 39 UNION SELECT 40 UNION
    SELECT 41 UNION SELECT 42 UNION SELECT 43 UNION SELECT 44 UNION SELECT 45 UNION
    SELECT 46 UNION SELECT 47 UNION SELECT 48 UNION SELECT 49 UNION SELECT 50 UNION
    SELECT 51 UNION SELECT 52 UNION SELECT 53 UNION SELECT 54 UNION SELECT 55 UNION
    SELECT 56 UNION SELECT 57 UNION SELECT 58 UNION SELECT 59 UNION SELECT 60 UNION
    SELECT 61 UNION SELECT 62 UNION SELECT 63 UNION SELECT 64 UNION SELECT 65 UNION
    SELECT 66 UNION SELECT 67 UNION SELECT 68 UNION SELECT 69 UNION SELECT 70 UNION
    SELECT 71 UNION SELECT 72 UNION SELECT 73 UNION SELECT 74 UNION SELECT 75 UNION
    SELECT 76 UNION SELECT 77 UNION SELECT 78 UNION SELECT 79 UNION SELECT 80 UNION
    SELECT 81 UNION SELECT 82 UNION SELECT 83 UNION SELECT 84 UNION SELECT 85 UNION
    SELECT 86 UNION SELECT 87 UNION SELECT 88 UNION SELECT 89 UNION SELECT 90 UNION
    SELECT 91 UNION SELECT 92 UNION SELECT 93 UNION SELECT 94 UNION SELECT 95 UNION
    SELECT 96 UNION SELECT 97 UNION SELECT 98 UNION SELECT 99 UNION SELECT 100 UNION
    SELECT 101 UNION SELECT 102 UNION SELECT 103 UNION SELECT 104 UNION SELECT 105 UNION
    SELECT 106 UNION SELECT 107 UNION SELECT 108 UNION SELECT 109 UNION SELECT 110 UNION
    SELECT 111 UNION SELECT 112 UNION SELECT 113 UNION SELECT 114 UNION SELECT 115 UNION
    SELECT 116 UNION SELECT 117 UNION SELECT 118 UNION SELECT 119 UNION SELECT 120 UNION
    SELECT 121 UNION SELECT 122 UNION SELECT 123 UNION SELECT 124 UNION SELECT 125 UNION
    SELECT 126 UNION SELECT 127 UNION SELECT 128 UNION SELECT 129 UNION SELECT 130 UNION
    SELECT 131 UNION SELECT 132 UNION SELECT 133 UNION SELECT 134 UNION SELECT 135 UNION
    SELECT 136 UNION SELECT 137 UNION SELECT 138 UNION SELECT 139 UNION SELECT 140 UNION
    SELECT 141 UNION SELECT 142 UNION SELECT 143 UNION SELECT 144 UNION SELECT 145 UNION
    SELECT 146 UNION SELECT 147 UNION SELECT 148 UNION SELECT 149 UNION SELECT 150
) numbers;

-- Insert Shows (Multiple shows per movie)
-- Pushpa 2 - Multiple theatres and times
INSERT INTO shows (movie_id, screen_id, show_date, show_time, price) VALUES
(1, 1, CURDATE(), '10:00:00', 250.00),
(1, 1, CURDATE(), '14:00:00', 300.00),
(1, 1, CURDATE(), '18:30:00', 350.00),
(1, 1, CURDATE(), '22:00:00', 350.00),
(1, 4, CURDATE(), '11:00:00', 280.00),
(1, 4, CURDATE(), '19:00:00', 380.00);

-- Fighter  
INSERT INTO shows (movie_id, screen_id, show_date, show_time, price) VALUES
(2, 1, CURDATE(), '09:30:00', 200.00),
(2, 1, CURDATE(), '13:00:00', 250.00),
(2, 1, CURDATE(), '17:00:00', 300.00),
(2, 1, CURDATE(), '21:00:00', 300.00);

-- Salaar
INSERT INTO shows (movie_id, screen_id, show_date, show_time, price) VALUES
(3, 1, CURDATE(), '10:30:00', 220.00),
(3, 1, CURDATE(), '15:00:00', 270.00),
(3, 1, CURDATE(), '19:30:00', 320.00);

-- Animal
INSERT INTO shows (movie_id, screen_id, show_date, show_time, price) VALUES
(4, 1, CURDATE(), '12:00:00', 240.00),
(4, 1, CURDATE(), '16:30:00', 290.00),
(4, 1, CURDATE(), '20:30:00', 340.00);

-- Dunki
INSERT INTO shows (movie_id, screen_id, show_date, show_time, price) VALUES
(5, 1, CURDATE(), '11:30:00', 230.00),
(5, 1, CURDATE(), '15:30:00', 280.00),
(5, 1, CURDATE(), '19:00:00', 330.00),
(5, 1, CURDATE(), '22:30:00', 330.00);

SELECT '✅ Sample data inserted successfully!' AS Status;
SELECT COUNT(*) AS 'Movies Added' FROM movies;
SELECT COUNT(*) AS 'Theatres Added' FROM theatres;
SELECT COUNT(*) AS 'Screens Added' FROM screens;
SELECT COUNT(*) AS 'Seats Created' FROM seats;
SELECT COUNT(*) AS 'Shows Created' FROM shows;
