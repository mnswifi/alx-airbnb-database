
# Normalization Review to 3NF

This document reviews the provided schema for redundancies or normalization issues and proposes adjustments to achieve **Third Normal Form (3NF)**. It also explains each step taken.

---

## 1) Quick Summary (Before vs After)

**Before (key points):**

- `Property.location` stored as a single `VARCHAR`.
- `Booking.total_price` stored alongside attributes it is derived from (dates + price).
- `ENUM`s used for `User.role`, `Booking.status`, `Payment.payment_method`.
- `Review` connected to `property_id` and `user_id`, which allows reviews without guaranteed stays.
- `Payment` modeled as one-to-one with `Booking`, disallowing installments/refunds.

**After (proposed 3NF-aligned changes):**

- **Lookup tables** replace `ENUM`s: `roles`, `booking_statuses`, `payment_methods`.
- **Location** is factored into a separate table `locations` to remove hidden composite data in a single field.
- **Review** is linked to `booking_id` (and still infers `user_id` and `property_id`) to guarantee a stay occurred; enforces **one review per booking**.
- **Payment** becomes **one-to-many** from `Booking` to allow partial payments/refunds.
- Keep `Booking.total_price` as a **snapshot** (historical price) with a note on why this is acceptable in 3NF (explained below).

---

## 2) Normalization Walkthrough

### 2.1 First Normal Form (1NF)

- Ensure atomic values, no repeating groups.
- **Change:** `Property.location (VARCHAR)` can hide multiple atomic values (city/state/country). We normalize it into a `locations` table and reference it with `location_id`.

### 2.2 Second Normal Form (2NF)

- All non-key attributes depend on the whole primary key (for composite keys).
- Current tables use surrogate keys (UUIDs), so 2NF violations are unlikely. No attributes depend on only part of a composite key.

### 2.3 Third Normal Form (3NF)

- No transitive dependencies: non-key attributes should not depend on other non-key attributes.
- **Change:** Replace `ENUM`s with lookup tables (`roles`, `booking_statuses`, `payment_methods`) so that any attributes about those concepts (e.g., descriptions, display order) live in their own tables.
- **Change:** `Review` now references `booking_id`, removing the transitive inference chain and ensuring data integrity (a user can only review properties they actually booked). We also enforce a unique review per booking.
- **Discussion (Derived Data):** `Booking.total_price` is derivable from `nights * price_per_night_at_time_of_booking`. In practice, you **should snapshot** the agreed price at booking time (because property prices change). Storing `total_price` does **not violate 3NF** as long as it is functionally dependent on the key (`booking_id`) and you treat it as a historical fact, not recomputed from other mutable tables.

---

## 3) Why These Changes Improve Normalization

- **Lookup tables → 3NF**: They remove embedded categories (`ENUM`s) and allow attributes of those categories to live independently, avoiding update anomalies.
- **Locations → 1NF/3NF**: Decomposes a compound field into atomic, queryable parts and prevents storing the same city/country strings redundantly across many properties.
- **Reviews → 3NF + integrity**: By referencing `booking_id`, you eliminate potential mismatches between `(user_id, property_id)` pairs and actual stays; you can still derive both via joins.
- **Payments → flexibility**: One-to-many payments enable installments, refunds, and partial captures without schema changes.
- **Snapshot pricing**: Keeping `total_price` on `bookings` preserves historical truth and remains functionally dependent on the key. This avoids retroactive price changes if `properties.price_per_night` is updated later.