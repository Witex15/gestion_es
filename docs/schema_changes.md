# Database Schema Evolution: Changes from Base MLD

This document explains the differences between the base Model Logic Diagram (MLD) and the actual implemented database schema.

## Table Naming Changes

- **Classes → School_Classes**: Renamed to avoid conflicts with Ruby's reserved keyword "class".
- **People**: Implemented a single table with role distinction instead of separate student/teacher tables.

## Soft Delete Implementation

All tables now include:
- `deleted_at` timestamp field
- Index on `deleted_at` for efficient querying

This enables soft deletion pattern, preserving data for historical purposes while allowing "deletion" from the application perspective.

## Authentication Features

The `people` table now includes Devise authentication fields:
- `encrypted_password`
- `reset_password_token`
- `reset_password_sent_at`
- `remember_created_at`

## Timestamps

All tables include Rails standard timestamp fields:
- `created_at`
- `updated_at`

## Specific Table Changes

### Moments Table
- Implemented `moment_type` integer field for the enum (QUARTER, SEMESTER, YEAR)

### People Table
- Added `role` integer field instead of the enum type in the MLD
- Changed from string type for status to reference relationship with Status table

### Courses Table
- Added `archived` boolean field for tracking inactive courses
- Implemented `week_day` as integer field for the day enum
- Added `teacher_id` foreign key referencing people table

### School_Classes Table
- Changed relationship representation for clarity
- Explicit foreign keys for `master_id`, `room_id`, `moment_id`, `sector_id`

### Students_Classes Table
- Junction table implementation follows Rails conventions for many-to-many relationships

## Join Table Implementation

The relationship between students and classes is implemented through the `students_classes` join table, following Rails conventions for many-to-many relationships.

## Enum Implementation

Enums that were conceptual in the MLD are implemented as integer fields:
- `role` in people
- `moment_type` in moments
- `week_day` in courses

This follows Rails conventions for enum implementation.

## Index Optimizations

Strategic indexes added for:
- Foreign keys
- Fields frequently used in queries
- Soft delete columns 