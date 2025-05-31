# Library Management System Database

![yoyuqruo](https://github.com/user-attachments/assets/b89680b1-2cab-49d4-87de-4ce1499bbc79)

## Overview
This project provides a MySQL-based relational database for a Library Management System. It supports core library operations such as managing books, authors, members, loans, fines, and reservations. The database is designed with normalized tables, foreign key constraints, triggers, views, and stored procedures to ensure data integrity and functionality.

## Features
- Books Management: Track book details (title, ISBN, publisher, etc.) and availability.
- Authors: Manage authors with many-to-many relationships to books.
- Categories: Categorize books (e.g., Fiction, Non-Fiction).
- Members: Store member information (name, email, etc.).
- Loans: Track book borrowing with borrow and due dates.
- Fines: Manage fines for overdue loans.
- Reservations: Handle book reservations with status tracking.
- Triggers: Automatically update book availability on loans.
- Views: Provide quick access to overdue loans.
- Stored Procedures: Simplify operations like borrowing books.

## Database Schema
The database includes the following tables:
- Categories: Stores book genres/categories.
- Authors: Stores author details.
- Books: Stores book information with category references.
- Book_Authors: Junction table for book-author relationships.
- Members: Stores library member information.
- Loans: Tracks book borrowing transactions.
- Fines: Manages fines for overdue loans.
- Reservations: Handles book reservations.

## Relationship

![ERD Library management](https://github.com/user-attachments/assets/d61ec6fd-a8b8-4663-b211-827504fae30f)

The above image is the ERD(Entity Relationship Diagram) for the Library Databse

