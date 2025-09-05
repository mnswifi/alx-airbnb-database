# Performance Optimization

---

✅ Step 1: Initial Query (perfomance.sql)

We need to fetch:

- Bookings
- User details
- Property details
- Payment details

## Here’s the initial query (save in `perfomance.sql`):

```sql
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
```

---

✅ Step 2: Analyze Query Performance

Run:

```sql
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
```

Nested Loop Joins → can be expensive on large datasets.

High cost estimates compared to actual execution time.

---

✅ Step 3: Refactor for Performance

### 🔹 1. Add Indexes (on JOIN keys)

Save in `database_index.sql`:

```sql
-- Indexes for common JOIN conditions
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);

-- Supporting indexes for lookups
CREATE INDEX idx_users_id ON users(id);
CREATE INDEX idx_properties_id ON properties(id);
```

---

### 🔹 2. Reduce Unnecessary Joins

If only certain fields are required (e.g., not fetching all user details), select fewer columns:

```sql
-- Refactored Query with reduced columns
SELECT b.id AS booking_id,
       b.booking_date,
       u.name AS user_name,
       p.name AS property_name,
       pay.amount,
       pay.status
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.id = pay.booking_id;
```

---

### 🔹 3. Filter Early (if applicable)

If analyzing only completed payments:

```sql
-- Refactored Query with filtering for completed payments
SELECT b.id AS booking_id,
       b.booking_date,
       u.name AS user_name,
       p.name AS property_name,
       pay.amount
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.id = pay.booking_id
WHERE pay.status = 'Completed';
```

---

✅ Step 4: Compare Performance

Run EXPLAIN ANALYZE again after indexing/refactoring:

```sql
EXPLAIN ANALYZE
SELECT b.id, b.booking_date, u.name, p.name, pay.amount, pay.status
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN properties p ON b.property_id = p.id
JOIN payments pay ON b.id = pay.booking_id;
```

Expected improvements:

- Index Scan replaces Seq Scan.
- Reduced execution cost.
- Lower execution time (ms).

⚡ In short:

- Initial query joins all 4 tables.
- Analyze reveals inefficiencies (full scans, nested loops).
- Refactor + Indexes → less I/O, faster joins.
