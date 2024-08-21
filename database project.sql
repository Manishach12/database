-- Create Database
CREATE DATABASE Assignment;

-- Use the Database
USE Assignment;

-- Create Student Table
CREATE TABLE Student (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender CHAR(1),
    Address VARCHAR(255),
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100),
    ParentName VARCHAR(100),
    ParentNumber VARCHAR(15)
);

-- Create Teacher Table
CREATE TABLE Teacher (
    TeacherID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender CHAR(1),
    Address VARCHAR(255),
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100),
    HireDate DATE
);

-- Create Class Table
CREATE TABLE Class (
    ClassID INT PRIMARY KEY AUTO_INCREMENT,
    ClassName VARCHAR(50),
    TeacherID INT,
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID)
);
select * from class;


-- Create Subject Table
CREATE TABLE Subject (
    SubjectID INT PRIMARY KEY AUTO_INCREMENT,
    SubjectName VARCHAR(50),
    ClassID INT,
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID)
);

-- Create Enrollment Table
CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    ClassID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID)
);

-- Create LibraryRecords Table
CREATE TABLE LibraryRecords (
    LibraryID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    BookTitle VARCHAR(255),
    Author VARCHAR(255),
    IssueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

-- Create Events Table
CREATE TABLE Events (
    EventID INT PRIMARY KEY AUTO_INCREMENT,
    EventName VARCHAR(100),
    Date DATE,
    Location VARCHAR(100)
);

-- Create Exam Table
CREATE TABLE Exam (
    ExamID INT PRIMARY KEY AUTO_INCREMENT,
    SubjectID INT,
    ExamDate DATE,
    MaxMarks DECIMAL(5, 2),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
);

-- Create ExamResult Table
CREATE TABLE ExamResult (
    ExamResultID INT PRIMARY KEY AUTO_INCREMENT,
    ExamID INT,
    StudentID INT,
    MarksObtained DECIMAL(5, 2),
    FOREIGN KEY (ExamID) REFERENCES Exam(ExamID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

-- Create Attendance Table
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    Date DATE,
    Status VARCHAR(10),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

-- Create FeePayment Table
CREATE TABLE FeePayment (
    FeePaymentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    PaymentDate DATE,
    AmountPaid DECIMAL(10, 2),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

-- Insert data into Student Table
INSERT INTO Student (FirstName, LastName, DateOfBirth, Gender, Address, PhoneNumber, Email, ParentName, ParentNumber) VALUES
('Niraj', 'Chand', '2005-06-15', 'M', '123 Elm St', '555-1234', 'niraj@example.com', 'Radha Chand', '555-5678'),
('Jenny', 'Chand', '2006-07-20', 'F', '456 Oak St', '555-5678', 'jenny@example.com', 'Vidsha Chand', '555-9876');

-- Insert data into Teacher Table
INSERT INTO Teacher (FirstName, LastName, DateOfBirth, Gender, Address, PhoneNumber, Email, HireDate) VALUES
('Ayush', 'Kaji', '1980-03-15', 'M', '789 Pine St', '555-1111', 'ayush@example.com', '2005-08-01'),
('Albert', 'Mharjan', '1975-11-22', 'M', '321 Maple St', '555-2222', 'albert@example.com', '2000-09-01');

-- Insert data into Class Table
INSERT INTO Class (ClassName, TeacherID) VALUES
('Database', 1),
('OOP', 2);

-- Insert data into Subject Table
INSERT INTO Subject (SubjectName, ClassID) VALUES
('Relational Model', 1),
('Java', 2);

-- Insert data into Enrollment Table
INSERT INTO Enrollment (StudentID, ClassID, EnrollmentDate) VALUES
(1, 1, '2023-08-01'),
(2, 2, '2023-08-01');

-- Insert data into LibraryRecords Table
INSERT INTO LibraryRecords (StudentID, BookTitle, Author, IssueDate, ReturnDate) VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', '2023-08-10', '2023-08-20'),
(2, '1984', 'George Orwell', '2023-08-15', '2023-08-25');

-- Insert data into Events Table
INSERT INTO Events (EventName, Date, Location) VALUES
('Database Fair', '2023-09-10', 'Lab'),
('Java Olympiad', '2023-10-05', 'Classroom');

-- Insert data into Exam Table
INSERT INTO Exam (SubjectID, ExamDate, MaxMarks) VALUES
(1, '2023-11-01', 100),
(2, '2023-11-15', 100);

-- Insert data into ExamResult Table
INSERT INTO ExamResult (ExamID, StudentID, MarksObtained) VALUES
(1, 1, 85.50),
(2, 2, 90.00);

-- Insert data into Attendance Table
INSERT INTO Attendance (StudentID, Date, Status) VALUES
(1, '2023-08-01', 'Present'),
(2, '2023-08-01', 'Absent');

-- Insert data into FeePayment Table
INSERT INTO FeePayment (StudentID, PaymentDate, AmountPaid) VALUES
(1, '2023-08-10', 500.00),
(2, '2023-08-10', 600.00);

-- Update FeePayment to increase AmountPaid by 20%
UPDATE FeePayment
SET AmountPaid = AmountPaid * 1.20;

-- Delete students' records from the "Attendance" table for those absent for over 10 consecutive days in the month
DELETE FROM Attendance
WHERE StudentID IN (
    SELECT StudentID FROM (
        SELECT StudentID, COUNT(*) AS AbsentDays
        FROM Attendance
        WHERE Status = 'Absent'
        AND Date BETWEEN '2023-08-01' AND '2023-08-31'
        GROUP BY StudentID
        HAVING COUNT(*) > 10
    ) AS Temp
);

-- Insert new student into Student table
INSERT INTO Student (FirstName, LastName, DateOfBirth, Gender, Address, PhoneNumber, Email, ParentName, ParentNumber) VALUES
('Snots', 'Bot', '2007-03-22', 'M', '123 Birch St', '555-3333', 'snots@example.com', 'Sarah Bot', '555-4444');

-- Insert enrollment details
INSERT INTO Enrollment (StudentID, ClassID, EnrollmentDate) VALUES
(LAST_INSERT_ID(), 1, '2023-08-15');

-- Insert fees payment history
INSERT INTO FeePayment (StudentID, PaymentDate, AmountPaid) VALUES
(LAST_INSERT_ID(), '2023-08-20', 550.00);

-- Retrieve a report of students' total marks in each subject, along with the overall percentage
SELECT
    s.FirstName,
    s.LastName,
    sub.SubjectName,
    SUM(er.MarksObtained) AS TotalMarks,
    (SUM(er.MarksObtained) / (e.MaxMarks * COUNT(sub.SubjectID))) * 100 AS Percentage
FROM Student s
JOIN ExamResult er ON s.StudentID = er.StudentID
JOIN Exam e ON er.ExamID = e.ExamID
JOIN Subject sub ON e.SubjectID = sub.SubjectID
GROUP BY s.FirstName, s.LastName, sub.SubjectName, e.MaxMarks;

-- Perform bulk updates to adjust students' grades so that all marks are deducted by 10%
START TRANSACTION;

UPDATE ExamResult
SET MarksObtained = MarksObtained * 0.90;

COMMIT;

-- Perform a SELECT query with multiple JOINs involving at least 4 tables, applying various conditions and filters
SELECT
    s.FirstName,
    s.LastName,
    c.ClassName,
    t.FirstName AS TeacherFirstName,
    sub.SubjectName,
    e.ExamDate,
    er.MarksObtained
FROM Student s
JOIN Enrollment en ON s.StudentID = en.StudentID
JOIN Class c ON en.ClassID = c.ClassID
JOIN Teacher t ON c.TeacherID = t.TeacherID
JOIN Subject sub ON c.ClassID = sub.ClassID
JOIN Exam e ON sub.SubjectID = e.SubjectID
JOIN ExamResult er ON e.ExamID = er.ExamID AND s.StudentID = er.StudentID
WHERE er.MarksObtained > 75
ORDER BY s.LastName, s.FirstName;