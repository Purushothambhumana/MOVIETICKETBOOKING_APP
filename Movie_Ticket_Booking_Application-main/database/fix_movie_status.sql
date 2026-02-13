-- Check and fix movie status issue
USE antipromovie;

-- Step 1: Check current movie status
SELECT 
    id,
    title,
    status,
    genre,
    language
FROM movies
ORDER BY id;

-- Step 2: Update all movies to NOW_SHOWING status
UPDATE movies 
SET status = 'NOW_SHOWING'
WHERE status IS NULL OR status != 'NOW_SHOWING';

-- Step 3: Verify the update
SELECT 
    status,
    COUNT(*) as movie_count
FROM movies
GROUP BY status;

-- Step 4: Show all movies that should now be visible
SELECT 
    id,
    title,
    status,
    genre,
    language,
    certification
FROM movies
WHERE status = 'NOW_SHOWING'
ORDER BY title;
