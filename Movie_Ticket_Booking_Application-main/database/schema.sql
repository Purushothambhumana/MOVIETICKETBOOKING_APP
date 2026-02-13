-- BookMyShow Database Schema
-- MySQL 5.7+

-- Create Database
CREATE DATABASE IF NOT EXISTS antipromovie;
USE antipromovie;

-- Drop tables if they exist (for fresh setup)
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS booking_seats;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS shows;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS screens;
DROP TABLE IF EXISTS theatres;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS users;

-- Users Table
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Roles Table
CREATE TABLE roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- User Roles Junction Table
CREATE TABLE user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Movies Table
CREATE TABLE movies (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    duration INT NOT NULL,
    language VARCHAR(50),
    genre VARCHAR(50),
    poster_url VARCHAR(500),
    release_date DATE,
    status VARCHAR(20) NOT NULL,
    certification VARCHAR(10) NOT NULL,
    INDEX idx_status (status),
    INDEX idx_release_date (release_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Theatres Table
CREATE TABLE theatres (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_city (city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Screens Table
CREATE TABLE screens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    theatre_id BIGINT NOT NULL,
    screen_number INT NOT NULL,
    total_seats INT NOT NULL,
    FOREIGN KEY (theatre_id) REFERENCES theatres(id) ON DELETE CASCADE,
    INDEX idx_theatre (theatre_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seats Table
CREATE TABLE seats (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    screen_id BIGINT NOT NULL,
    row_number VARCHAR(5) NOT NULL,
    seat_number INT NOT NULL,
    seat_type VARCHAR(20) NOT NULL,
    FOREIGN KEY (screen_id) REFERENCES screens(id) ON DELETE CASCADE,
    INDEX idx_screen (screen_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Shows Table
CREATE TABLE shows (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    movie_id BIGINT NOT NULL,
    screen_id BIGINT NOT NULL,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
    FOREIGN KEY (screen_id) REFERENCES screens(id) ON DELETE CASCADE,
    INDEX idx_movie (movie_id),
    INDEX idx_screen (screen_id),
    INDEX idx_show_date (show_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bookings Table
CREATE TABLE bookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    show_id BIGINT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_show (show_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Booking Seats Junction Table
CREATE TABLE booking_seats (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    seat_id BIGINT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(id) ON DELETE CASCADE,
    INDEX idx_booking (booking_id),
    INDEX idx_seat (seat_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Payments Table
CREATE TABLE payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    INDEX idx_booking (booking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Default Roles
INSERT INTO roles (name) VALUES ('ROLE_USER');
INSERT INTO roles (name) VALUES ('ROLE_ADMIN');

-- Insert Default Admin User (password: admin123)
INSERT INTO users (username, email, password, phone)
VALUES ('admin', 'admin@bookmyshow.com', '$2a$10$XptfskLsT1l/bRTLRiiCf.XrZk5Z2dGDnZ2KGMLi1xYzfqVQKy.0W', '1234567890');

-- Assign Admin Role
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id FROM users u, roles r WHERE u.username = 'admin' AND r.name = 'ROLE_ADMIN';

-- Insert Sample Movie
INSERT INTO movies (title, description, duration, language, genre, poster_url, release_date, status, certification)
VALUES (
    'Inception',
    'A thief who steals corporate secrets through the use of dream-sharing technology.',
    148,
    'English',
    'Sci-Fi, Thriller',
    'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
    '2010-07-16',
    'NOW_SHOWING',
    'UA'
);

INSERT INTO movies (title, description, duration, language, genre, poster_url, release_date, status, certification)
VALUES (
    'The Dark Knight',
    'When the menace known as the Joker wreaks havoc on Gotham, Batman must accept one of the greatest tests.',
    152,
    'English',
    'Action, Crime, Drama',
  'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    '2008-07-18',
    'NOW_SHOWING',
    'UA'
);

-- Insert Sample Theatre
INSERT INTO theatres (name, city, address)
VALUES ('PVR Phoenix', 'Mumbai', 'High Street Phoenix, Lower Parel');

INSERT INTO theatres (name, city, address)
VALUES ('INOX Nariman Point', 'Mumbai', 'Eros Cinema, Nariman Point');

-- Insert Sample Screen for Theatre 1
INSERT INTO screens (theatre_id, screen_number, total_seats)
VALUES (1, 1, 150);

INSERT INTO screens (theatre_id, screen_number, total_seats)
VALUES (1, 2, 200);

-- Insert Sample Seats for Screen 1 (10 rows, 15 seats per row = 150 seats)
-- This is automated in the backend, but showing sample for first few seats
INSERT INTO seats (screen_id, row_number, seat_number, seat_type)
VALUES 
(1, 'A', 1, 'PLATINUM'),
(1, 'A', 2, 'PLATINUM'),
(1, 'A', 3, 'PLATINUM'),
(1, 'A', 4, 'PLATINUM'),
(1, 'A', 5, 'PLATINUM');
-- Continue for all seats... (handled by backend API)

-- Insert Sample Shows
INSERT INTO shows (movie_id, screen_id, show_date, show_time, price)
VALUES 
(1, 1, CURDATE(), '10:00:00', 250.00),
(1, 1, CURDATE(), '13:30:00', 300.00),
(1, 1, CURDATE(), '18:00:00', 350.00),
(2, 1, CURDATE(), '21:30:00', 350.00);

-- Verify Setup
SELECT 'Database setup completed successfully!' AS Status;
SELECT COUNT(*) AS RoleCount FROM roles;
SELECT COUNT(*) AS UserCount FROM users;
SELECT COUNT(*) AS MovieCount FROM movies;
SELECT COUNT(*) AS TheatreCount FROM theatres;
