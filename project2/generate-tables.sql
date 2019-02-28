CREATE TABLE Repairtypes(repair_name VARCHAR(30) PRIMARY KEY, description VARCHAR(200));
CREATE TABLE Truckmodels(model_id INT PRIMARY KEY, model_name VARCHAR(20), manufacturer VARCHAR(20));
CREATE TABLE Rentees(rentee_id INT PRIMARY KEY, rentee_name VARCHAR(30), rentee_address VARCHAR(40));
CREATE TABLE Trucks(license_plate CHAR(6) PRIMARY KEY, color VARCHAR(15), model_id INT REFERENCES Truckmodels(model_id));
CREATE TABLE Employees(employee_id CHAR(9) PRIMARY KEY, employee_name VARCHAR(40));
CREATE TABLE Mechanics(employee_id CHAR(9) PRIMARY KEY REFERENCES Employees(employee_id), specialization VARCHAR(20));
CREATE TABLE Salesmen(employee_id CHAR(9) PRIMARY KEY REFERENCES Employees(employee_id));
CREATE TABLE Appointments(appointment_id CHAR(9) PRIMARY KEY, date DATE, license_plate CHAR(6) REFERENCES Trucks(license_plate), employee_id CHAR(9) REFERENCES Mechanics(employee_id));
CREATE TABLE Rentals(rental_id CHAR(9) PRIMARY KEY, price FLOAT, start_date DATE, end_date DATE, rentee_id INT REFERENCES Rentees(rentee_id), license_plate CHAR(6) REFERENCES Trucks(license_plate), employee_id CHAR(9) REFERENCES Salesmen(employee_id));
