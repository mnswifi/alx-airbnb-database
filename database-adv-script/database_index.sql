-- Before creating indexes
EXPLAIN ANALYZE SELECT u.id, u.name, COUNT(b.id)
FROM users u
JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name;

-- ==========================================
-- Indexes for Users and Bookings
-- ==========================================
CREATE INDEX idx_users_id ON users(id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);

-- ==========================================
-- Indexes for Properties and Bookings
-- ==========================================
CREATE INDEX idx_properties_id ON properties(id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- ==========================================
-- Indexes for Properties and Reviews
-- ==========================================
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

-- ==========================================
-- Index for filtering by Rating (used in HAVING clauses)
-- ==========================================
CREATE INDEX idx_reviews_rating ON reviews(rating);

-- After creating indexes

EXPLAIN ANALYZE SELECT u.id, u.name, COUNT(b.id)
FROM users u
JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name;