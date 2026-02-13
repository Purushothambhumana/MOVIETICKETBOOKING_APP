-- ============================================
-- Database Performance Indexes
-- For Movie Ticket Booking Application
-- Optimized for 1 Million Concurrent Users
-- ============================================

-- Movies table indexes
CREATE INDEX IF NOT EXISTS idx_movies_status ON movies(status);
CREATE INDEX IF NOT EXISTS idx_movies_release_date ON movies(release_date);
CREATE INDEX IF NOT EXISTS idx_movies_status_release ON movies(status, release_date);

-- Shows table indexes
CREATE INDEX IF NOT EXISTS idx_shows_movie_id ON shows(movie_id);
CREATE INDEX IF NOT EXISTS idx_shows_screen_id ON shows(screen_id);
CREATE INDEX IF NOT EXISTS idx_shows_date ON shows(show_date);
CREATE INDEX IF NOT EXISTS idx_shows_movie_date ON shows(movie_id, show_date);
CREATE INDEX IF NOT EXISTS idx_shows_date_time ON shows(show_date, show_time);

-- Theatres table indexes
CREATE INDEX IF NOT EXISTS idx_theatres_city ON theatres(city);
CREATE INDEX IF NOT EXISTS idx_theatres_name_city ON theatres(name, city);

-- Screens table indexes
CREATE INDEX IF NOT EXISTS idx_screens_theatre_id ON screens(theatre_id);
CREATE INDEX IF NOT EXISTS idx_screens_theatre_screen ON screens(theatre_id, screen_number);

-- Seats table indexes
CREATE INDEX IF NOT EXISTS idx_seats_screen_id ON seats(screen_id);
CREATE INDEX IF NOT EXISTS idx_seats_screen_row_seat ON seats(screen_id, row_number, seat_number);

-- Bookings table indexes
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_show_id ON bookings(show_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_user_date ON bookings(user_id, booking_date);
CREATE INDEX IF NOT EXISTS idx_bookings_show_status ON bookings(show_id, status);

-- Booking Seats table indexes
CREATE INDEX IF NOT EXISTS idx_booking_seats_booking_id ON booking_seats(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_seats_seat_id ON booking_seats(seat_id);
CREATE INDEX IF NOT EXISTS idx_booking_seats_booking_seat ON booking_seats(booking_id, seat_id);

-- Users table indexes
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Payments table indexes
CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(payment_status);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_shows_complex_query ON shows(movie_id, show_date, show_time);

-- Display index creation results
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX
FROM 
    INFORMATION_SCHEMA.STATISTICS
WHERE 
    TABLE_SCHEMA = 'antipromovie'
    AND TABLE_NAME IN ('movies', 'shows', 'theatres', 'screens', 'seats', 'bookings', 'booking_seats', 'users', 'payments')
ORDER BY 
    TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;
