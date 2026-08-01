# Rewards Redemption App

A basic rewards redemption web application implementing the Thanx take-home challenge.

**Stack:** React (frontend) · Ruby on Rails API (backend) · MySQL (database)

## Features

- View current reward points balance
- Browse available rewards
- Redeem rewards using points (with balance validation & transaction safety)
- View redemption history

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/users/:id` | Retrieve a user's points balance |
| GET | `/api/rewards` | List available rewards |
| POST | `/api/redemptions` | Redeem a reward (`{ "reward_id": 1 }`) |
| GET | `/api/redemptions` | User's redemption history |

> Demo mode uses a single hardcoded user (`id=1`). No authentication is implemented.

## Prerequisites

- Ruby 3.2+
- Rails 7.1+
- MySQL 8+
- Node.js 18+ (for the React frontend)

## Backend Setup

```bash
cd backend

# Install dependencies
bundle install

# Create database user & DBs (example for local MySQL)
mysql -u root -e "
  CREATE DATABASE IF NOT EXISTS rewards_api_development;
  CREATE DATABASE IF NOT EXISTS rewards_api_test;
  CREATE USER IF NOT EXISTS 'rewards'@'localhost' IDENTIFIED BY 'rewards';
  GRANT ALL PRIVILEGES ON rewards_api_development.* TO 'rewards'@'localhost';
  GRANT ALL PRIVILEGES ON rewards_api_test.* TO 'rewards'@'localhost';
  FLUSH PRIVILEGES;
"

# Configure database.yml if needed (defaults to user: rewards / password: rewards)

# Migrate & seed
bin/rails db:migrate
bin/rails db:seed

# Start the API server (port 3000)
bin/rails server
```

Seed data creates one demo user with **1000 points** and five sample rewards.

## Frontend Setup

```bash
cd frontend

npm install
npm run dev
```

The Vite dev server runs on http://localhost:5173 and talks to the API at http://localhost:3000.

## Notes

- Redemptions are performed inside a database transaction so the points balance and redemption record stay consistent.
- CORS is enabled for all origins in development for easy local testing.
- No authentication layer — this is intentionally scoped to the core requirements of the challenge.

## License

MIT
