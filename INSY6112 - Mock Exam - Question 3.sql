
-- Q.3.1

-- I create the schema for this exam
CREATE SCHEMA IF NOT EXISTS library_ST10471627;

-- I work inside the new schema
USE library_ST10471627;


-- I create the Member table
CREATE TABLE Member (
    MemberID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    Phone VARCHAR(10) NULL
);


-- I create the Book table
CREATE TABLE Book (
    BookID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    Genre VARCHAR(30) NULL
);


-- I create the Loan bridging table
CREATE TABLE Loan (
    LoanID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE NOT NULL,
    ReturnDate DATE NULL,

    -- I link each loan to a member
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),

    -- I link each loan to a book
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);


-- Q.3.2

-- I insert the members
INSERT INTO Member (MemberID, Name, Surname, Phone)
VALUES
(1, 'Ayesha', 'Patel', '0831234567'),
(2, 'Sipho', 'Ndlovu', NULL),
(3, 'Grace', 'van Wyk', '0729876543');


-- I insert the books
INSERT INTO Book (BookID, Title, ISBN, Genre)
VALUES
(1, 'The Hidden Path', '9781000000011', 'Fiction'),
(2, 'Tech Revolution', '9781000000028', 'Technology'),
(3, 'Durban Kitchen', '9781000000035', 'Cooking');


-- I insert the loans
INSERT INTO Loan (LoanID, MemberID, BookID, LoanDate, ReturnDate)
VALUES
(1, 1, 1, '2025-02-10', '2025-02-24'),
(2, 2, 2, '2025-05-03', '2025-05-20'),
(3, 1, 3, '2025-11-15', NULL),
(4, 3, 1, '2026-01-08', NULL);


-- Q.3.3

-- I query all book titles in alphabetical order
SELECT Title
FROM Book
ORDER BY Title ASC;


-- Q.3.4

-- I query loans between the specified dates
SELECT *
FROM Loan
WHERE LoanDate BETWEEN '2025-01-01' AND '2025-06-30';


-- Q.3.5

-- I count how many books each member has borrowed
SELECT MemberID, COUNT(LoanID) AS NumberOfLoans
FROM Loan
GROUP BY MemberID;


-- Q.3.6

-- I display the member name, surname and book title for each loan
SELECT Member.Name, Member.Surname, Book.Title
FROM Loan
INNER JOIN Member
ON Loan.MemberID = Member.MemberID
INNER JOIN Book
ON Loan.BookID = Book.BookID;


-- Q.3.7

-- I create a unique index on the ISBN column
CREATE UNIQUE INDEX idx_unique_isbn
ON Book(ISBN);


-- Q.3.8

-- I create a view showing books that have not been returned
CREATE VIEW getbooksstillout AS
SELECT Book.Title, Member.Surname
FROM Loan
INNER JOIN Book
ON Loan.BookID = Book.BookID
INNER JOIN Member
ON Loan.MemberID = Member.MemberID
WHERE Loan.ReturnDate IS NULL;


-- I query the newly created view
SELECT *
FROM getbooksstillout;


-- Q.3.9

-- I create a stored procedure to count loans for a genre
DELIMITER //

CREATE PROCEDURE count_loans_for_genre(IN inputGenre VARCHAR(30))
BEGIN
    SELECT COUNT(*) AS NumberOfLoans
    FROM Loan
    INNER JOIN Book
    ON Loan.BookID = Book.BookID
    WHERE Book.Genre = inputGenre;
END //

DELIMITER ;

-- I call the stored procedure for the Fiction genre
CALL count_loans_for_genre('Fiction');
