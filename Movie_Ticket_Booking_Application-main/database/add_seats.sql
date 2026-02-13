-- Add Seats to All Screens
-- This will create seats for all existing screens

USE antipromovie;

-- ============================================
-- CREATE SEATS FOR ALL SCREENS
-- ============================================

-- This creates a seat layout with:
-- - 15 seats per row
-- - Rows labeled A, B, C, D, E, F, G, H, I, J (depending on screen capacity)
-- - Last 2 rows are PREMIUM seats, rest are REGULAR

INSERT IGNORE INTO seats (screen_id, `row_number`, seat_number, seat_type)
SELECT 
    s.id as screen_id,
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
-- SUMMARY
-- ============================================
SELECT '✅ Seats Created Successfully!' AS Status;

SELECT 
    COUNT(DISTINCT screen_id) AS 'Screens with Seats',
    COUNT(*) AS 'Total Seats Created',
    COUNT(CASE WHEN seat_type = 'REGULAR' THEN 1 END) AS 'Regular Seats',
    COUNT(CASE WHEN seat_type = 'PREMIUM' THEN 1 END) AS 'Premium Seats'
FROM seats;

-- Show breakdown by theatre
SELECT 
    t.name AS Theatre,
    t.city AS City,
    COUNT(DISTINCT s.id) AS Screens,
    COUNT(se.id) AS 'Total Seats'
FROM theatres t
JOIN screens s ON t.id = s.theatre_id
JOIN seats se ON s.id = se.screen_id
GROUP BY t.id, t.name, t.city
ORDER BY t.city, t.name
LIMIT 20;
