-- Add seat type pricing columns to shows table
ALTER TABLE shows 
ADD COLUMN platinum_price DECIMAL(10,2),
ADD COLUMN gold_price DECIMAL(10,2),
ADD COLUMN silver_price DECIMAL(10,2);

-- Update existing shows to use seat type prices
-- Set default prices based on existing price field
UPDATE shows 
SET 
    platinum_price = price * 1.5,  -- Platinum is 1.5x base price
    gold_price = price,             -- Gold is base price
    silver_price = price * 0.75     -- Silver is 0.75x base price
WHERE platinum_price IS NULL;

SELECT 'Migration complete! Added seat type pricing columns.' AS status;
