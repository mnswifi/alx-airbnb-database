# SQL Queries Guide

This document demonstrates SQL techniques with examples using the following sample tables:

- `users`
- `bookings`
- `properties`
- `reviews`

Covered topics:

1. **Joins**
2. **Subqueries & Correlated Subqueries**
3. **Aggregations (COUNT, GROUP BY)**
4. **Window Functions (RANK, ROW_NUMBER)**

---

## 1️⃣ SQL Joins

### 🔹 INNER JOIN: `bookings` and `users`

Retrieve records that have matching values in both tables.

```sql
SELECT bookings.*, users.*
FROM bookings
INNER JOIN users ON bookings.user_id = users.id;
```

✅ Returns only users who have made bookings.

---

### 🔹 LEFT JOIN: properties and reviews

Retrieve all records from properties and the matched ones from reviews.

```sql
SELECT properties.*, reviews.*
FROM properties
LEFT JOIN reviews ON properties.id = reviews.property_id;
```

✅ Returns all properties, even those without reviews (NULL for missing reviews).

---

### 🔹 FULL OUTER JOIN: users and bookings

Retrieve all records from both tables, whether or not there is a match.

```sql
SELECT users.*, bookings.*
FROM users
FULL OUTER JOIN bookings ON users.id = bookings.user_id;
```

✅ Includes:

- Users without bookings
- Bookings without valid users

---

## 2️⃣ SQL Subqueries & Correlated Subqueries

### 🔹 Properties with Average Rating > 4.0

Using a subquery with HAVING.

```sql
SELECT *
FROM properties
WHERE id IN (
    SELECT property_id
    FROM reviews
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
);
```

✅ Finds only properties where the average rating is above 4.0.

---

### 🔹 Users with More Than 3 Bookings (Correlated Subquery)

For each user, count their bookings.

```sql
SELECT *
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.user_id = u.id
) > 3;
```

✅ Returns users who have made more than 3 bookings.

---

## 3️⃣ SQL Aggregations (COUNT + GROUP BY)

🔹 Total Number of Bookings by Each User

Using `COUNT` and `GROUP BY`.

```sql
SELECT users.id AS user_id, users.name AS user_name, COUNT(bookings.id) AS total_bookings
FROM users
LEFT JOIN bookings ON users.id = bookings.user_id
GROUP BY users.id, users.name;
```

✅ Shows booking counts for each user, including those with 0 bookings.

---

4️⃣ Window Functions

## 🔹 Rank Properties by Number of Bookings

Using `RANK()` and `ROW_NUMBER()`.

```sql
SELECT properties.id AS property_id, properties.name AS property_name, COUNT(bookings.id) AS total_bookings,
       RANK() OVER (ORDER BY COUNT(bookings.id) DESC) AS booking_rank
       ROW_NUMBER() OVER (ORDER BY COUNT(bookings.id) DESC) AS booking_rownum
FROM properties
LEFT JOIN bookings ON properties.id = bookings.property_id
GROUP BY properties.id, properties.name
ORDER BY booking_rank;
```

✅ Explanation:

- `RANK()` → ties share same rank (e.g., 1, 2, 2, 4).
- `ROW_NUMBER()` → unique sequence without ties.
- Useful for leaderboards or popularity rankings.

✅ Summary

- **Joins** → Combine data across tables.
- **Subqueries** → Nested queries to filter or compute values.
- **Correlated Subqueries** → Depend on outer query rows.
- **Aggregations** → Summarize data using `COUNT`, `AVG`, etc.
- **Window Functions** → Rank or order results while keeping all rows.

---
