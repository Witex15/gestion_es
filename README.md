# School Management System

[![Ruby](https://img.shields.io/badge/Ruby-3.3.0-red)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.0.0-red)](https://rubyonrails.org/)

A Ruby on Rails application for managing educational institutions with comprehensive tracking of school classes, students, teachers, courses, examinations, and grades. Features role-based access control and soft delete functionality throughout.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Test Users](#test-users)
- [Usage](#usage)
- [Soft Delete Implementation](#soft-delete-implementation)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- Ruby 3.3.0
- Rails 8.0.0+
- SQLite3 (development)
- PostgreSQL (production)
- Node.js and Yarn for JavaScript dependencies

## Installation

1. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

## Database Setup

To set up the database from scratch:

```bash
# Option 1: Full reset (drop, create, migrate, seed)
rails db:reset

# Option 2: Step by step
rails db:drop
rails db:create
rails db:migrate
rails db:seed
```

The seed data will create a complete educational system with:
- 3 educational sectors
- Multiple school classes
- 5 test rooms
- 5 subjects
- 20 students (including test student)
- 5 teachers (including test teacher)
- Course schedules
- Example examinations and grades

## Test Users

The database seeds include the following test users for easy testing:

| Role    | Username | Email               | Password    |
|---------|----------|---------------------|-------------|
| Dean    | dean     | dean@school.com     | password123 |
| Teacher | teacher  | teacher@school.com  | password123 |
| Student | student  | student@school.com  | password123 |

## Usage

1. Start the Rails server:
   ```bash
   rails server
   ```

2. Visit `http://localhost:3000` in your browser

3. Log in with one of the test user credentials

4. Navigation:
   - As a Dean: Full access to all sections
   - As a Teacher: View classes, courses, students, and manage grades
   - As a Student: View personal schedule and grades

## Soft Delete Implementation

This application uses soft delete throughout to preserve data integrity while allowing for record "deletion":

- Records are never physically deleted, only marked with a `deleted_at` timestamp
- Database queries automatically filter out soft-deleted records using a default scope
- Foreign key relationships remain intact, preventing constraint errors
- To permanently delete records when necessary, use `record.really_destroy!`

## Contributing

1. Fork the project
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes using conventional commits: `git commit -m "feat: add amazing feature"`
4. Push to your branch: `git push origin feature/amazing-feature`
5. Open a pull request
