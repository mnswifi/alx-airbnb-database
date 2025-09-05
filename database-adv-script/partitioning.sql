-- ==========================================
-- Partitioning Bookings table by start_date
-- ==========================================

-- Step 1: Create parent partitioned table
CREATE TABLE bookings_partitioned (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(50),
    amount DECIMAL(10,2)
) PARTITION BY RANGE (start_date);

-- Step 2: Create partitions (example: yearly partitions)
CREATE TABLE bookings_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_future PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO (MAXVALUE);

-- Step 3: (Optional) Indexes on partitions
CREATE INDEX idx_bookings_2023_start_date ON bookings_2023(start_date);
CREATE INDEX idx_bookings_2024_start_date ON bookings_2024(start_date);
CREATE INDEX idx_bookings_future_start_date ON bookings_future(start_date);


-- Query on partitioned table
EXPLAIN ANALYZE
SELECT *
FROM bookings_partitioned
WHERE start_date BETWEEN '2024-01-01' AND '2024-06-30';
