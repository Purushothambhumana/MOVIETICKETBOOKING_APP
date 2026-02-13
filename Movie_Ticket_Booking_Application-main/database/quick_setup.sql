-- Complete BookMyShow Sample Data
-- Run this in MySQL Workbench to populate your database

USE antipromovie;

-- Clear existing data (optional - comment out if you want to keep data)
-- DELETE FROM bookings WHERE 1=1;
-- DELETE FROM shows WHERE 1=1;
-- DELETE FROM seats WHERE 1=1;
-- DELETE FROM screens WHERE 1=1;
-- DELETE FROM theatres WHERE 1=1;
-- DELETE FROM movies WHERE 1=1;

-- Insert Movies
INSERT INTO movies (title, description, duration, language, genre, poster_url, release_date, status, certification) VALUES
('Pushpa 2: The Rule', 'Pushpa Raj returns in this action-packed sequel as he continues his reign in the smuggling world.', 180, 'Telugu', 'Action, Drama', 'https://image.tmdb.org/t/p/w500/deLWkOLZmBNkm8p16igfapQyqeq.jpg', '2024-12-05', 'NOW_SHOWING', 'UA'),
('Fighter', 'An elite fighter squadron embarks on a dangerous mission to protect the nation.', 166, 'Hindi', 'Action, Thriller', 'https://image.tmdb.org/t/p/w500/w2nFc2Rsm93PDkvRrL5gEbSEOfA.jpg', '2024-01-25', 'NOW_SHOWING', 'UA'),
('Salaar', 'The fate of a violently contested kingdom hangs on the bond between two friends.', 175, 'Kannada', 'Action', 'https://image.tmdb.org/t/p/w500/rvJL9JMkYs9rNNJtqjuLhRYpbQN.jpg', '2023-12-22', 'NOW_SHOWING', 'UA'),
('Animal', 'A son whose love for his father knows no bounds leads him down a dark path.', 204, 'Hindi', 'Action, Crime, Drama', 'https://image.tmdb.org/t/p/w500/6xt7BDn7GGfDJRIJLqd1v55tz3R.jpg', '2023-12-01', 'NOW_SHOWING', 'A'),
('Dunki', 'A heartwarming tale of friendship and the pursuit of the American dream.', 161, 'Hindi', 'Comedy, Drama', 'https://image.tmdb.org/t/p/w500/xJZjrxPCF4B2xvvPdHkd1eNQOVu.jpg', '2023-12-21', 'NOW_SHOWING', 'UA');

-- Insert Theatres (Mumbai)
INSERT INTO theatres (name, city, address) VALUES
('PVR Phoenix', 'Mumbai', 'High Street Phoenix, Lower Parel, Mumbai'),
('INOX Nariman Point', 'Mumbai', 'Eros Cinema Building, Nariman Point, Mumbai'),
('Cinepolis Andheri', 'Mumbai', 'Fun Republic Mall, Andheri West, Mumbai');

-- Insert Screens manually with IDs
INSERT INTO screens (id, theatre_id, screen_number, total_seats) VALUES
(1, 1, 1, 150),
(2, 1, 2, 180),
(3, 2, 1, 200),
(4, 3, 1, 160);

-- Important: Create sample seats for Screen 1 (10 rows x 15 seats = 150 seats)
-- Row A-J, Seats 1-15
INSERT INTO seats (screen_id, row_number, seat_number, seat_type) VALUES
(1, 'A', 1, 'GOLD'), (1, 'A', 2, 'GOLD'), (1, 'A', 3, 'GOLD'), (1, 'A', 4, 'GOLD'), (1, 'A', 5, 'GOLD'),
(1, 'A', 6, 'GOLD'), (1, 'A', 7, 'GOLD'), (1, 'A', 8, 'GOLD'), (1, 'A', 9, 'GOLD'), (1, 'A', 10, 'GOLD'),
(1, 'A', 11, 'GOLD'), (1, 'A', 12, 'GOLD'), (1, 'A', 13, 'GOLD'), (1, 'A', 14, 'GOLD'), (1, 'A', 15, 'GOLD'),

(1, 'B', 1, 'GOLD'), (1, 'B', 2, 'GOLD'), (1, 'B', 3, 'GOLD'), (1, 'B', 4, 'GOLD'), (1, 'B', 5, 'GOLD'),
(1, 'B', 6, 'GOLD'), (1, 'B', 7, 'GOLD'), (1, 'B', 8, 'GOLD'), (1, 'B', 9, 'GOLD'), (1, 'B', 10, 'GOLD'),
(1, 'B', 11, 'GOLD'), (1, 'B', 12, 'GOLD'), (1, 'B', 13, 'GOLD'), (1, 'B', 14, 'GOLD'), (1, 'B', 15, 'GOLD'),

(1, 'C', 1, 'GOLD'), (1, 'C', 2, 'GOLD'), (1, 'C', 3, 'GOLD'), (1, 'C', 4, 'GOLD'), (1, 'C', 5, 'GOLD'),
(1, 'C', 6, 'GOLD'), (1, 'C', 7, 'GOLD'), (1, 'C', 8, 'GOLD'), (1, 'C', 9, 'GOLD'), (1, 'C', 10, 'GOLD'),
(1, 'C', 11, 'GOLD'), (1, 'C', 12, 'GOLD'), (1, 'C', 13, 'GOLD'), (1, 'C', 14, 'GOLD'), (1, 'C', 15, 'GOLD'),

(1, 'D', 1, 'PLATINUM'), (1, 'D', 2, 'PLATINUM'), (1, 'D', 3, 'PLATINUM'), (1, 'D', 4, 'PLATINUM'), (1, 'D', 5, 'PLATINUM'),
(1, 'D', 6, 'PLATINUM'), (1, 'D', 7, 'PLATINUM'), (1, 'D', 8, 'PLATINUM'), (1, 'D', 9, 'PLATINUM'), (1, 'D', 10, 'PLATINUM'),
(1, 'D', 11, 'PLATINUM'), (1, 'D', 12, 'PLATINUM'), (1, 'D', 13, 'PLATINUM'), (1, 'D', 14, 'PLATINUM'), (1, 'D', 15, 'PLATINUM'),

(1, 'E', 1, 'PLATINUM'), (1, 'E', 2, 'PLATINUM'), (1, 'E', 3, 'PLATINUM'), (1, 'E', 4, 'PLATINUM'), (1, 'E', 5, 'PLATINUM'),
(1, 'E', 6, 'PLATINUM'), (1, 'E', 7, 'PLATINUM'), (1, 'E', 8, 'PLATINUM'), (1, 'E', 9, 'PLATINUM'), (1, 'E', 10, 'PLATINUM'),
(1, 'E', 11, 'PLATINUM'), (1, 'E', 12, 'PLATINUM'), (1, 'E', 13, 'PLATINUM'), (1, 'E', 14, 'PLATINUM'), (1, 'E', 15, 'PLATINUM'),

(1, 'F', 1, 'PLATINUM'), (1, 'F', 2, 'PLATINUM'), (1, 'F', 3, 'PLATINUM'), (1, 'F', 4, 'PLATINUM'), (1, 'F', 5, 'PLATINUM'),
(1, 'F', 6, 'PLATINUM'), (1, 'F', 7, 'PLATINUM'), (1, 'F', 8, 'PLATINUM'), (1, 'F', 9, 'PLATINUM'), (1, 'F', 10, 'PLATINUM'),
(1, 'F', 11, 'PLATINUM'), (1, 'F', 12, 'PLATINUM'), (1, 'F', 13, 'PLATINUM'), (1, 'F', 14, 'PLATINUM'), (1, 'F', 15, 'PLATINUM'),

(1, 'G', 1, 'SILVER'), (1, 'G', 2, 'SILVER'), (1, 'G', 3, 'SILVER'), (1, 'G', 4, 'SILVER'), (1, 'G', 5, 'SILVER'),
(1, 'G', 6, 'SILVER'), (1, 'G', 7, 'SILVER'), (1, 'G', 8, 'SILVER'), (1, 'G', 9, 'SILVER'), (1, 'G', 10, 'SILVER'),
(1, 'G', 11, 'SILVER'), (1, 'G', 12, 'SILVER'), (1, 'G', 13, 'SILVER'), (1, 'G', 14, 'SILVER'), (1, 'G', 15, 'SILVER'),

(1, 'H', 1, 'SILVER'), (1, 'H', 2, 'SILVER'), (1, 'H', 3, 'SILVER'), (1, 'H', 4, 'SILVER'), (1, 'H', 5, 'SILVER'),
(1, 'H', 6, 'SILVER'), (1, 'H', 7, 'SILVER'), (1, 'H', 8, 'SILVER'), (1, 'H', 9, 'SILVER'), (1, 'H', 10, 'SILVER'),
(1, 'H', 11, 'SILVER'), (1, 'H', 12, 'SILVER'), (1, 'H', 13, 'SILVER'), (1, 'H', 14, 'SILVER'), (1, 'H', 15, 'SILVER'),

(1, 'I', 1, 'SILVER'), (1, 'I', 2, 'SILVER'), (1, 'I', 3, 'SILVER'), (1, 'I', 4, 'SILVER'), (1, 'I', 5, 'SILVER'),
(1, 'I', 6, 'SILVER'), (1, 'I', 7, 'SILVER'), (1, 'I', 8, 'SILVER'), (1, 'I', 9, 'SILVER'), (1, 'I', 10, 'SILVER'),
(1, 'I', 11, 'SILVER'), (1, 'I', 12, 'SILVER'), (1, 'I', 13, 'SILVER'), (1, 'I', 14, 'SILVER'), (1, 'I', 15, 'SILVER'),

(1, 'J', 1, 'SILVER'), (1, 'J', 2, 'SILVER'), (1, 'J', 3, 'SILVER'), (1, 'J', 4, 'SILVER'), (1, 'J', 5, 'SILVER'),
(1, 'J', 6, 'SILVER'), (1, 'J', 7, 'SILVER'), (1, 'J', 8, 'SILVER'), (1, 'J', 9, 'SILVER'), (1, 'J', 10, 'SILVER'),
(1, 'J', 11, 'SILVER'), (1, 'J', 12, 'SILVER'), (1, 'J', 13, 'SILVER'), (1, 'J', 14, 'SILVER'), (1, 'J', 15, 'SILVER');

-- Insert Shows (Today's date with multiple timings)
INSERT INTO shows (movie_id, screen_id, show_date, show_time, price) VALUES
-- Pushpa 2 shows
(1, 1, CURDATE(), '10:00:00', 250.00),
(1, 1, CURDATE(), '14:00:00', 300.00),
(1, 1, CURDATE(), '18:30:00', 350.00),
(1, 1, CURDATE(), '22:00:00', 350.00),
(1, 2, CURDATE(), '11:00:00', 280.00),
(1, 2, CURDATE(), '19:00:00', 380.00),

-- Fighter shows
(2, 1, CURDATE(), '09:30:00', 200.00),
(2, 1, CURDATE(), '13:00:00', 250.00),
(2, 3, CURDATE(), '17:00:00', 300.00),
(2, 3, CURDATE(), '21:00:00', 300.00),

-- Salaar shows  
(3, 2, CURDATE(), '10:30:00', 220.00),
(3, 2, CURDATE(), '15:00:00', 270.00),
(3, 4, CURDATE(), '19:30:00', 320.00),

-- Animal shows
(4, 3, CURDATE(), '12:00:00', 240.00),
(4, 3, CURDATE(), '16:30:00', 290.00),
(4, 4, CURDATE(), '20:30:00', 340.00),

-- Dunki shows
(5, 4, CURDATE(), '11:30:00', 230.00),
(5, 4, CURDATE(), '15:30:00', 280.00),
(5, 1, CURDATE(), '19:00:00', 330.00);

-- Verification
SELECT '✅ Database populated successfully!' AS Status;
SELECT COUNT(*) AS 'Total Movies' FROM movies;
SELECT COUNT(*) AS 'Total Theatres' FROM theatres;
SELECT COUNT(*) AS 'Total Screens' FROM screens;
SELECT COUNT(*) AS 'Total Seats' FROM seats;
SELECT COUNT(*) AS 'Total Shows' FROM shows;
