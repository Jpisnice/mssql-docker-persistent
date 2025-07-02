-- Create a new database called 'TestDB'
CREATE DATABASE TestDB;
GO

-- Switch to the new database
USE TestDB;
GO

-- Create a new table called 'Employees'
CREATE TABLE Employees (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Location NVARCHAR(50)
);
GO

-- Insert a new record into the 'Employees' table
INSERT INTO Employees (Id, Name, Location) VALUES
(1, 'John Doe', 'New York');
GO

-- Verify that the table was created and the record was inserted
SELECT * FROM Employees;
GO
