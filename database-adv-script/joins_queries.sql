-- ==========================================
-- INNER JOIN bookings and users Tables
-- ==========================================
SELECT bookings.*, users.*
FROM bookings
INNER JOIN users ON bookings.user_id = users.id;

-- ==========================================
-- LEFT JOIN properties and reviews Tables
-- ==========================================
SELECT properties.*, reviews.*
FROM properties
LEFT JOIN reviews ON properties.id = reviews.property_id
ORDER BY properties.id ASC;

-- ==========================================
-- FULL OUTER JOIN users and bookings Tables
-- ==========================================
SELECT users.*, bookings.*
FROM users
FULL OUTER JOIN bookings ON users.id = bookings.user_id;