-- Add Shows for All Junior NTR Movies
-- This will create shows across all existing theatres and screens

USE antipromovie;

-- ============================================
-- CREATE SHOWS FOR JUNIOR NTR MOVIES
-- ============================================

-- Get all Junior NTR movie IDs and create shows for next 7 days
-- Across all theatres and screens with multiple time slots

-- Today's Shows
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '10:30:00', 200.00
FROM movies m
CROSS JOIN screens s
WHERE m.language = 'Telugu' 
AND m.title IN (
    'RRR', 'Aravinda Sametha Veera Raghava', 'Jai Lava Kusa', 'Nannaku Prematho', 
    'Temper', 'Rabhasa', 'Ramayya Vasavadha', 'Baadshah', 'Dammu', 'Oosaravelli',
    'Shakti', 'Brindavanam', 'Adhurs', 'Kantri', 'Yamadonga', 'Rakhi', 'Ashok',
    'Narasimhudu', 'Samba', 'Simhadri', 'Aadi', 'Student No. 1', 'Ninnu Choodalani',
    'Naa Alludu', 'Andhrawala', 'Naa Autograph'
)
AND s.screen_number IN (1, 2);

INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '14:00:00', 220.00
FROM movies m
CROSS JOIN screens s
WHERE m.language = 'Telugu' 
AND m.title IN (
    'RRR', 'Aravinda Sametha Veera Raghava', 'Jai Lava Kusa', 'Nannaku Prematho', 
    'Temper', 'Rabhasa', 'Ramayya Vasavadha', 'Baadshah', 'Dammu', 'Oosaravelli',
    'Shakti', 'Brindavanam', 'Adhurs', 'Kantri', 'Yamadonga', 'Rakhi', 'Ashok',
    'Narasimhudu', 'Samba', 'Simhadri', 'Aadi', 'Student No. 1', 'Ninnu Choodalani',
    'Naa Alludu', 'Andhrawala', 'Naa Autograph'
)
AND s.screen_number IN (2, 3);

INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '18:00:00', 250.00
FROM movies m
CROSS JOIN screens s
WHERE m.language = 'Telugu' 
AND m.title IN (
    'RRR', 'Aravinda Sametha Veera Raghava', 'Jai Lava Kusa', 'Nannaku Prematho', 
    'Temper', 'Rabhasa', 'Ramayya Vasavadha', 'Baadshah', 'Dammu', 'Oosaravelli',
    'Shakti', 'Brindavanam', 'Adhurs', 'Kantri', 'Yamadonga', 'Rakhi', 'Ashok',
    'Narasimhudu', 'Samba', 'Simhadri', 'Aadi', 'Student No. 1', 'Ninnu Choodalani',
    'Naa Alludu', 'Andhrawala', 'Naa Autograph'
)
AND s.screen_number IN (1, 3);

INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, CURDATE(), '21:30:00', 280.00
FROM movies m
CROSS JOIN screens s
WHERE m.language = 'Telugu' 
AND m.title IN (
    'RRR', 'Aravinda Sametha Veera Raghava', 'Jai Lava Kusa', 'Nannaku Prematho', 
    'Temper', 'Rabhasa', 'Ramayya Vasavadha', 'Baadshah', 'Dammu', 'Oosaravelli',
    'Shakti', 'Brindavanam', 'Adhurs', 'Kantri', 'Yamadonga', 'Rakhi', 'Ashok',
    'Narasimhudu', 'Samba', 'Simhadri', 'Aadi', 'Student No. 1', 'Ninnu Choodalani',
    'Naa Alludu', 'Andhrawala', 'Naa Autograph'
)
AND s.screen_number = 2;

-- Next 6 Days Shows
INSERT IGNORE INTO shows (movie_id, screen_id, show_date, show_time, price)
SELECT m.id, s.id, DATE_ADD(CURDATE(), INTERVAL d.day DAY), t.show_time, t.price
FROM movies m
CROSS JOIN screens s
CROSS JOIN (
    SELECT 1 as day UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
) d
CROSS JOIN (
    SELECT '10:30:00' as show_time, 200.00 as price UNION
    SELECT '14:00:00', 220.00 UNION
    SELECT '18:00:00', 250.00 UNION
    SELECT '21:30:00', 280.00
) t
WHERE m.language = 'Telugu' 
AND m.title IN (
    'RRR', 'Aravinda Sametha Veera Raghava', 'Jai Lava Kusa', 'Nannaku Prematho', 
    'Temper', 'Rabhasa', 'Ramayya Vasavadha', 'Baadshah', 'Dammu', 'Oosaravelli',
    'Shakti', 'Brindavanam', 'Adhurs', 'Kantri', 'Yamadonga', 'Rakhi', 'Ashok',
    'Narasimhudu', 'Samba', 'Simhadri', 'Aadi', 'Student No. 1', 'Ninnu Choodalani',
    'Naa Alludu', 'Andhrawala', 'Naa Autograph'
);

-- ============================================
-- SUMMARY
-- ============================================
SELECT '✅ Shows Created for Junior NTR Movies!' AS Status;

SELECT 
    COUNT(DISTINCT s.id) AS 'Total Shows Created',
    COUNT(DISTINCT m.id) AS 'Movies with Shows',
    COUNT(DISTINCT sc.theatre_id) AS 'Theatres',
    MIN(s.show_date) AS 'First Show Date',
    MAX(s.show_date) AS 'Last Show Date'
FROM shows s
JOIN movies m ON s.movie_id = m.id
JOIN screens sc ON s.screen_id = sc.id
WHERE m.language = 'Telugu'
AND m.title IN (
    'RRR', 'Aravinda Sametha Veera Raghava', 'Jai Lava Kusa', 'Nannaku Prematho', 
    'Temper', 'Rabhasa', 'Ramayya Vasavadha', 'Baadshah', 'Dammu', 'Oosaravelli',
    'Shakti', 'Brindavanam', 'Adhurs', 'Kantri', 'Yamadonga', 'Rakhi', 'Ashok',
    'Narasimhudu', 'Samba', 'Simhadri', 'Aadi', 'Student No. 1', 'Ninnu Choodalani',
    'Naa Alludu', 'Andhrawala', 'Naa Autograph'
);

-- Show breakdown by city
SELECT 
    t.city AS City,
    COUNT(DISTINCT s.id) AS 'Shows',
    COUNT(DISTINCT m.id) AS 'Movies'
FROM shows s
JOIN movies m ON s.movie_id = m.id
JOIN screens sc ON s.screen_id = sc.id
JOIN theatres t ON sc.theatre_id = t.id
WHERE m.language = 'Telugu'
AND m.title IN (
    'RRR', 'Aravinda Sametha Veera Raghava', 'Jai Lava Kusa', 'Nannaku Prematho', 
    'Temper', 'Rabhasa', 'Ramayya Vasavadha', 'Baadshah', 'Dammu', 'Oosaravelli',
    'Shakti', 'Brindavanam', 'Adhurs', 'Kantri', 'Yamadonga', 'Rakhi', 'Ashok',
    'Narasimhudu', 'Samba', 'Simhadri', 'Aadi', 'Student No. 1', 'Ninnu Choodalani',
    'Naa Alludu', 'Andhrawala', 'Naa Autograph'
)
GROUP BY t.city
ORDER BY t.city;
