-- Create Database
CREATE DATABASE library_management;
USE library_management;

-- Create Categories Table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Create Authors Table
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

-- Create Books Table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) NOT NULL UNIQUE,
    publication_year INT,
    publisher VARCHAR(100),
    category_id INT,
    total_copies INT NOT NULL,
    available_copies INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    CHECK (available_copies <= total_copies)
);

-- Create Book_Authors Junction Table
CREATE TABLE Book_Authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Create Members Table
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    join_date DATE NOT NULL,
    address VARCHAR(255)
);

-- Create Loans Table
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    CHECK (due_date >= borrow_date)
);

-- Create Fines Table
CREATE TABLE Fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT UNIQUE,
    member_id INT,
    amount DECIMAL(5,2) NOT NULL,
    issue_date DATE NOT NULL,
    paid_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Create Reservations Table
CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    reservation_date DATE NOT NULL,
    status ENUM('active', 'fulfilled', 'cancelled') NOT NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Insert Categories
INSERT INTO Categories (category_name) VALUES
('Fiction'),
('Non-Fiction'),
('Science Fiction');

-- Insert Authors
INSERT INTO Authors (first_name, last_name) VALUES
('J.K.', 'Rowling'),
('Isaac', 'Asimov');

-- Insert Books
INSERT INTO Books (title, isbn, publication_year, publisher, category_id, total_copies, available_copies) VALUES
('Harry Potter', '9780747532699', 1997, 'Bloomsbury', 1, 5, 3),
('Foundation', '9780553293357', 1951, 'Bantam', 3, 3, 2);

-- Insert Book_Authors
INSERT INTO Book_Authors (book_id, author_id) VALUES
(1, 1),
(2, 2);

-- Insert Members
INSERT INTO Members (first_name, last_name, email, phone, join_date, address) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '2025-01-01', '123 Main St'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321', '2025-02-01', '456 Oak Ave');

-- Insert Loans
INSERT INTO Loans (book_id, member_id, borrow_date, due_date) VALUES
(1, 1, '2025-05-01', '2025-05-15'),
(2, 2, '2025-05-10', '2025-05-24');

-- Insert Fines
INSERT INTO Fines (loan_id, member_id, amount, issue_date) VALUES
(1, 1, 5.00, '2025-05-16');

-- Insert Reservations
INSERT INTO Reservations (book_id, member_id, reservation_date, status) VALUES
(1, 2, '2025-05-20', 'active');

DELIMITER //
CREATE TRIGGER after_loan_insert
AFTER INSERT ON Loans
FOR EACH ROW
BEGIN
    UPDATE Books
    SET available_copies = available_copies - 1
    WHERE book_id = NEW.book_id;
END //
DELIMITER ;

CREATE INDEX idx_isbn ON Books(isbn);
CREATE INDEX idx_email ON Members(email);

CREATE VIEW Overdue_Loans AS
SELECT l.loan_id, b.title, m.first_name, m.last_name, l.due_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL AND l.due_date < CURDATE();


DELIMITER //
CREATE PROCEDURE BorrowBook(IN p_book_id INT, IN p_member_id INT, IN p_due_date DATE)
BEGIN
    INSERT INTO Loans (book_id, member_id, borrow_date, due_date)
    VALUES (p_book_id, p_member_id, CURDATE(), p_due_date);
END //
DELIMITER ;

SELECT book_id, title, available_copies FROM Books WHERE book_id = 1;

SELECT * FROM Books;
SELECT * FROM Members;
SELECT * FROM Loans;

SELECT * FROM Overdue_Loans;

CALL BorrowBook(1, 1, '2025-06-15');
SELECT * FROM Loans;