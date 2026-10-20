-- 1. Database & Table Creation (DDL)

CREATE DATABASE IF NOT EXISTS UniversityCMS;
USE UniversityCMS;

-- 1. Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL
);

-- 2. Instructors Table (Includes Salary column for Query 8)
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10, 2) DEFAULT 50000.00,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 3. Courses Table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Credits INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 4. Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    BirthDate DATE NOT NULL,
    EnrollmentDate DATE NOT NULL
);

-- 5. Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 2. Sample Data Insertion (DML)

-- Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

-- Instructors
INSERT INTO Instructors (InstructorID, FirstName, LastName, Email, DepartmentID, Salary) VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1, 85000.00),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2, 78000.00),
(3, 'Charlie', 'Davis', 'charlie.davis@univ.com', 1, 92000.00);

-- Courses
INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits) VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4),
(103, 'Linear Algebra', 2, 3),
(104, 'Discrete Mathematics', 2, 4),
(105, 'Calculus I', 2, 4),
(106, 'Probability & Statistics', 2, 3),
(107, 'Numerical Methods', 2, 3);

-- Students
INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01'),
(3, 'Michael', 'Brown', 'michael.b@email.com', '2002-03-10', '2023-01-15'),
(4, 'Emily', 'Clark', 'emily.c@email.com', '1998-11-20', '2019-09-01'),
(5, 'David', 'Wilson', 'david.w@email.com', '2003-07-04', '2024-02-10'),
(6, 'Sarah', 'Connor', 'sarah.c@email.com', '2001-12-12', '2020-08-15');

-- Enrollments
INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01'),
(3, 1, 102, '2022-08-10'),
(4, 3, 101, '2023-01-20'),
(5, 4, 101, '2023-01-22'),
(6, 5, 101, '2024-02-15');

-- 3. Required Queries Implementation
-- 1. Perform CRUD Operations on all tables

-- CREATE (Insert)
INSERT INTO Students (FirstName, LastName, Email, BirthDate, EnrollmentDate) 
VALUES ('Test', 'User', 'test.user@email.com', '2001-01-01', '2023-08-01');

-- READ (Select)
SELECT * FROM Students WHERE Email = 'test.user@email.com';

-- UPDATE
UPDATE Students 
SET LastName = 'UpdatedUser' 
WHERE Email = 'test.user@email.com';

-- DELETE
DELETE FROM Students 
WHERE Email = 'test.user@email.com';

-- 2. Retrieve students who enrolled after 2022

SELECT * 
FROM Students 
WHERE EnrollmentDate > '2022-12-31';

-- 3. Retrieve courses offered by the Mathematics department with a limit of 5 courses

SELECT c.CourseID, c.CourseName, c.Credits, d.DepartmentName
FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;

-- 4. Get the number of students enrolled in each course, filtering for courses with more than 5 students

SELECT c.CourseID, c.CourseName, COUNT(e.StudentID) AS StudentCount
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName
HAVING COUNT(e.StudentID) > 5;

-- 5. Find students who are enrolled in both 'Introduction to SQL' and 'Data Structures'

SELECT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures')
GROUP BY s.StudentID, s.FirstName, s.LastName
HAVING COUNT(DISTINCT c.CourseName) = 2;

-- 6. Find students who are either enrolled in 'Introduction to SQL' or 'Data Structures'

SELECT DISTINCT s.StudentID, s.FirstName, s.LastName, s.Email
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');

-- 7. Calculate the average number of credits for all courses

SELECT ROUND(AVG(Credits), 2) AS AverageCredits 
FROM Courses;

-- 8. Find the maximum salary of instructors in the Computer Science department

SELECT MAX(i.Salary) AS MaxCSSalary
FROM Instructors i
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';

-- 9. Count the number of students enrolled in each department

SELECT d.DepartmentID, d.DepartmentName, COUNT(DISTINCT e.StudentID) AS TotalStudents
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentID, d.DepartmentName;

-- 10. INNER JOIN: Retrieve students and their corresponding courses

SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- 11. LEFT JOIN: Retrieve all students and their corresponding courses, if any

SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- 12. Subquery: Find students enrolled in courses that have more than 10 students

SELECT DISTINCT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (
    SELECT CourseID
    FROM Enrollments
    GROUP BY CourseID
    HAVING COUNT(StudentID) > 10
);

-- 13. Extract the year from the EnrollmentDate of students

SELECT StudentID, FirstName, LastName, YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;

-- 14. Concatenate the instructor's first and last name

SELECT InstructorID, CONCAT(FirstName, ' ', LastName) AS FullName, Email
FROM Instructors;

-- 15. Calculate the running total of students enrolled in courses

SELECT 
    EnrollmentID,
    CourseID,
    StudentID,
    EnrollmentDate,
    COUNT(StudentID) OVER (ORDER BY EnrollmentDate, EnrollmentID) AS RunningTotalStudents
FROM Enrollments;

-- 16. Label students as 'Senior' or 'Junior' based on their year of enrollment

SELECT 
    StudentID, 
    FirstName, 
    LastName, 
    EnrollmentDate,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, EnrollmentDate) / 365.25 > 4 THEN 'Senior'
        ELSE 'Junior'
    END AS StudentStatus
FROM Students;
