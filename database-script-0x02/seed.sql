-- Airbnb Database Seed Data

-- ==========================
-- USERS TABLE
-- ==========================

-- Seed Data for Users
INSERT INTO users (name, email, password)
VALUES
    ('Alice Johnson', 'alice@example.com', 'hashed_pass1'),
    ('Bob Smith', 'bob@example.com', 'hashed_pass2'),
    ('Charlie Kim', 'charlie@example.com', 'hashed_pass3');

-- ==========================
-- LISTINGS TABLE
-- ==========================

-- Seed Data for Listings
INSERT INTO listings (host_id, title, description, location, price)
VALUES
    (1, 'Cozy Apartment in Lagos', '2-bedroom apartment with ocean view', 'Lagos, Nigeria', 75.00),
    (2, 'Modern Loft in Abuja', 'Stylish loft with workspace', 'Abuja, Nigeria', 120.00),
    (1, 'Beach House in Accra', 'Spacious beach house for families', 'Accra, Ghana', 200.00);

-- ==========================
-- BOOKINGS TABLE
-- ==========================

-- Seed Data for Bookings
INSERT INTO bookings (listing_id, guest_id, start_date, end_date, total_price)
VALUES
    (1, 2, '2025-09-01', '2025-09-05', 300.00),
    (2, 3, '2025-09-10', '2025-09-12', 240.00);

-- ==========================
-- REVIEWS TABLE
-- ==========================

-- Seed Data for Reviews
INSERT INTO reviews (booking_id, rating, comment)
VALUES
    (1, 5, 'Amazing stay! Very comfortable and clean.'),
    (2, 4, 'Great location, but a bit noisy at night.');
