# Building Index for Performance

---

✅ Step 1: Identify High-Usage Columns

From the queries we’ve written so far, the frequently used columns are:

- `users.id` → used in JOIN with `bookings.user_id`.
- `bookings.user_id` → used in joins and subqueries.
- `bookings.property_id` → used in joins with `properties.id`.
- `properties.id` → used in joins and subqueries.
- `reviews.property_id` → used in joins and aggregations.
- `reviews.rating` → used in `HAVING AVG(rating)` filters.

---

✅ Step 2: Measure Query Performance (Before vs After Indexes) - Using **Explain** or **Analyze**

```sql
-- Before creating indexes
EXPLAIN SELECT u.id, u.name, COUNT(b.id)
FROM users u
JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name;

-- After creating indexes
EXPLAIN SELECT u.id, u.name, COUNT(b.id)
FROM users u
JOIN bookings b ON u.id = b.user_id
GROUP BY u.id, u.name;
```

Expected improvement:

- Before indexes → the query plan may show Seq Scan (full table scans).
- After indexes → the plan should switch to Index Scan, reducing query cost significantly.

---
