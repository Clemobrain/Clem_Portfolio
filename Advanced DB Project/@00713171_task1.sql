--																		Create the Database with the name DelightHospital
CREATE DATABASE DelightHospital;

USE DelightHospital
GO


--																		Creation of my twelve (12) Below

CREATE TABLE Patient (
    PatientID int IDENTITY(1,1) PRIMARY KEY,
    FirstName nvarchar(30) NOT NULL,
    LastName nvarchar(30) NOT NULL,
    DateOfBirth date NOT NULL,
    Username nvarchar(40) NOT NULL,
    PasswordHash BINARY(64) NOT NULL, -- To Hash the password *hash binary*
	Salt UNIQUEIDENTIFIER,
    Email nvarchar(50) UNIQUE NOT NULL CHECK(Email LIKE '%_@_%._%'),
    Phone nvarchar(20) NOT NULL,
    InsuranceInfo nvarchar(100) NULL,
    DateActive date NOT NULL, -- Date patient joined
    DateLeft date NOT NULL, -- Date patient left
    CONSTRAINT CK_PasswordComplexity CHECK (
        PasswordHash LIKE '%[A-Za-z]%' -- At least one alphabetic character
        AND PasswordHash LIKE '%[0-9]%' -- At least one numeric character
        AND PasswordHash LIKE '%[^A-Za-z0-9]%' -- At least one non-alphanumeric character (e.g., symbol)
    )
);


CREATE TABLE Allergies (
    AllergyName nvarchar(30) NOT NULL,
    PatientID int NOT NULL,
    RegDate Date,
    CONSTRAINT PK_Allergies PRIMARY KEY (AllergyName, PatientID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);


CREATE TABLE Addresses (
    AddressID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PatientID int NOT NULL,
    Address1 nvarchar(40) NOT NULL,
    Address2 nvarchar(40) NULL,
    City nvarchar(30) NOT NULL,
    Postcode nvarchar(10) NOT NULL,
    CONSTRAINT FK_PatientID FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    CONSTRAINT UC_Address UNIQUE (Address1, Postcode)
);


CREATE TABLE Department (
    DeptID int IDENTITY(1,1)PRIMARY KEY,
    DeptName nvarchar(30) NOT NULL,
);


CREATE TABLE Doctor (
    DoctorID int IDENTITY(1,1) PRIMARY KEY,
    FirstName nvarchar(30) NOT NULL,
    LastName nvarchar(30) NOT NULL,
    Specialty nvarchar(30) NOT NULL,
    DeptID int NOT NULL,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);


CREATE TABLE DocSchedule (
    ScheduleID int IDENTITY(1,1) PRIMARY KEY,
    DoctorID int NOT NULL,
    AvailabilityStatus nvarchar(30) NOT NULL,
    ScheduleDate DATE,
    ScheduleTime TIME,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);


CREATE TABLE Appointment (
    AppointmentID int IDENTITY(1,1) PRIMARY KEY,
    ScheduleID int NOT NULL,
    PatientID int NOT NULL,
    AppointmentDate Date,
    AppointmentTime Time,
    Status nvarchar(30) NOT NULL CHECK (Status IN ('Pending', 'Cancelled', 'Completed')),
    FOREIGN KEY (ScheduleID) REFERENCES DocSchedule(ScheduleID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    CONSTRAINT CHK_AppointmentDate CHECK (AppointmentDate >= CAST(GETDATE() AS DATE))
);


 CREATE TABLE PastAppoint (
    PastAppointID int IDENTITY(1,1) PRIMARY KEY,
    ScheduleID int NOT NULL,
    PatientID int NOT NULL,
    AppointmentDate Date,
    AppointmentTime Time,
    Status nvarchar(30) NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    CONSTRAINT CHK_PastAppointmentDate CHECK (AppointmentDate < CAST(GETDATE() AS DATE))
);

ALTER TABLE ReviewFB
ALTER COLUMN Review VARCHAR(MAX);

CREATE TABLE ReviewFB (
    ReviewID int IDENTITY(1,1) PRIMARY KEY,
    PastAppointID int NOT NULL,
    Review Text NULL, 
    ReviewDate Date,
    FOREIGN KEY (PastAppointID) REFERENCES PastAppoint(PastAppointID)
);


CREATE TABLE MedicalRecord (
    MRecordID int IDENTITY(1,1) PRIMARY KEY,
    ScheduleID int NOT NULL,
    PatientID int NOT NULL,
    DateCreated Date NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (ScheduleID) REFERENCES DocSchedule(ScheduleID)
);


CREATE TABLE Diagnosis (
    DiagnosisName nvarchar(100),
    MRecordID int NOT NULL,
    DiagnoseDate Date NOT NULL,
    CONSTRAINT PK_Diagnosis PRIMARY KEY (DiagnosisName, MRecordID),
    FOREIGN KEY (MRecordID) REFERENCES MedicalRecord(MRecordID)
);


CREATE TABLE Medicine (
    MedicineName nvarchar(50),
    MRecordID int NOT NULL,
    MedicinePrescribedDate Date NULL,
    CONSTRAINT PK_Medicine PRIMARY KEY (MedicineName, MRecordID),
    FOREIGN KEY (MRecordID) REFERENCES MedicalRecord(MRecordID)
);


--													Procedure to populate patient table with encrypted secured password
CREATE PROCEDURE uspAddPatient 
		@FirstName  nvarchar(30),
		@LastName  nvarchar(30),
		@DateOfBirth date,
		@Username nvarchar(40),
		@PasswordHash nvarchar(50),
		@Email nvarchar(50) ,
		@Phone nvarchar(20),
		@InsuranceInfo nvarchar(100),
		@DateActive date,
		@DateLeft date
AS
DECLARE @Salt UNIQUEIDENTIFIER=NEWID()

INSERT INTO Patient(FirstName, LastName, DateOfBirth, Username,
PasswordHash, Salt, Email, Phone, InsuranceInfo, DateActive, DateLeft)

VALUES( @FirstName, @LastName, @DateOfBirth, @Username, HASHBYTES('SHA2_512',
@PasswordHash+CAST(@Salt AS nvarchar(36))), @Salt,
@Email, @Phone, @InsuranceInfo, @DateActive, @DateLeft);
--The HASHBYTES function in SQL Server returns the hash of the input. The first
--argument specifies the algorithm to be used:

-- Insert record for 'Alice'
EXECUTE uspAddPatient 
    @FirstName = 'Alice', @LastName = 'Johnson', @DateOfBirth = '1990-01-15', @Username = 'michael.johnson', @PasswordHash = 'plantation998', @Email = 'alice@gmail.com',
    @Phone = '07700900123', @InsuranceInfo = 'Health Insurance Corp', @DateActive = '2024-01-01', @DateLeft = '2024-03-15';

-- Insert record for 'Bob'
EXECUTE uspAddPatient 
    @FirstName = 'Bob', @LastName = 'Smith', @DateOfBirth = '1985-05-20', @Username = 'bob456', @PasswordHash = 'pascal223', @Email = 'bob@yahoo.com',
    @Phone = '07811234567', @InsuranceInfo = 'VitalShield Insurance Group', @DateActive = '2024-02-01', @DateLeft = '2024-03-15';

-- Insert record for 'Charlie'
EXECUTE uspAddPatient 
    @FirstName = 'Charlie', @LastName = 'Williams', @DateOfBirth = '1978-12-10', @Username = 'jane.smith', @PasswordHash = '456oscar', @Email = 'charlie@yahoo.com',
    @Phone = '07986543210', @InsuranceInfo = 'TrustCare Assurance Services', @DateActive = '2024-03-01', @DateLeft = '2024-04-15';  -- OLDER THAN 40   No. 9

-- Insert record for 'Olivia'
EXECUTE uspAddPatient 
    @FirstName = 'Olivia', @LastName = 'Garcia', @DateOfBirth = '1982-07-03', @Username = 'john.doe', @PasswordHash = 'test002', @Email = 'olivia.garcia@yahoo.com',
    @Phone = '07987654321', @InsuranceInfo = 'Maple Leaf Hospital', @DateActive = '2024-03-05', @DateLeft = '2024-03-10'; -- OLDER THAN 40  4

-- Insert record for 'Sarah'
EXECUTE uspAddPatient 
    @FirstName = 'Sarah', @LastName = 'Johnson', @DateOfBirth = '1985-05-15', @Username = 'sarah.j', @PasswordHash = '1234abcd', @Email = 'sarah.johnson@gmail.com',
    @Phone = '07555876543', @InsuranceInfo = 'SecureLife Insurance Corporation', @DateActive = '2024-03-28', @DateLeft = '2024-04-15';

-- Insert record for 'Michael'
EXECUTE uspAddPatient 
    @FirstName = 'Michael', @LastName = 'Smith', @DateOfBirth = '1990-09-22', @Username = 'mike_s', @PasswordHash = 'passpass', @Email = 'mike.smith@gmail.com',
    @Phone = '07422345678', @InsuranceInfo = 'HealthGuardian Assurance', @DateActive = '2024-03-29', @DateLeft = '2024-03-29';

-- Insert record for 'Emily'
EXECUTE uspAddPatient 
    @FirstName = 'Emily', @LastName = 'Brown', @DateOfBirth = '1980-08-25', @Username = 'em_brown', @PasswordHash = '123abc', @Email = 'emily_brown@hotmail.com',
    @Phone = '07899654321', @InsuranceInfo = 'HealthGuardian Assurance', @DateActive = '2024-02-29', @DateLeft = '2024-03-06';  -- OLDER THAN 40    8


-- Insert sample data into Addresses table
INSERT INTO Addresses (PatientID, Address1, Address2, City, Postcode) VALUES
(1, '123 Main St', 'Apt 101', 'Wigan', 'WN1 1AA'),
(2, '456 Elm St', NULL, 'Wigan', 'WN2 2BB'),
(4, '789 Oak St', NULL, 'Wigan', 'WN3 3CC'),
(5, '123 Main St', 'Apt 2B', 'Wigan', 'WN4 4DD'),
(6, '456 Elm St', NULL, 'Wigan', 'WN5 5EE'),
(8, '555 Pine St', 'Suite 100', 'Wigan', 'WN6 6FF'),
(9, '321 Maple St', 'Apt 5C', 'Wigan', 'WN7 7GG');

-- Insert statements for Allergies table
INSERT INTO Allergies (AllergyName, PatientID, RegDate) VALUES
('Peanuts', 1, '2024-06-02'),
('Penicillin', 2, '2024-06-03'),
('Dust', 4, '2024-06-04'),
('Cat Hair', 1, '2024-06-02'),
('Shellfish', 2, '2024-06-03'),
('Mold', 4, '2024-06-04'),
('Pollen', 1, '2024-06-02'),
('Eggs', 5, '2024-06-05'),
('Milk', 6, '2024-06-06'),
('Antibiotic', 8, '2024-06-07'),
('Nickel', 9, '2024-06-08');


-- Inserting data into the Departments table
INSERT INTO Department (DeptName)
VALUES 
('Cardiology'),
('Pediatrics'),
('Orthopedics'),
('Oncology'),
('Neurology'),
('Gastroenterology'),
('Psychiatrist');


-- Insert sample data into Doctor table
INSERT INTO Doctor (FirstName, LastName, Specialty, DeptID) VALUES
('John', 'Doe', 'Cardiologist', 1),
('Jane', 'Smith', 'Pediatrician', 2),
('Michael', 'Johnson', 'Orthopedic Surgeon', 3),
('Emily', 'Brown', 'Oncologist', 4),
('David', 'Lee', 'Neurologist', 5),
('James', 'Smith', 'Gastroenterologist', 6), 
('Clinton', 'Obama', 'Psychiatrist', 7);


-- Insert sample data into DocSchedule table
INSERT INTO DocSchedule (DoctorID, AvailabilityStatus, ScheduleDate, ScheduleTime) VALUES
(1, 'Available', '2024-06-02', '08:30'),
(2, 'Available', '2024-06-03', '09:50'),
(3, 'Available', '2024-06-04', '10:30'),
(4, 'Available', '2024-06-05', '10:00'),
(5, 'Available', '2024-06-06', '06:30'),
(6, 'Available', '2024-06-07', '11:30'),
(7, 'Available', '2024-06-08', '12:30');


-- Insert sample data into Appointment table
INSERT INTO Appointment (ScheduleID, PatientID, AppointmentDate, AppointmentTime, Status) VALUES
(1, 1, '2024-06-02', '08:00', 'Pending'),
(2, 2, '2024-06-03', '09:30', 'Pending'),
(3, 4, '2024-06-04', '10:00', 'Cancelled'),
(4, 5, '2024-06-05', '09:00', 'Pending'),
(5, 6, '2024-06-06', '06:00', 'Cancelled'),
(6, 8, '2024-06-07', '11:00', 'Pending'),
(7, 9, '2024-06-08', '12:00', 'Pending');


-- Insert statements for PastAppoint table
INSERT INTO PastAppoint (ScheduleID, PatientID, AppointmentDate, AppointmentTime, Status) VALUES
(1, 1, '2024-01-01', '10:00', 'Completed'),
(2, 2, '2024-01-02', '11:30', 'Completed'),
(3, 4, '2024-01-03', '13:00', 'Completed'),
(4, 5, '2024-01-03', '07:00', 'Completed'),
(5, 6, '2024-01-03', '09:00', 'Completed'),
(6, 8, '2024-01-03', '13:00', 'Completed'),
(7, 9, '2024-01-03', '13:00', 'Completed');


-- Insert statements for ReviewFB table
INSERT INTO ReviewFB (PastAppointID, Review, ReviewDate) VALUES
(1, 'The doctor was very attentive and knowledgeable.', '2024-01-01'),
(2, 'I had to wait a long time before being seen.', '2024-01-02'),
(3, 'The appointment was fine and quick.', '2024-01-03'),
(4, 'The staff was friendly and helpful.', '2024-01-03'),
(5, 'I had a positive experience overall.', '2024-01-03'),
(6, 'The appointment process was smooth and efficient.', '2024-01-03'),
(7, 'The nurse was very kind and compassionate.', '2024-01-03');


-- Insert sample data into MedicalRecord table
INSERT INTO MedicalRecord (ScheduleID, PatientID, DateCreated) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-02-01'),
(3, 4, '2024-03-05'),
(4, 5, '2024-03-28'),
(5, 6, '2024-03-29'),
(6, 8, '2024-02-29'),
(7, 9, '2024-03-01');


-- Insert sample data into Diagnosis table
INSERT INTO Diagnosis (DiagnosisName, MRecordID, DiagnoseDate) VALUES
('Hypertension', 1, '2024-01-02'),
('Asthma', 2, '2024-02-03'),
('Fractures', 3, '2024-03-06'),		
('Cancer', 4, '2024-03-29'),		-- cancer
('Migraine', 5, '2024-03-30'),
('Liver Disease', 6, '2024-02-29'),
('Bipolar Disorder', 7, '2024-03-05');  


-- Insert data into Medicine table
INSERT INTO Medicine (MedicineName, MRecordID, MedicinePrescribedDate) VALUES
('Lisinopril', 1, '2024-01-02'),
('Hydrochlorothiazide', 1, '2024-01-02'),
('Fluticasone', 2, '2024-02-03'),
('Ibuprofen', 3, '2024-03-06'),
('Chemotherapy', 4, '2024-03-29'),
('Painkillers', 4, '2024-03-29'),
('Sumatriptan', 5, '2024-03-30'),
('Ursodeoxycholic Acid (UDCA)', 6, '2024-02-29'),
('Lamotrigine', 7, '2024-03-05'),
('Carbamazepine', 7, '2024-03-05');









--No 2. Adding the constraint to check that the appointment date is not in the past.

CREATE TABLE Appointment (
    AppointmentID int IDENTITY(1,1) PRIMARY KEY,
    ScheduleID int NOT NULL,
    PatientID int NOT NULL,
    AppointmentDate Date,
    AppointmentTime Time,
    Status nvarchar(30) NOT NULL CHECK (Status IN ('Pending', 'Cancelled', 'Completed')),
    FOREIGN KEY (ScheduleID) REFERENCES DocSchedule(ScheduleID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    CONSTRAINT CHK_AppointmentDate CHECK (AppointmentDate >= CAST(GETDATE() AS DATE))-- check constraint to place only future dates
);





--No 3 List all the patients with older than 40 and have Cancer in diagnosis.

SELECT P.PatientID, P.FirstName, P.LastName, DateOfBirth
FROM Patient P
JOIN MedicalRecord M ON P.PatientID = M.PatientID
JOIN Diagnosis D ON M.MRecordID = D.MRecordID
WHERE DATEDIFF(YEAR, P.DateOfBirth, GETDATE()) > 40
AND D.DiagnosisName LIKE '%Cancer%';




--4a Search the database of the hospital for matching character strings by name of medicine. 
--Results should be sorted with most recent medicine prescribed date first.

CREATE PROCEDURE SearchMedicineName 
    @MedicineName NVARCHAR(100)
AS 
BEGIN
    SELECT MedicineName, MedicinePrescribedDate
    FROM Medicine 
    WHERE MedicineName LIKE '%' + @MedicineName + '%'
    ORDER BY MedicinePrescribedDate DESC
END
GO

-- Call the stored procedure
EXEC SearchMedicineName  @MedicineName = 'Chemotherapy'




--4b Return a full list of diagnosis and allergies for a specific patient who has an appointment today 
--(i.e., the system date when the query is run)

CREATE FUNCTION GetPatientDiagnosisAndAllergies (@PatientID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT D.DiagnosisName AS Diagnosis, A.AllergyName AS Allergy
    FROM Appointment AP
    JOIN Patient P ON AP.PatientID = P.PatientID
    JOIN MedicalRecord MR ON P.PatientID = MR.PatientID
    JOIN Diagnosis D ON MR.MRecordID = D.MRecordID
    JOIN Allergies A ON P.PatientID = A.PatientID
    WHERE P.PatientID = @PatientID
    AND CONVERT(DATE, AP.AppointmentDate) = GETDATE()
);



-- Execute the UDF for a specific patient ID
SELECT * FROM GetPatientDiagnosisAndAllergies(5); -- Replace  with the actual patient ID







-- 4c
CREATE PROCEDURE UpdateDoctorsDetails
    @DoctorID int,
    @FirstName nvarchar(30),
    @LastName nvarchar(30),
    @Specialty nvarchar(30),
	@DeptID int
AS
BEGIN
    UPDATE Doctor
    SET 
        FirstName = @FirstName,
        LastName = @LastName,
        Specialty = @Specialty,
		DeptID = @DeptID
    WHERE 
        DoctorID = @DoctorID
END;



-- Call this stored procedure and pass the DoctorID along with the updated details as parameters to update the doctor's information. 
EXEC UpdateDoctorsDetails 
    @DoctorID = 7,
    @FirstName = 'Clynton',
    @LastName = 'Anderson',
    @Specialty = 'Forensic Psychiatry',
    @DeptID = 7;







-- 4d
CREATE PROCEDURE TransferAndDeleteCompletedAppointments
AS
BEGIN
    -- To Insert completed appointment into PastAppoint table
    INSERT INTO PastAppoint (ScheduleID, PatientID, AppointmentDate,
    AppointmentTime, [Status])
    SELECT A.ScheduleID, A.PatientID, AppointmentDate,
    AppointmentTime, A.[Status]
    FROM Appointment A
    INNER JOIN Patient P ON A.PatientID = P.PatientID -- Join with Patient table
    WHERE A.[Status] = 'Completed';

    -- To Delete completed appointments from Appointments table
    DELETE FROM Appointment
    WHERE Status = 'Completed';
END;


-- To Exec the move and deletion procedure
EXEC TransferAndDeleteCompletedAppointments;









--5 Create view having Appointment and Pastappointment put in one table

CREATE VIEW DoctorAppointmentsView AS
SELECT 
    A.AppointmentID,
    A.AppointmentDate,
    A.AppointmentTime,
    D.FirstName + ' ' + D.LastName AS DoctorName,
    D.Specialty AS DoctorSpecialty,
    Dep.DeptName AS Department,
    NULL AS DoctorReview
FROM 
    Appointment A
JOIN 
    Patient P ON A.PatientID = P.PatientID
JOIN 
    DocSchedule DS ON A.ScheduleID = DS.ScheduleID
JOIN 
    Doctor D ON DS.DoctorID = D.DoctorID
JOIN 
    Department Dep ON D.DeptID = Dep.DeptID

UNION

SELECT 
    PA.PastAppointID,
    PA.AppointmentDate,
    PA.AppointmentTime,
    D.FirstName + ' ' + D.LastName AS DoctorName,
    D.Specialty AS DoctorSpecialty,
    Dep.DeptName AS Department,
    R.Review AS DoctorReview
FROM 
    PastAppoint PA
JOIN 
    Patient P ON PA.PatientID = P.PatientID
JOIN 
    Appointment A ON P.PatientID = A.PatientID
JOIN 
    DocSchedule DS ON A.ScheduleID = DS.ScheduleID
JOIN 
    Doctor D ON DS.DoctorID = D.DoctorID
JOIN 
    Department Dep ON D.DeptID = Dep.DeptID
JOIN 
    ReviewFB R ON PA.PastAppointID = R.PastAppointID;




	--To view the data from the DoctorAppointmentView
SELECT * FROM DoctorAppointmentsView;










  --6.

  CREATE TRIGGER ChangeAppointmentState
ON Appointment
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Status)
    BEGIN
        UPDATE Appointment
        SET Status = 'Available'
        WHERE Status = 'Cancelled'
            AND EXISTS (SELECT 1 FROM inserted 
			WHERE inserted.AppointmentID = Appointment.AppointmentID);
    END
END;




--7.

SELECT COUNT(*) AS NumPastAppointments
FROM PastAppoint PA
JOIN Patient P ON PA.PatientID = P.PatientID
JOIN Appointment A ON P.PatientID = A.PatientID
JOIN DocSchedule DS ON A.ScheduleID = DS.ScheduleID
JOIN Doctor D ON DS.DoctorID = D.DoctorID
WHERE  D.Specialty = 'Gastroenterologist';
