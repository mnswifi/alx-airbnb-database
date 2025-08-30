-- Airbnb 3NF Schema (MySQL with Lookup Tables & UUIDs)
-- Requires MySQL 8.0+ for UUID functions and CHECK constraints


-- Create Database
CREATE DATABASE IF NOT EXISTS airbnb_clone;
USE airbnb_clone;

-- Drop tables if exist (order matters because of FKs)
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS payment_methods;
DROP TABLE IF EXISTS booking_statuses;
DROP TABLE IF EXISTS roles;

-- ==========================================
-- Lookup Tables
-- ==========================================
CREATE TABLE roles (
  role_id CHAR(36) PRIMARY KEY,
  role_name VARCHAR(50) UNIQUE NOT NULL -- guest, host, admin
);

CREATE TABLE booking_statuses (
  status_id CHAR(36) PRIMARY KEY,
  status_name VARCHAR(50) UNIQUE NOT NULL -- pending, confirmed, canceled
);

CREATE TABLE payment_methods (
  method_id CHAR(36) PRIMARY KEY,
  method_name VARCHAR(50) UNIQUE NOT NULL -- credit_card, paypal, stripe
);

-- ==========================================
-- Locations
-- ==========================================
CREATE TABLE locations (
  location_id CHAR(36) PRIMARY KEY,
  street VARCHAR(200) NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NULL,
  country VARCHAR(100) NOT NULL,
  postal_code VARCHAR(20) NULL
);

-- ==========================================
-- Users
-- ==========================================
CREATE TABLE users (
  user_id CHAR(36) PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(30) NULL,
  role_id CHAR(36) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- ==========================================
-- Properties
-- ==========================================
CREATE TABLE properties (
  property_id CHAR(36) PRIMARY KEY,
  host_id CHAR(36) NOT NULL,
  name VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  location_id CHAR(36) NOT NULL,
  price_per_night DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (host_id) REFERENCES users(user_id),
  FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- ==========================================
-- Bookings
-- ==========================================
CREATE TABLE bookings (
  booking_id CHAR(36) PRIMARY KEY,
  property_id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10,2) NOT NULL, -- snapshot at booking time
  status_id CHAR(36) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_date_range CHECK (start_date < end_date),
  FOREIGN KEY (property_id) REFERENCES properties(property_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (status_id) REFERENCES booking_statuses(status_id)
);

-- ==========================================
-- Payments (one-to-many per booking)
-- ==========================================
CREATE TABLE payments (
  payment_id CHAR(36) PRIMARY KEY,
  booking_id CHAR(36) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  method_id CHAR(36) NOT NULL,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
  FOREIGN KEY (method_id) REFERENCES payment_methods(method_id)
);

-- ==========================================
-- Reviews (tie to booking to guarantee stay)
-- ==========================================
CREATE TABLE reviews (
  review_id CHAR(36) PRIMARY KEY,
  booking_id CHAR(36) NOT NULL UNIQUE, -- one review per booking
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- ==========================================
-- Messages
-- ==========================================
CREATE TABLE messages (
  message_id CHAR(36) PRIMARY KEY,
  sender_id CHAR(36) NOT NULL,
  recipient_id CHAR(36) NOT NULL,
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES users(user_id),
  FOREIGN KEY (recipient_id) REFERENCES users(user_id)
);

-- ==========================================
-- Helpful Indexes
-- ==========================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_properties_host ON properties(host_id);
CREATE INDEX idx_properties_location ON properties(location_id);
CREATE INDEX idx_bookings_property_dates ON bookings(property_id, start_date, end_date);
CREATE INDEX idx_payments_booking ON payments(booking_id);
