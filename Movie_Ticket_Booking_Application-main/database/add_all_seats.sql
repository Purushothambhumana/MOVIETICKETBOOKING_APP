-- Complete script to add 150 seats to all screens (1-30)
-- This adds 10 rows (A-J) with 15 seats per row to each screen
-- Seats are categorized as PREMIUM (rows A-C), REGULAR (rows D-G), ECONOMY (rows H-J)

-- First, check current status
SELECT s.id as screen_id, s.screen_number, t.name as theatre_name, 
       COUNT(st.id) as current_seats
FROM screens s
JOIN theatres t ON s.theatre_id = t.id
LEFT JOIN seats st ON s.id = st.screen_id
GROUP BY s.id, s.screen_number, t.name
ORDER BY s.id;

-- Template for adding seats (will be repeated for each screen)
-- This uses a cross join to generate all combinations of rows and seat numbers

-- Screens 1-30
INSERT INTO seats (screen_id, row_number, seat_number, seat_type)
SELECT screen_id, row_label, seat_num, 
       CASE 
           WHEN row_label IN ('A','B','C') THEN 'PREMIUM'
           WHEN row_label IN ('D','E','F','G') THEN 'REGULAR'
           ELSE 'ECONOMY'
       END
FROM (
    SELECT 1 as screen_id UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
    UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
    UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
    UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25
    UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30
) screens
CROSS JOIN (
    SELECT 'A' as row_label UNION SELECT 'B' UNION SELECT 'C' UNION SELECT 'D' UNION SELECT 'E' 
    UNION SELECT 'F' UNION SELECT 'G' UNION SELECT 'H' UNION SELECT 'I' UNION SELECT 'J'
) rows
CROSS JOIN (
    SELECT 1 as seat_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
    UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
) seat_numbers
WHERE NOT EXISTS (
    SELECT 1 FROM seats WHERE seats.screen_id = screens.screen_id
);

-- Verify seats were added
SELECT s.id as screen_id, s.screen_number, t.name as theatre_name, 
       COUNT(st.id) as total_seats,
       SUM(CASE WHEN st.seat_type = 'PREMIUM' THEN 1 ELSE 0 END) as premium_seats,
       SUM(CASE WHEN st.seat_type = 'REGULAR' THEN 1 ELSE 0 END) as regular_seats,
       SUM(CASE WHEN st.seat_type = 'ECONOMY' THEN 1 ELSE 0 END) as economy_seats
FROM screens s
JOIN theatres t ON s.theatre_id = t.id
LEFT JOIN seats st ON s.id = st.screen_id
GROUP BY s.id, s.screen_number, t.name
ORDER BY s.id;
