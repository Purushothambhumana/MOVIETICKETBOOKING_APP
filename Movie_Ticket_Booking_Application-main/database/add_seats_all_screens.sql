-- Add 150 seats to ALL screens in the database
-- This ensures every movie, every theatre, every timing has seats available
-- Each screen gets: 45 Premium (A-C), 60 Regular (D-G), 45 Economy (H-J)

-- First, clear any existing seats
DELETE FROM seats;

-- Get all screen IDs and add seats to each
-- This uses a stored procedure approach for efficiency

DELIMITER $$

DROP PROCEDURE IF EXISTS add_seats_to_all_screens$$

CREATE PROCEDURE add_seats_to_all_screens()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE screen_id_var BIGINT;
    DECLARE cur CURSOR FOR SELECT id FROM screens;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO screen_id_var;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Premium seats (Rows A-C, 15 seats each = 45 total)
        INSERT INTO seats (screen_id, row_number, seat_number, seat_type) VALUES
        (screen_id_var, 'A', 1, 'PREMIUM'), (screen_id_var, 'A', 2, 'PREMIUM'), (screen_id_var, 'A', 3, 'PREMIUM'), 
        (screen_id_var, 'A', 4, 'PREMIUM'), (screen_id_var, 'A', 5, 'PREMIUM'), (screen_id_var, 'A', 6, 'PREMIUM'), 
        (screen_id_var, 'A', 7, 'PREMIUM'), (screen_id_var, 'A', 8, 'PREMIUM'), (screen_id_var, 'A', 9, 'PREMIUM'), 
        (screen_id_var, 'A', 10, 'PREMIUM'), (screen_id_var, 'A', 11, 'PREMIUM'), (screen_id_var, 'A', 12, 'PREMIUM'), 
        (screen_id_var, 'A', 13, 'PREMIUM'), (screen_id_var, 'A', 14, 'PREMIUM'), (screen_id_var, 'A', 15, 'PREMIUM'),
        
        (screen_id_var, 'B', 1, 'PREMIUM'), (screen_id_var, 'B', 2, 'PREMIUM'), (screen_id_var, 'B', 3, 'PREMIUM'), 
        (screen_id_var, 'B', 4, 'PREMIUM'), (screen_id_var, 'B', 5, 'PREMIUM'), (screen_id_var, 'B', 6, 'PREMIUM'), 
        (screen_id_var, 'B', 7, 'PREMIUM'), (screen_id_var, 'B', 8, 'PREMIUM'), (screen_id_var, 'B', 9, 'PREMIUM'), 
        (screen_id_var, 'B', 10, 'PREMIUM'), (screen_id_var, 'B', 11, 'PREMIUM'), (screen_id_var, 'B', 12, 'PREMIUM'), 
        (screen_id_var, 'B', 13, 'PREMIUM'), (screen_id_var, 'B', 14, 'PREMIUM'), (screen_id_var, 'B', 15, 'PREMIUM'),
        
        (screen_id_var, 'C', 1, 'PREMIUM'), (screen_id_var, 'C', 2, 'PREMIUM'), (screen_id_var, 'C', 3, 'PREMIUM'), 
        (screen_id_var, 'C', 4, 'PREMIUM'), (screen_id_var, 'C', 5, 'PREMIUM'), (screen_id_var, 'C', 6, 'PREMIUM'), 
        (screen_id_var, 'C', 7, 'PREMIUM'), (screen_id_var, 'C', 8, 'PREMIUM'), (screen_id_var, 'C', 9, 'PREMIUM'), 
        (screen_id_var, 'C', 10, 'PREMIUM'), (screen_id_var, 'C', 11, 'PREMIUM'), (screen_id_var, 'C', 12, 'PREMIUM'), 
        (screen_id_var, 'C', 13, 'PREMIUM'), (screen_id_var, 'C', 14, 'PREMIUM'), (screen_id_var, 'C', 15, 'PREMIUM');

        -- Regular seats (Rows D-G, 15 seats each = 60 total)
        INSERT INTO seats (screen_id, row_number, seat_number, seat_type) VALUES
        (screen_id_var, 'D', 1, 'REGULAR'), (screen_id_var, 'D', 2, 'REGULAR'), (screen_id_var, 'D', 3, 'REGULAR'), 
        (screen_id_var, 'D', 4, 'REGULAR'), (screen_id_var, 'D', 5, 'REGULAR'), (screen_id_var, 'D', 6, 'REGULAR'), 
        (screen_id_var, 'D', 7, 'REGULAR'), (screen_id_var, 'D', 8, 'REGULAR'), (screen_id_var, 'D', 9, 'REGULAR'), 
        (screen_id_var, 'D', 10, 'REGULAR'), (screen_id_var, 'D', 11, 'REGULAR'), (screen_id_var, 'D', 12, 'REGULAR'), 
        (screen_id_var, 'D', 13, 'REGULAR'), (screen_id_var, 'D', 14, 'REGULAR'), (screen_id_var, 'D', 15, 'REGULAR'),
        
        (screen_id_var, 'E', 1, 'REGULAR'), (screen_id_var, 'E', 2, 'REGULAR'), (screen_id_var, 'E', 3, 'REGULAR'), 
        (screen_id_var, 'E', 4, 'REGULAR'), (screen_id_var, 'E', 5, 'REGULAR'), (screen_id_var, 'E', 6, 'REGULAR'), 
        (screen_id_var, 'E', 7, 'REGULAR'), (screen_id_var, 'E', 8, 'REGULAR'), (screen_id_var, 'E', 9, 'REGULAR'), 
        (screen_id_var, 'E', 10, 'REGULAR'), (screen_id_var, 'E', 11, 'REGULAR'), (screen_id_var, 'E', 12, 'REGULAR'), 
        (screen_id_var, 'E', 13, 'REGULAR'), (screen_id_var, 'E', 14, 'REGULAR'), (screen_id_var, 'E', 15, 'REGULAR'),
        
        (screen_id_var, 'F', 1, 'REGULAR'), (screen_id_var, 'F', 2, 'REGULAR'), (screen_id_var, 'F', 3, 'REGULAR'), 
        (screen_id_var, 'F', 4, 'REGULAR'), (screen_id_var, 'F', 5, 'REGULAR'), (screen_id_var, 'F', 6, 'REGULAR'), 
        (screen_id_var, 'F', 7, 'REGULAR'), (screen_id_var, 'F', 8, 'REGULAR'), (screen_id_var, 'F', 9, 'REGULAR'), 
        (screen_id_var, 'F', 10, 'REGULAR'), (screen_id_var, 'F', 11, 'REGULAR'), (screen_id_var, 'F', 12, 'REGULAR'), 
        (screen_id_var, 'F', 13, 'REGULAR'), (screen_id_var, 'F', 14, 'REGULAR'), (screen_id_var, 'F', 15, 'REGULAR'),
        
        (screen_id_var, 'G', 1, 'REGULAR'), (screen_id_var, 'G', 2, 'REGULAR'), (screen_id_var, 'G', 3, 'REGULAR'), 
        (screen_id_var, 'G', 4, 'REGULAR'), (screen_id_var, 'G', 5, 'REGULAR'), (screen_id_var, 'G', 6, 'REGULAR'), 
        (screen_id_var, 'G', 7, 'REGULAR'), (screen_id_var, 'G', 8, 'REGULAR'), (screen_id_var, 'G', 9, 'REGULAR'), 
        (screen_id_var, 'G', 10, 'REGULAR'), (screen_id_var, 'G', 11, 'REGULAR'), (screen_id_var, 'G', 12, 'REGULAR'), 
        (screen_id_var, 'G', 13, 'REGULAR'), (screen_id_var, 'G', 14, 'REGULAR'), (screen_id_var, 'G', 15, 'REGULAR');

        -- Economy seats (Rows H-J, 15 seats each = 45 total)
        INSERT INTO seats (screen_id, row_number, seat_number, seat_type) VALUES
        (screen_id_var, 'H', 1, 'ECONOMY'), (screen_id_var, 'H', 2, 'ECONOMY'), (screen_id_var, 'H', 3, 'ECONOMY'), 
        (screen_id_var, 'H', 4, 'ECONOMY'), (screen_id_var, 'H', 5, 'ECONOMY'), (screen_id_var, 'H', 6, 'ECONOMY'), 
        (screen_id_var, 'H', 7, 'ECONOMY'), (screen_id_var, 'H', 8, 'ECONOMY'), (screen_id_var, 'H', 9, 'ECONOMY'), 
        (screen_id_var, 'H', 10, 'ECONOMY'), (screen_id_var, 'H', 11, 'ECONOMY'), (screen_id_var, 'H', 12, 'ECONOMY'), 
        (screen_id_var, 'H', 13, 'ECONOMY'), (screen_id_var, 'H', 14, 'ECONOMY'), (screen_id_var, 'H', 15, 'ECONOMY'),
        
        (screen_id_var, 'I', 1, 'ECONOMY'), (screen_id_var, 'I', 2, 'ECONOMY'), (screen_id_var, 'I', 3, 'ECONOMY'), 
        (screen_id_var, 'I', 4, 'ECONOMY'), (screen_id_var, 'I', 5, 'ECONOMY'), (screen_id_var, 'I', 6, 'ECONOMY'), 
        (screen_id_var, 'I', 7, 'ECONOMY'), (screen_id_var, 'I', 8, 'ECONOMY'), (screen_id_var, 'I', 9, 'ECONOMY'), 
        (screen_id_var, 'I', 10, 'ECONOMY'), (screen_id_var, 'I', 11, 'ECONOMY'), (screen_id_var, 'I', 12, 'ECONOMY'), 
        (screen_id_var, 'I', 13, 'ECONOMY'), (screen_id_var, 'I', 14, 'ECONOMY'), (screen_id_var, 'I', 15, 'ECONOMY'),
        
        (screen_id_var, 'J', 1, 'ECONOMY'), (screen_id_var, 'J', 2, 'ECONOMY'), (screen_id_var, 'J', 3, 'ECONOMY'), 
        (screen_id_var, 'J', 4, 'ECONOMY'), (screen_id_var, 'J', 5, 'ECONOMY'), (screen_id_var, 'J', 6, 'ECONOMY'), 
        (screen_id_var, 'J', 7, 'ECONOMY'), (screen_id_var, 'J', 8, 'ECONOMY'), (screen_id_var, 'J', 9, 'ECONOMY'), 
        (screen_id_var, 'J', 10, 'ECONOMY'), (screen_id_var, 'J', 11, 'ECONOMY'), (screen_id_var, 'J', 12, 'ECONOMY'), 
        (screen_id_var, 'J', 13, 'ECONOMY'), (screen_id_var, 'J', 14, 'ECONOMY'), (screen_id_var, 'J', 15, 'ECONOMY');

    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

-- Execute the procedure
CALL add_seats_to_all_screens();

-- Drop the procedure after use
DROP PROCEDURE IF EXISTS add_seats_to_all_screens;

-- Show summary
SELECT 
    'Seats added successfully!' as status,
    COUNT(DISTINCT screen_id) as total_screens,
    COUNT(*) as total_seats,
    SUM(CASE WHEN seat_type = 'PREMIUM' THEN 1 ELSE 0 END) as premium_seats,
    SUM(CASE WHEN seat_type = 'REGULAR' THEN 1 ELSE 0 END) as regular_seats,
    SUM(CASE WHEN seat_type = 'ECONOMY' THEN 1 ELSE 0 END) as economy_seats
FROM seats;
