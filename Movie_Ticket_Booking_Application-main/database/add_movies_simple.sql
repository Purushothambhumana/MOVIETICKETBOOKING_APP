-- SIMPLE SCRIPT - Just insert movies with images
-- Copy all of this and paste into your MySQL client

USE antipromovie;

-- Add popular movies with poster images
INSERT INTO movies (title, description, duration, language, genre, poster_url, release_date, status, certification) VALUES
('Pushpa 2: The Rule', 'The clash is on as Pushpa and Bhanwar Singh continue their rivalry', 200, 'Hindi', 'Action/Drama', 'https://i.postimg.cc/jjy9Zd4D/pushpa2.jpg', '2024-12-05', 'NOW_SHOWING', 'A'),
('Animal', 'A sons love for his father leads him down a dark path', 201, 'Hindi', 'Action/Crime', 'https://i.postimg.cc/L8yqLNhT/animal.jpg', '2023-12-01', 'NOW_SHOWING', 'A'),
('Wonka', 'The origin story of Willy Wonka', 116, 'English', 'Fantasy/Musical', 'https://i.postimg.cc/MGzmdb3J/wonka.jpg', '2023-12-15', 'NOW_SHOWING', 'U'),
('Dunki', 'A hilarious saga of friends chasing dreams', 161, 'Hindi', 'Comedy/Drama', 'https://i.postimg.cc/zfkQfJ8p/dunki.jpg', '2023-12-21', 'NOW_SHOWING', 'U/A'),
('Salaar', 'Raja Mannar plans to make his son successor', 175, 'Hindi', 'Action/Thriller', 'https://i.postimg.cc/DfWHyYbZ/salaar.jpg', '2023-12-22', 'NOW_SHOWING', 'A'),
('12th Fail', 'Based on true story of IPS officer', 147, 'Hindi', 'Drama/Biography', 'https://i.postimg.cc/fR9qLKYN/12thfail.jpg', '2023-10-27', 'NOW_SHOWING', 'U/A'),
('HanuMan', 'Protagonist gets powers of Hanuman', 158, 'Telugu', 'Action/Fantasy', 'https://i.postimg.cc/XYz1RQKp/hanuman.jpg', '2024-01-12', 'NOW_SHOWING', 'U/A'),
('Hi Nanna', 'A single father and missing mother story', 155, 'Telugu', 'Drama/Romance', 'https://i.postimg.cc/3N7mYWLB/hinanna.jpg', '2023-12-07', 'NOW_SHOWING', 'U'),
('Fighter', 'Indias first aerial action film', 166, 'Hindi', 'Action/Thriller', 'https://i.postimg.cc/vBxZvZ9G/fighter.jpg', '2024-01-25', 'COMING_SOON', 'U/A'),
('Aquaman 2', 'Aquaman balances duties as king', 124, 'English', 'Action/Adventure', 'https://i.postimg.cc/wT0hTH4M/aquaman2.jpg', '2023-12-22', 'NOW_SHOWING', 'U/A');

-- Check what was added
SELECT id, title, language, status FROM movies ORDER BY id DESC LIMIT 10;
