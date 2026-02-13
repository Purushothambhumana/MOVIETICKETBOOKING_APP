-- Update existing seat types from old names to new names
UPDATE seats SET seat_type = 'PLATINUM' WHERE seat_type = 'PREMIUM';
UPDATE seats SET seat_type = 'GOLD' WHERE seat_type = 'REGULAR';
UPDATE seats SET seat_type = 'SILVER' WHERE seat_type = 'ECONOMY';

-- Verify the changes
SELECT seat_type, COUNT(*) as count FROM seats GROUP BY seat_type;
