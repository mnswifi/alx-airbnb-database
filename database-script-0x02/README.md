# Database Seed Data

This script inserts sample data into the existing database tables.  
It assumes that all tables (`Users`, `Properties`, `Bookings`, `Payments`) have already been created.

## Instructions

1. Make sure you are connected to your MySQL database.
2. Run the schema creation script first (if not already done).
3. Execute the seed script:

    ```bash
    mysql -u your_username -p your_database < seed_data.sql
    ```

4. Verify the data has been inserted:

    ```sql
    SELECT * FROM Users;
    SELECT * FROM Properties;
    SELECT * FROM Bookings;
    SELECT * FROM Payments;
    ```
