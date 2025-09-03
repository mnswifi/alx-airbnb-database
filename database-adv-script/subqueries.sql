-- ================================================
-- Properties where avg rating > 4.0 using subquery
-- ================================================

SELECT *
FROM properties
WHERE id IN (
    SELECT property_id
    FROM reviews
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
);


-- ========================================================================
-- Users who have made more than 3 bookings using using correlated subquery
-- ========================================================================

SELECT *
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.user_id = u.id
) > 3;
