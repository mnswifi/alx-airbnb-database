# SQL Join Examples

This document demonstrates different types of SQL joins using sample tables:  

- **users**  
- **bookings**  
- **properties**  
- **reviews**

---

## 🔹 INNER JOIN: `bookings` and `users`

Retrieve records that have matching values in both tables.

```sql
SELECT bookings.*, users.*
FROM bookings
INNER JOIN users ON bookings.user_id = users.id;
```

- Returns only users who have made bookings.
- Excludes users without bookings

## 🔹 LEFT JOIN: `properties` and `reviews`

Retrieve all records from the left table (`properties`), and the matched records from the right table (`reviews`).

```sql
SELECT properties.*, reviews.*
FROM properties
LEFT JOIN reviews ON properties.id = reviews.property_id;
```

- Returns all properties, even if they have no reviews.
- If a property has no reviews, review columns will contain NULL.

## 🔹 FULL OUTER JOIN: users and bookings

Retrieve all records when there is a match in either left or right table.

```sql
SELECT users.*, bookings.*
FROM users
FULL OUTER JOIN bookings ON users.id = bookings.user_id;
```

- Returns all users and all bookings.
- Users without bookings and bookings without valid users are included.
- Non-matching columns will be `NULL`.

---

## SQL Subquery Examples (subqueries and correlated subqueries)

This document demonstrates the use of **subqueries** and **correlated subqueries** in SQL with sample tables:

- `users`
- `bookings`
- `properties`
- `reviews`

---

## 🔹 Query 1: Properties with Average Rating > 4.0

Find all properties where the **average review rating** is greater than 4.0.

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

✅ Explanation:

- The subquery groups `reviews` by `property_id`.

- It filters groups where the AVG(rating) > 4.0.

- The outer query fetches property details matching those IDs.

## 🔹 Query 2: Users with More Than 3 Bookings

Use a correlated subquery to find users who have made more than 3 bookings.

```sql
SELECT *
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.user_id = u.id
) > 3;
```

✅ Explanation:

- The subquery counts how many bookings each user (`u.id`) has.

- It runs once per user (correlated subquery).

- The outer query returns users with more than 3 bookings.
