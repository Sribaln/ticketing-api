CREATE TABLE users (
                       id BIGSERIAL PRIMARY KEY,
                       email VARCHAR(255) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       role VARCHAR(20) NOT NULL,
                       created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE events (
                        id BIGSERIAL PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        venue VARCHAR(255) NOT NULL,
                        starts_at TIMESTAMPTZ NOT NULL,
                        created_by BIGINT NOT NULL REFERENCES users(id)
);

CREATE TABLE seats (
                       id BIGSERIAL PRIMARY KEY,
                       event_id BIGINT NOT NULL REFERENCES events(id),
                       label VARCHAR(20) NOT NULL,
                       price NUMERIC(10,2) NOT NULL,
                       status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
                       version BIGINT NOT NULL DEFAULT 0,
                       UNIQUE (event_id, label)
);

CREATE TABLE bookings (
                          id BIGSERIAL PRIMARY KEY,
                          user_id BIGINT NOT NULL REFERENCES users(id),
                          seat_id BIGINT NOT NULL REFERENCES seats(id),
                          status VARCHAR(20) NOT NULL,
                          idempotency_key VARCHAR(100) NOT NULL UNIQUE,
                          expires_at TIMESTAMPTZ,
                          created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);