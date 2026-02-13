-- Insert Default Roles for BookMyShow Application
-- Run this script to fix the "User Role not found" error

USE antipromovie;

-- Insert roles if they don't already exist
INSERT IGNORE INTO roles (id, name) VALUES (1, 'ROLE_USER');
INSERT IGNORE INTO roles (id, name) VALUES (2, 'ROLE_ADMIN');

-- Insert default admin user (password: admin123) if doesn't exist
INSERT IGNORE INTO users (id, username, email, password, phone, created_at)
VALUES (1, 'admin', 'admin@bookmyshow.com', '$2a$10$XptfskLsT1l/bRTLRiiCf.XrZk5Z2dGDnZ2KGMLi1xYzfqVQKy.0W', '1234567890', NOW());

-- Assign admin role to admin user
INSERT IGNORE INTO user_roles (user_id, role_id) VALUES (1, 1);
INSERT IGNORE INTO user_roles (user_id, role_id) VALUES (1, 2);

-- Verify
SELECT 'Roles inserted successfully!' AS Status;
SELECT * FROM roles;
