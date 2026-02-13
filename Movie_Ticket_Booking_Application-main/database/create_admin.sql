-- Create Admin User
USE antipromovie;

-- Insert admin user (password: admin123, BCrypt hashed)
INSERT INTO users (username, email, password, phone, created_at) 
VALUES ('admin', 'admin@bookmyshow.com', '$2a$10$XptfskLsT1l/bRTLRiiCf.XrZk5Z2dGDnZ2KGMLi1xYzfqVQKy.0W', '1234567890', NOW());

-- Get the admin user ID
SET @admin_user_id = LAST_INSERT_ID();

-- Assign both USER and ADMIN roles to admin
INSERT INTO user_roles (user_id, role_id) 
SELECT @admin_user_id, id FROM roles WHERE name = 'ROLE_USER';

INSERT INTO user_roles (user_id, role_id) 
SELECT @admin_user_id, id FROM roles WHERE name = 'ROLE_ADMIN';

SELECT '✅ Admin user created successfully!' AS Status;
SELECT 'Username: admin, Password: admin123' AS Credentials;
