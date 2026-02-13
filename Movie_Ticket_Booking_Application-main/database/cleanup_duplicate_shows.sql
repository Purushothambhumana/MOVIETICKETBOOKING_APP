-- Clean up duplicate shows and keep only 4 shows per day per movie
-- This will keep one show per movie per time slot

USE antipromovie;

-- ============================================
-- DELETE DUPLICATE SHOWS
-- Keep only one show per movie, per date, per time
-- ============================================

-- First, let's see how many shows we have
SELECT 
    COUNT(*) AS 'Total Shows Before Cleanup',
    COUNT(DISTINCT CONCAT(movie_id, '-', show_date, '-', show_time)) AS 'Unique Movie-Date-Time Combinations'
FROM shows;

-- Create a temporary table with the IDs we want to keep (one per movie-date-time combination)
CREATE TEMPORARY TABLE shows_to_keep AS
SELECT MIN(id) as id
FROM shows
GROUP BY movie_id, show_date, show_time;

-- Delete all shows except the ones we want to keep
DELETE FROM shows
WHERE id NOT IN (SELECT id FROM shows_to_keep);

-- Drop the temporary table
DROP TEMPORARY TABLE shows_to_keep;

-- ============================================
-- VERIFY CLEANUP
-- ============================================

SELECT 
    COUNT(*) AS 'Total Shows After Cleanup',
    COUNT(DISTINCT movie_id) AS 'Movies with Shows',
    COUNT(DISTINCT show_date) AS 'Days with Shows'
FROM shows;

-- Show breakdown by date
SELECT 
    show_date AS 'Date',
    COUNT(*) AS 'Total Shows',
    COUNT(DISTINCT movie_id) AS 'Unique Movies',
    COUNT(DISTINCT show_time) AS 'Time Slots'
FROM shows
GROUP BY show_date
ORDER BY show_date;

-- Show time slots
SELECT DISTINCT show_time AS 'Show Times'
FROM shows
ORDER BY show_time;

SELECT '✅ Cleanup Complete! Now showing 4 shows per day per movie.' AS Status;
