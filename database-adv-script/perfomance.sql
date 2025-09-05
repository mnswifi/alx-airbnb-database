-- ====================================================================
-- Initial Query: Get bookings with user, property, and payment details
-- ====================================================================

SELECT b.id AS booking_id,
       b.booking_date,
       u.id AS user_id,
       u.name AS user_name,
       u.email AS user_email,
       p.id AS property_id,
       p.name AS property_name,
       pay.id AS payment_id,
       pay.amount,
       pay.status
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.id = pay.booking_id
WHERE b.id IS NOT NULL
  AND u.id IS NOT NULL;



-- =========================
-- Analyze Query Performance 
-- =========================

EXPLAIN ANALYZE
SELECT b.id AS booking_id,
       b.booking_date,
       u.id AS user_id,
       u.name AS user_name,
       u.email AS user_email,
       p.id AS property_id,
       p.name AS property_name,
       pay.id AS payment_id,
       pay.amount,
       pay.status
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.id = pay.booking_id;
WHERE b.id IS NOT NULL
  AND u.id IS NOT NULL;

-- ==========================================
-- Indexes to Improve Query Performance
-- ==========================================

-- Indexes for common JOIN conditions
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);

-- Supporting indexes for lookups
CREATE INDEX idx_users_id ON users(id);
CREATE INDEX idx_properties_id ON properties(id);


-- =========================
-- Re-analyze Query Performance After Index Creation
-- =========================
EXPLAIN ANALYZE
SELECT b.id AS booking_id,
       b.booking_date,
       u.id AS user_id,
       u.name AS user_name,
       u.email AS user_email,
       p.id AS property_id,
       p.name AS property_name,
       pay.id AS payment_id,
       pay.amount,
       pay.status
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.id = pay.booking_id;
WHERE b.id IS NOT NULL
  AND u.id IS NOT NULL;
