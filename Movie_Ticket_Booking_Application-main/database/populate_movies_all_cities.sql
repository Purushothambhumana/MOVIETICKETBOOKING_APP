-- Popular Movies with Real Poster Images - Like BookMyShow
-- Run this to add current popular movies with actual posters

-- Clear existing test data if needed
-- DELETE FROM shows;
-- DELETE FROM seats;
-- DELETE FROM screens;
-- DELETE FROM theatres WHERE city != 'Your_Protected_City';
-- DELETE FROM movies WHERE title LIKE '%Test%';

-- ============================================
-- INSERT POPULAR MOVIES WITH REAL IMAGES
-- ============================================

INSERT INTO movies (title, description, duration, language, genre, poster_url, release_date, status, certification) VALUES
-- Bollywood Blockbusters
('Pushpa 2: The Rule', 'The clash is on as Pushpa and Bhanwar Singh continue their rivalry in this epic conclusion to the two-part action drama.', 200, 'Hindi', 'Action/Drama', 'https://i.postimg.cc/jjy9Zd4D/pushpa2.jpg', '2024-12-05', 'NOW_SHOWING', 'A'),
('Dunki', 'A hilarious and heartwarming saga of a group of friends chasing their dreams through an illegal immigration technique called Donkey Flight.', 161, 'Hindi', 'Comedy/Drama', 'https://i.postimg.cc/zfkQfJ8p/dunki.jpg', '2023-12-21', 'NOW_SHOWING', 'U/A'),
('Salaar', 'In the city of Khansaar, Raja Mannar plans to make his son, Vardharaja Mannaar his successor, but his grandson Deva has other plans.', 175, 'Hindi', 'Action/Thriller', 'https://i.postimg.cc/DfWHyYbZ/salaar.jpg', '2023-12-22', 'NOW_SHOWING', 'A'),
('Animal', 'A son deeply loves his father, but an attack on the father triggers a transformation in the son.', 201, 'Hindi', 'Action/Crime', 'https://i.postimg.cc/L8yqLNhT/animal.jpg', '2023-12-01', 'NOW_SHOWING', 'A'),
('12th Fail', 'Based on the true story of IPS officer Manoj Kumar Sharma and IRS officer Shraddha Joshi.', 147, 'Hindi', 'Drama/Biography', 'https://i.postimg.cc/fR9qLKYN/12thfail.jpg', '2023-10-27', 'NOW_SHOWING', 'U/A'),
('Sam Bahadur', 'Revolves around the life of Sam Manekshaw, the first Field Marshal of India.', 150, 'Hindi', 'Biography/War', 'https://i.postimg.cc/g0XKfDKX/sambahadur.jpg', '2023-12-01', 'NOW_SHOWING', 'U/A'),

-- South Indian Blockbusters
('HanuMan', 'An imaginary place called Anjanadri where the protagonist gets the powers of Hanuman ji.', 158, 'Telugu', 'Action/Fantasy', 'https://i.postimg.cc/XYz1RQKp/hanuman.jpg', '2024-01-12', 'NOW_SHOWING', 'U/A'),
('Hi Nanna', 'A single father begins to narrate the story of missing mother to his child and nothing remains the same.', 155, 'Telugu', 'Drama/Romance', 'https://i.postimg.cc/3N7mYWLB/hinanna.jpg', '2023-12-07', 'NOW_SHOWING', 'U'),
('Guntur Kaaram', 'Years after his mother abandons him and remarries, a man demands answers when he is asked to sign a consent form declaring her dead.', 162, 'Telugu', 'Action/Drama', 'https://i.postimg.cc/15hqXy9c/gunturkaaram.jpg', '2024-01-12', 'NOW_SHOWING', 'U/A'),
('Captain Miller', 'Set in 1930s-1940s in British India, an outlaw tries to protect his village against the British.', 157, 'Tamil', 'Action/Period', 'https://i.postimg.cc/DZnMYyDG/captainmiller.jpg', '2024-01-12', 'NOW_SHOWING', 'U/A'),

-- Hollywood Blockbusters  
('Wonka', 'With dreams of opening a shop, a young Willy Wonka discovers the chocolate cartel has locked up the market.', 116, 'English', 'Fantasy/Musical', 'https://i.postimg.cc/MGzmdb3J/wonka.jpg', '2023-12-15', 'NOW_SHOWING', 'U'),
('Aquaman 2', 'Aquaman balances his duties as king and as a member of the Justice League while planning a wedding.', 124, 'English', 'Action/Adventure', 'https://i.postimg.cc/wT0hTH4M/aquaman2.jpg', '2023-12-22', 'NOW_SHOWING', 'U/A'),
('The Marvels', 'Carol Danvers gets her powers entangled with two other superheroes to save the universe.', 105, 'English', 'Action/Sci-Fi', 'https://i.postimg.cc/sfG7yZ4b/marvels.jpg', '2023-11-10', 'NOW_SHOWING', 'U/A'),

-- COMING SOON
('Fighter', 'Indias first aerial action film featuring dogfights and air strikes.', 166, 'Hindi', 'Action/Thriller', 'https://i.postimg.cc/vBxZvZ9G/fighter.jpg', '2024-01-25', 'COMING_SOON', 'U/A'),
('Bade Miyan Chote Miyan', 'Two elite soldiers with their own approach must work together to recover stolen weapons.', 145, 'Hindi', 'Action/Comedy', 'https://i.postimg.cc/8cLLQn4Y/bmcm.jpg', '2024-04-10', 'COMING_SOON', 'U/A'),
('Yodha', 'A soldier on a hijacked plane fights against terrorists to save passengers.', 140, 'Hindi', 'Action/Thriller', 'https://i.postimg.cc/ry4mSZLJ/yodha.jpg', '2024-03-15', 'COMING_SOON', 'U/A')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- ============================================
-- INSERT THEATRES IN MAJOR CITIES
-- ============================================
INSERT INTO theatres (name, city, address) VALUES
-- Mumbai (3 theatres)
('PVR Phoenix Palladium', 'Mumbai', 'Phoenix Palladium Mall, Lower Parel'),
('INOX R-City Mall', 'Mumbai', 'R-City Mall, Ghatkopar'),
('Cinepolis Andheri', 'Mumbai', 'Fun Republic Mall, Andheri West'),

-- Delhi (3 theatres)
('PVR Select City Walk', 'Delhi', 'Saket District Centre'),
('Cinepolis DLF Place', 'Delhi', 'DLF Place Mall, Saket'),
('INOX Connaught Place', 'Delhi', 'CP, Inner Circle'),

-- Bangalore (3 theatres)
('PVR Forum Mall', 'Bangalore', 'Forum Mall, Koramangala'),
('INOX Lido Mall', 'Bangalore', 'MG Road'),
('Cinepolis Central', 'Bangalore', 'Central Mall, Bellandur'),

-- Hyderabad (3 theatres)
('PVR Next Galleria', 'Hyderabad', 'Panjagutta'),
('AMB Cinemas', 'Hyderabad', 'Gachibowli'),
('Cinepolis Mantra Mall', 'Hyderabad', 'Attapur'),

-- Chennai (3 theatres)
('PVR Grand Galada', 'Chennai', 'Pallavaram'),
('INOX Escape', 'Chennai', 'Express Avenue Mall'),
('Luxe Cinemas', 'Chennai', 'Phoenix Marketcity'),

-- Pune (3 theatres)
('PVR Phoenix Marketcity', 'Pune', 'Viman Nagar'),
('INOX Bund Garden', 'Pune', 'Bund Garden Road'),
('Cinepolis Seasons Mall', 'Pune', 'Magarpatta City'),

-- Kolkata (2 theatres)
('INOX South City', 'Kolkata', 'Prince Anwar Shah Road'),
('PVR Mani Square', 'Kolkata', 'EM Bypass'),

-- Ahmedabad (2 theatres)
('PVR Acropolis Mall', 'Ahmedabad', 'Thaltej'),
('Cinepolis Ahmedabad One', 'Ahmedabad', 'Vastrapur')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- ============================================
-- CREATE SCREENS (3 per theatre)
-- ============================================
INSERT INTO screens (theatre_id, screen_number, total_seats)
SELECT t.id, 1, 150 
FROM theatres t 
WHERE t.name IN (SELECT name FROM theatres)
ON DUPLICATE KEY UPDATE screen_number=VALUES(screen_number);

INSERT INTO screens (theatre_id, screen_number, total_seats)
SELECT t.id, 2, 200 
FROM theatres t 
WHERE t.name IN (SELECT name FROM theatres)
ON DUPLICATE KEY UPDATE screen_number=VALUES(screen_number);

INSERT INTO screens (theatre_id, screen_number, total_seats)
SELECT t.id, 3, 120 
FROM theatres t 
WHERE t.name IN (SELECT name FROM theatres)
ON DUPLICATE KEY UPDATE screen_number=VALUES(screen_number);

-- ============================================
-- CREATE SEATS FOR ALL SCREENS
-- ============================================
-- This creates seats A1-A15, B1-B15, etc. for each screen

INSERT IGNORE INTO seats (screen_id, row_letter, seat_number, seat_type)
SELECT s.id, 
       CHAR(64 + FLOOR((n-1)/15) + 1) as row_letter,
       ((n-1) % 15) + 1 as seat_number,
       CASE 
           WHEN FLOOR((n-1)/15) >= (s.total_seats/15 - 2) THEN 'PREMIUM'
           ELSE 'REGULAR'
       END as seat_type
FROM screens s
CROSS JOIN (
    SELECT @row := @row + 1 as n
    FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t3,
         (SELECT @row:=0) t4
) numbers
WHERE n <= s.total_seats;

-- ============================================
-- CREATE SHOWS FOR TODAY AND TOMORROW
-- ============================================

-- Today's shows - Morning (10:00 AM)
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '10:00:00',
       CASE WHEN m.language = 'English' THEN 300.00 ELSE 200.00 END
FROM movies m
CROSS JOIN screens s
WHERE m.status = 'NOW_SHOWING' AND s.screen_number = 1
LIMIT 50;

-- Today's shows - Afternoon (14:00 PM)
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '14:00:00',
       CASE WHEN m.language = 'English' THEN 350.00 ELSE 250.00 END
FROM movies m
CROSS JOIN screens s
WHERE m.status = 'NOW_SHOWING' AND s.screen_number = 2
LIMIT 50;

-- Today's shows - Evening (18:30 PM)
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '18:30:00',
       CASE WHEN m.language = 'English' THEN 400.00 ELSE 300.00 END
FROM movies m
CROSS JOIN screens s
WHERE m.status = 'NOW_SHOWING' AND s.screen_number = 3
LIMIT 50;

-- Today's shows - Night (21:30 PM)
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '21:30:00',
       CASE WHEN m.language = 'English' THEN 450.00 ELSE 350.00 END
FROM movies m
CROSS JOIN screens s
WHERE m.status = 'NOW_SHOWING' AND s.screen_number = 1
LIMIT 50;

-- Tomorrow's shows
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00:00',
       CASE WHEN m.language = 'English' THEN 300.00 ELSE 200.00 END
FROM movies m
CROSS JOIN screens s
WHERE m.status = 'NOW_SHOWING'
LIMIT 100;

-- Show summary
SELECT 'Data populated successfully!' AS Status;
SELECT COUNT(*) AS 'Total Movies' FROM movies;
SELECT COUNT(*) AS 'Total Theatres' FROM theatres;
SELECT COUNT(*) AS 'Total Screens' FROM screens;
SELECT COUNT(*) AS 'Total Seats' FROM seats;
SELECT COUNT(*) AS 'Total Shows' FROM shows;
