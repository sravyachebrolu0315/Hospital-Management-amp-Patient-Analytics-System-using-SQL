-- CREATING DATABASE
CREATE DATABASE hospital_db;
USE hospital_db;

-- CREATING TABLES
-- Patients Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10)
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(100)
);

-- Appointments Table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Treatments Table
CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY,
    patient_id INT,
    diagnosis VARCHAR(100),
    cost DECIMAL(10,2),
    treatment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- INSERTING SAMPLE DATA IN THE DATABASE
-- Patients
INSERT INTO Patients VALUES
(1, 'Amit', 30, 'Male'),
(2, 'Sneha', 25, 'Female'),
(3, 'Rahul', 40, 'Male'),
(4, 'Priya', 35, 'Female');

-- Doctors
INSERT INTO Doctors VALUES
(101, 'Dr. Sharma', 'Cardiology'),
(102, 'Dr. Mehta', 'Orthopedics'),
(103, 'Dr. Rao', 'General Medicine');

-- Appointments
INSERT INTO Appointments VALUES
(1, 1, 101, '2026-04-01'),
(2, 2, 103, '2026-04-02'),
(3, 1, 103, '2026-04-05'),
(4, 3, 102, '2026-04-06'),
(5, 4, 101, '2026-04-07'),
(6, 1, 101, '2026-04-10');

-- Treatments
INSERT INTO Treatments VALUES
(1, 1, 'Heart Disease', 5000, '2026-04-01'),
(2, 2, 'Fever', 500, '2026-04-02'),
(3, 1, 'Checkup', 800, '2026-04-05'),
(4, 3, 'Fracture', 3000, '2026-04-06'),
(5, 4, 'Heart Disease', 4500, '2026-04-07'),
(6, 1, 'Heart Disease', 5200, '2026-04-10');

-- ANALYSIS
-- 1. Most Consulted Doctors
SELECT d.doctor_id, d.name, COUNT(a.appointment_id) AS total_visits
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name
ORDER BY total_visits DESC;

-- 2. Total Revenue Per Month
SELECT DATE_FORMAT(treatment_date, '%Y-%m') AS month, SUM(cost) AS total_revenue
FROM Treatments
GROUP BY month
ORDER BY month;

-- 3. Most Common Diseases
SELECT diagnosis, COUNT(*) AS frequency
FROM Treatments
GROUP BY diagnosis
ORDER BY frequency DESC;

-- 4. Patient Visit Frequency
SELECT p.patient_id, p.name, COUNT(a.appointment_id) AS visit_count
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.name
ORDER BY visit_count DESC;

-- 5. Doctor Performance Analysis
SELECT 
    d.doctor_id,
    d.name,
    d.specialization,
    COUNT(a.appointment_id) AS total_patients,
    AVG(t.cost) AS avg_treatment_cost
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN Treatments t ON a.patient_id = t.patient_id
GROUP BY d.doctor_id, d.name, d.specialization
ORDER BY total_patients DESC;

-- 6.Daily Appointment Count
SELECT date, COUNT(*) AS appointments
FROM Appointments
GROUP BY date
ORDER BY date;
