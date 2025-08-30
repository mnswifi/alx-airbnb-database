# Airbnb Database Schema (3NF)

## Objective

Design and implement an Airbnb-like database schema using **MySQL**.  
The schema follows **Third Normal Form (3NF)** to reduce redundancy, enforce integrity, and ensure scalability.

---

## Entities and Relationships

1. **Users**
   - Stores guest and host profiles.
   - Each user has a unique `user_id`.
   - Attributes include name, email, phone.

2. **Hosts**
   - A subset of users who list properties.
   - Connected to `users(user_id)` via foreign key.

3. **Properties**
   - Each property belongs to a host.
   - Attributes include title, description, price, property_type.
   - Connected to `hosts(host_id)` via foreign key.

4. **Locations**
   - Normalized table for cities and countries.
   - Linked to `properties` to avoid repeating text.

5. **Bookings**
   - Connects users (guests) with properties.
   - Tracks booking dates and status.
   - Each booking references a user and property.

6. **Payments**
   - Each booking may have one or more payments.
   - Includes amount, method, and status.
   - Linked to `bookings`.

7. **Reviews**
   - Guests leave reviews tied to their booking.
   - Ensures only users who booked can review.

---

## Normalization Steps (up to 3NF)

1. **1NF (Eliminate repeating groups)**  
   - Broke down location into a separate table (`locations`).
   - Ensured scalar attributes only.

2. **2NF (Remove partial dependencies)**  
   - Moved host details into `hosts` table (depends fully on `user_id`).
   - Ensured no attribute depends on part of a composite key.

3. **3NF (Remove transitive dependencies)**  
   - Ensured non-key attributes depend only on the primary key.
   - Payments depend only on `booking_id`.
   - Reviews depend only on `booking_id`.

---

## Constraints and Indexes

- **Primary Keys** on all ID columns.
- **Foreign Keys** enforce referential integrity:
  - `hosts.user_id → users.user_id`
  - `properties.host_id → hosts.host_id`
  - `properties.location_id → locations.location_id`
  - `bookings.user_id → users.user_id`
  - `bookings.property_id → properties.property_id`
  - `payments.booking_id → bookings.booking_id`
  - `reviews.booking_id → bookings.booking_id`
- **Unique Indexes** on `users.email` and `users.phone`.
- **Indexes** on frequently queried columns:
  - `bookings.user_id`
  - `bookings.property_id`
  - `payments.booking_id`

---

## Example Query

```sql
-- Find all bookings by a specific guest with property details
SELECT b.booking_id, p.title, p.price, b.start_date, b.end_date, b.status
FROM bookings b
JOIN properties p ON b.property_id = p.property_id
WHERE b.user_id = 101;
```

---

## Usage

1. Run the provided **schema.sql** in your MySQL server to create the database:

    ```bash
    mysql -u root -p < schema.sql
    ```

2. The database ***airbnb_db** will be created with all tables and constraints.
