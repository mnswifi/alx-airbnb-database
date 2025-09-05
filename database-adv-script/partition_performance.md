# Partitioning Report

## Objective

Optimize queries on the large `bookings` table using table partitioning based on `start_date`.

## Approach

- Implemented **RANGE partitioning** on the `bookings` table.
- Created yearly partitions: `bookings_2023`, `bookings_2024`, and `bookings_future`.
- Added indexes on `start_date` within each partition.

## Testing

Executed the following query:

```sql
EXPLAIN ANALYZE
SELECT *
FROM bookings_partitioned
WHERE start_date BETWEEN '2024-01-01' AND '2024-06-30';
```

## Results

- Before partitioning: Query performed a sequential scan across the entire bookings table (~millions of rows).

- After partitioning: Query scanned only bookings_2024 partition (~subset of rows).

- Observed reduced execution cost and lower runtime.

## Conclusion

Partitioning by `start_date` significantly improves performance of time-based queries on the bookings dataset.
