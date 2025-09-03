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
