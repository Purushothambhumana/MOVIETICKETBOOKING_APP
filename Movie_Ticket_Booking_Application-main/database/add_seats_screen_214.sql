-- Add seats to screen 214 (the screen for show 258480)
-- This will create 150 seats (10 rows × 15 seats per row)

DELETE FROM seats WHERE screen_id = 214;

-- Premium seats (Rows A-C, seats 1-15)
INSERT INTO seats (screen_id, row_number, seat_number, seat_type) VALUES
-- Row A
(214, 'A', 1, 'PREMIUM'), (214, 'A', 2, 'PREMIUM'), (214, 'A', 3, 'PREMIUM'), (214, 'A', 4, 'PREMIUM'), (214, 'A', 5, 'PREMIUM'),
(214, 'A', 6, 'PREMIUM'), (214, 'A', 7, 'PREMIUM'), (214, 'A', 8, 'PREMIUM'), (214, 'A', 9, 'PREMIUM'), (214, 'A', 10, 'PREMIUM'),
(214, 'A', 11, 'PREMIUM'), (214, 'A', 12, 'PREMIUM'), (214, 'A', 13, 'PREMIUM'), (214, 'A', 14, 'PREMIUM'), (214, 'A', 15, 'PREMIUM'),
-- Row B
(214, 'B', 1, 'PREMIUM'), (214, 'B', 2, 'PREMIUM'), (214, 'B', 3, 'PREMIUM'), (214, 'B', 4, 'PREMIUM'), (214, 'B', 5, 'PREMIUM'),
(214, 'B', 6, 'PREMIUM'), (214, 'B', 7, 'PREMIUM'), (214, 'B', 8, 'PREMIUM'), (214, 'B', 9, 'PREMIUM'), (214, 'B', 10, 'PREMIUM'),
(214, 'B', 11, 'PREMIUM'), (214, 'B', 12, 'PREMIUM'), (214, 'B', 13, 'PREMIUM'), (214, 'B', 14, 'PREMIUM'), (214, 'B', 15, 'PREMIUM'),
-- Row C
(214, 'C', 1, 'PREMIUM'), (214, 'C', 2, 'PREMIUM'), (214, 'C', 3, 'PREMIUM'), (214, 'C', 4, 'PREMIUM'), (214, 'C', 5, 'PREMIUM'),
(214, 'C', 6, 'PREMIUM'), (214, 'C', 7, 'PREMIUM'), (214, 'C', 8, 'PREMIUM'), (214, 'C', 9, 'PREMIUM'), (214, 'C', 10, 'PREMIUM'),
(214, 'C', 11, 'PREMIUM'), (214, 'C', 12, 'PREMIUM'), (214, 'C', 13, 'PREMIUM'), (214, 'C', 14, 'PREMIUM'), (214, 'C', 15, 'PREMIUM');

-- Regular seats (Rows D-G, seats 1-15)
INSERT INTO seats (screen_id, row_number, seat_number, seat_type) VALUES
-- Row D
(214, 'D', 1, 'REGULAR'), (214, 'D', 2, 'REGULAR'), (214, 'D', 3, 'REGULAR'), (214, 'D', 4, 'REGULAR'), (214, 'D', 5, 'REGULAR'),
(214, 'D', 6, 'REGULAR'), (214, 'D', 7, 'REGULAR'), (214, 'D', 8, 'REGULAR'), (214, 'D', 9, 'REGULAR'), (214, 'D', 10, 'REGULAR'),
(214, 'D', 11, 'REGULAR'), (214, 'D', 12, 'REGULAR'), (214, 'D', 13, 'REGULAR'), (214, 'D', 14, 'REGULAR'), (214, 'D', 15, 'REGULAR'),
-- Row E
(214, 'E', 1, 'REGULAR'), (214, 'E', 2, 'REGULAR'), (214, 'E', 3, 'REGULAR'), (214, 'E', 4, 'REGULAR'), (214, 'E', 5, 'REGULAR'),
(214, 'E', 6, 'REGULAR'), (214, 'E', 7, 'REGULAR'), (214, 'E', 8, 'REGULAR'), (214, 'E', 9, 'REGULAR'), (214, 'E', 10, 'REGULAR'),
(214, 'E', 11, 'REGULAR'), (214, 'E', 12, 'REGULAR'), (214, 'E', 13, 'REGULAR'), (214, 'E', 14, 'REGULAR'), (214, 'E', 15, 'REGULAR'),
-- Row F
(214, 'F', 1, 'REGULAR'), (214, 'F', 2, 'REGULAR'), (214, 'F', 3, 'REGULAR'), (214, 'F', 4, 'REGULAR'), (214, 'F', 5, 'REGULAR'),
(214, 'F', 6, 'REGULAR'), (214, 'F', 7, 'REGULAR'), (214, 'F', 8, 'REGULAR'), (214, 'F', 9, 'REGULAR'), (214, 'F', 10, 'REGULAR'),
(214, 'F', 11, 'REGULAR'), (214, 'F', 12, 'REGULAR'), (214, 'F', 13, 'REGULAR'), (214, 'F', 14, 'REGULAR'), (214, 'F', 15, 'REGULAR'),
-- Row G
(214, 'G', 1, 'REGULAR'), (214, 'G', 2, 'REGULAR'), (214, 'G', 3, 'REGULAR'), (214, 'G', 4, 'REGULAR'), (214, 'G', 5, 'REGULAR'),
(214, 'G', 6, 'REGULAR'), (214, 'G', 7, 'REGULAR'), (214, 'G', 8, 'REGULAR'), (214, 'G', 9, 'REGULAR'), (214, 'G', 10, 'REGULAR'),
(214, 'G', 11, 'REGULAR'), (214, 'G', 12, 'REGULAR'), (214, 'G', 13, 'REGULAR'), (214, 'G', 14, 'REGULAR'), (214, 'G', 15, 'REGULAR');

-- Economy seats (Rows H-J, seats 1-15)
INSERT INTO seats (screen_id, row_number, seat_number, seat_type) VALUES
-- Row H
(214, 'H', 1, 'ECONOMY'), (214, 'H', 2, 'ECONOMY'), (214, 'H', 3, 'ECONOMY'), (214, 'H', 4, 'ECONOMY'), (214, 'H', 5, 'ECONOMY'),
(214, 'H', 6, 'ECONOMY'), (214, 'H', 7, 'ECONOMY'), (214, 'H', 8, 'ECONOMY'), (214, 'H', 9, 'ECONOMY'), (214, 'H', 10, 'ECONOMY'),
(214, 'H', 11, 'ECONOMY'), (214, 'H', 12, 'ECONOMY'), (214, 'H', 13, 'ECONOMY'), (214, 'H', 14, 'ECONOMY'), (214, 'H', 15, 'ECONOMY'),
-- Row I
(214, 'I', 1, 'ECONOMY'), (214, 'I', 2, 'ECONOMY'), (214, 'I', 3, 'ECONOMY'), (214, 'I', 4, 'ECONOMY'), (214, 'I', 5, 'ECONOMY'),
(214, 'I', 6, 'ECONOMY'), (214, 'I', 7, 'ECONOMY'), (214, 'I', 8, 'ECONOMY'), (214, 'I', 9, 'ECONOMY'), (214, 'I', 10, 'ECONOMY'),
(214, 'I', 11, 'ECONOMY'), (214, 'I', 12, 'ECONOMY'), (214, 'I', 13, 'ECONOMY'), (214, 'I', 14, 'ECONOMY'), (214, 'I', 15, 'ECONOMY'),
-- Row J
(214, 'J', 1, 'ECONOMY'), (214, 'J', 2, 'ECONOMY'), (214, 'J', 3, 'ECONOMY'), (214, 'J', 4, 'ECONOMY'), (214, 'J', 5, 'ECONOMY'),
(214, 'J', 6, 'ECONOMY'), (214, 'J', 7, 'ECONOMY'), (214, 'J', 8, 'ECONOMY'), (214, 'J', 9, 'ECONOMY'), (214, 'J', 10, 'ECONOMY'),
(214, 'J', 11, 'ECONOMY'), (214, 'J', 12, 'ECONOMY'), (214, 'J', 13, 'ECONOMY'), (214, 'J', 14, 'ECONOMY'), (214, 'J', 15, 'ECONOMY');

-- Verify seats were added
SELECT screen_id, COUNT(*) as total_seats,
       SUM(CASE WHEN seat_type = 'PREMIUM' THEN 1 ELSE 0 END) as premium_seats,
       SUM(CASE WHEN seat_type = 'REGULAR' THEN 1 ELSE 0 END) as regular_seats,
       SUM(CASE WHEN seat_type = 'ECONOMY' THEN 1 ELSE 0 END) as economy_seats
FROM seats
WHERE screen_id = 214
GROUP BY screen_id;
