-- Simplified script to add seats to all screens
-- Run this in MySQL Workbench or command line

-- Check current seat counts
SELECT s.id as screen_id, s.screen_number, t.name as theatre_name, 
       COUNT(st.id) as current_seats
FROM screens s
JOIN theatres t ON s.theatre_id = t.id
LEFT JOIN seats st ON s.id = st.screen_id
GROUP BY s.id, s.screen_number, t.name
ORDER BY s.id;

-- Add seats for each screen (modify screen IDs as needed)
-- This adds 150 seats (10 rows A-J, 15 seats per row) to each screen

-- For Screen 1
INSERT INTO seats (screen_id, row_number, seat_number, seat_type)
SELECT 1, row_label, seat_num, 
       CASE 
           WHEN row_label IN ('A','B','C') THEN 'PREMIUM'
           WHEN row_label IN ('D','E','F','G') THEN 'REGULAR'
           ELSE 'ECONOMY'
       END
FROM (
    SELECT 'A' as row_label UNION SELECT 'B' UNION SELECT 'C' UNION SELECT 'D' UNION SELECT 'E' 
    UNION SELECT 'F' UNION SELECT 'G' UNION SELECT 'H' UNION SELECT 'I' UNION SELECT 'J'
) rows
CROSS JOIN (
    SELECT 1 as seat_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
    UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
) seats
WHERE NOT EXISTS (SELECT 1 FROM seats WHERE screen_id = 1);

-- Repeat for other screens (change screen_id)
-- For Screen 2
INSERT INTO seats (screen_id, row_number, seat_number, seat_type)
SELECT 2, row_label, seat_num, 
       CASE 
           WHEN row_label IN ('A','B','C') THEN 'PREMIUM'
           WHEN row_label IN ('D','E','F','G') THEN 'REGULAR'
           ELSE 'ECONOMY'
       END
FROM (
    SELECT 'A' as row_label UNION SELECT 'B' UNION SELECT 'C' UNION SELECT 'D' UNION SELECT 'E' 
    UNION SELECT 'F' UNION SELECT 'G' UNION SELECT 'H' UNION SELECT 'I' UNION SELECT 'J'
) rows
CROSS JOIN (
    SELECT 1 as seat_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
    UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
) seats
WHERE NOT EXISTS (SELECT 1 FROM seats WHERE screen_id = 2);

-- Continue for screens 3-20 (copy and change screen_id)
-- You can run this for each screen ID you have

-- Verify seats were added
SELECT s.id as screen_id, s.screen_number, t.name as theatre_name, 
       COUNT(st.id) as total_seats
FROM screens s
JOIN theatres t ON s.theatre_id = t.id
LEFT JOIN seats st ON s.id = st.screen_id
GROUP BY s.id, s.screen_number, t.name
ORDER BY s.id;
