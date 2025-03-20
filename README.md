# School Management System

A Ruby on Rails application for managing school classes, students, teachers, courses, and grades with soft delete functionality.

## Database Setup

To set up the database from scratch:

```bash
# Drop the existing database
rails db:drop

# Create a new database
rails db:create

# Run migrations to set up database schema
rails db:migrate

# Seed the database with initial data
rails db:seed

# Or do all of the above in one command
rails db:reset
```

## Test Users

The database seeds include the following test users:

| Role    | Username | Email               | Password    |
|---------|----------|---------------------|-------------|
| Dean    | dean     | dean@school.com     | password123 |
| Teacher | teacher  | teacher@school.com  | password123 |
| Student | student  | student@school.com  | password123 |
