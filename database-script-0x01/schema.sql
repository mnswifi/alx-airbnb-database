-- Lookup tables to replace ENUMs
CREATE TABLE roles (
  role_id UUID PRIMARY KEY,
  role_name VARCHAR(50) UNIQUE NOT NULL  -- guest, host, admin
);

CREATE TABLE booking_statuses (
  status_id UUID PRIMARY KEY,
  status_name VARCHAR(50) UNIQUE NOT NULL  -- pending, confirmed, canceled
);

CREATE TABLE payment_methods (
  method_id UUID PRIMARY KEY,
  method_name VARCHAR(50) UNIQUE NOT NULL  -- credit_card, paypal, stripe
);

-- Locations (normalize Property.location)
CREATE TABLE locations (
  location_id UUID PRIMARY KEY,
  street VARCHAR(200) NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NULL,
  country VARCHAR(100) NOT NULL,
  postal_code VARCHAR(20) NULL
);

-- Users
CREATE TABLE users (
  user_id UUID PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(30) NULL,
  role_id UUID NOT NULL REFERENCES roles(role_id),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Properties
CREATE TABLE properties (
  property_id UUID PRIMARY KEY,
  host_id UUID NOT NULL REFERENCES users(user_id),
  name VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  location_id UUID NOT NULL REFERENCES locations(location_id),
  price_per_night DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Bookings
CREATE TABLE bookings (
  booking_id UUID PRIMARY KEY,
  property_id UUID NOT NULL REFERENCES properties(property_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10,2) NOT NULL, -- snapshot at booking time
  status_id UUID NOT NULL REFERENCES booking_statuses(status_id),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_date_range CHECK (start_date < end_date)
);

-- Payments (one-to-many per booking)
CREATE TABLE payments (
  payment_id UUID PRIMARY KEY,
  booking_id UUID NOT NULL REFERENCES bookings(booking_id),
  amount DECIMAL(10,2) NOT NULL,
  payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  method_id UUID NOT NULL REFERENCES payment_methods(method_id)
);

-- Reviews (tie to booking to guarantee stay)
CREATE TABLE reviews (
  review_id UUID PRIMARY KEY,
  booking_id UUID NOT NULL REFERENCES bookings(booking_id) UNIQUE, -- one review per booking
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Messages
CREATE TABLE messages (
  message_id UUID PRIMARY KEY,
  sender_id UUID NOT NULL REFERENCES users(user_id),
  recipient_id UUID NOT NULL REFERENCES users(user_id),
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Helpful Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_properties_host ON properties(host_id);
CREATE INDEX idx_properties_location ON properties(location_id);
CREATE INDEX idx_bookings_property_dates ON bookings(property_id, start_date, end_date);
CREATE INDEX idx_payments_booking ON payments(booking_id);
