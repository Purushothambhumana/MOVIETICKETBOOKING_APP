-- Script to add seats to existing screens that don't have seats
-- This creates 10 rows (A-J) with 15 seats per row (150 total seats per screen)

-- First, let's see which screens don't have seats
SELECT s.id, s.screen_number, t.name as theatre_name, 
       (SELECT COUNT(*) FROM seats WHERE screen_id = s.id) as seat_count
FROM screens s
JOIN theatres t ON s.theatre_id = t.id
ORDER BY s.id;

-- Create seats for screens that have 0 seats
-- This uses a stored procedure approach

DELIMITER $$

DROP PROCEDURE IF EXISTS create_seats_for_screen$$

CREATE PROCEDURE create_seats_for_screen(IN p_screen_id BIGINT)
BEGIN
    DECLARE v_row_num INT DEFAULT 0;
    DECLARE v_seat_num INT;
    DECLARE v_row_label CHAR(1);
    DECLARE v_seat_type VARCHAR(20);
    
    -- Row labels A through J
    DECLARE row_labels VARCHAR(10) DEFAULT 'ABCDEFGHIJ';
    
    -- Create 10 rows with 15 seats each
    WHILE v_row_num < 10 DO
        SET v_row_label = SUBSTRING(row_labels, v_row_num + 1, 1);
        SET v_seat_num = 1;
        
        -- Determine seat type based on row
        IF v_row_num < 3 THEN
            SET v_seat_type = 'PREMIUM';
        ELSEIF v_row_num < 7 THEN
            SET v_seat_type = 'REGULAR';
        ELSE
            SET v_seat_type = 'ECONOMY';
        END IF;
        
        -- Create 15 seats for this row
        WHILE v_seat_num <= 15 DO
            INSERT INTO seats (screen_id, row_number, seat_number, seat_type)
            VALUES (p_screen_id, v_row_label, v_seat_num, v_seat_type);
            
            SET v_seat_num = v_seat_num + 1;
        END WHILE;
        
        SET v_row_num = v_row_num + 1;
    END WHILE;
END$$

DELIMITER ;

-- Now call the procedure for each screen that has no seats
-- Get all screen IDs that need seats
SET @screen_ids = NULL;

SELECT GROUP_CONCAT(s.id) INTO @screen_ids
FROM screens s
LEFT JOIN seats st ON s.id = st.screen_id
GROUP BY s.id
HAVING COUNT(st.id) = 0;

-- Call procedure for each screen (you'll need to run this for each screen ID)
-- Example for first few screens:
CALL create_seats_for_screen(1);
CALL create_seats_for_screen(2);
CALL create_seats_for_screen(3);
CALL create_seats_for_screen(4);
CALL create_seats_for_screen(5);
CALL create_seats_for_screen(6);
CALL create_seats_for_screen(7);
CALL create_seats_for_screen(8);
CALL create_seats_for_screen(9);
CALL create_seats_for_screen(10);

-- Verify seats were created
SELECT s.id, s.screen_number, t.name as theatre_name, 
       COUNT(st.id) as seat_count
FROM screens s
JOIN theatres t ON s.theatre_id = t.id
LEFT JOIN seats st ON s.id = st.screen_id
GROUP BY s.id, s.screen_number, t.name
ORDER BY s.id;
