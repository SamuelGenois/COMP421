CREATE TABLE repairtypes 
  ( 
     repair_name VARCHAR(30) PRIMARY KEY, 
     description VARCHAR(200) 
  ); 

CREATE TABLE truckmodels 
  ( 
     model_id     INT PRIMARY KEY, 
     model_name   VARCHAR(20), 
     manufacturer VARCHAR(20) 
  ); 

CREATE TABLE rentees 
  ( 
     rentee_id      INT PRIMARY KEY, 
     rentee_name    VARCHAR(30), 
     rentee_address VARCHAR(40) 
  ); 

CREATE TABLE trucks 
  ( 
     license_plate CHAR(6) PRIMARY KEY, 
     color         VARCHAR(15), 
     model_id      INT REFERENCES truckmodels(model_id) 
  ); 

CREATE TABLE employees 
  ( 
     employee_id   CHAR(9) PRIMARY KEY, 
     employee_name VARCHAR(40) 
  ); 

CREATE TABLE mechanics 
  ( 
     employee_id    CHAR(9) PRIMARY KEY REFERENCES employees(employee_id), 
     specialization VARCHAR(20) 
  ); 

CREATE TABLE salesmen 
  ( 
     employee_id CHAR(9) PRIMARY KEY REFERENCES employees(employee_id) 
  ); 

CREATE TABLE appointments 
  ( 
     appointment_id CHAR(9) PRIMARY KEY, 
     date           DATE, 
     license_plate  CHAR(6) REFERENCES trucks(license_plate), 
     employee_id    CHAR(9) REFERENCES mechanics(employee_id) 
  ); 

CREATE TABLE rentals 
  ( 
     rental_id     CHAR(9) PRIMARY KEY, 
     price         FLOAT, 
     start_date    DATE, 
     end_date      DATE, 
     rentee_id     INT REFERENCES rentees(rentee_id), 
     license_plate CHAR(6) REFERENCES trucks(license_plate), 
     employee_id   CHAR(9) REFERENCES salesmen(employee_id) 
  ); 

CREATE TABLE repairs 
  ( 
     repair_id      CHAR(12), 
     cost           FLOAT, 
     appointment_id CHAR(9) REFERENCES appointments(appointment_id), 
     repair_name    VARCHAR(30) REFERENCES repairtypes, 
     PRIMARY KEY (repair_id, appointment_id) 
  ); 

CREATE TABLE datapoints 
  ( 
     datetime   DATE, 
     position   VARCHAR(50), 
     fuel_level INT, 
     rental_id  CHAR(9) REFERENCES rentals(rental_id), 
     PRIMARY KEY (datetime, rental_id) 
  ); 

CREATE TABLE repairfrequency 
  ( 
     frequency   INT, 
     model_id    INT REFERENCES truckmodels(model_id), 
     repair_name VARCHAR(30) REFERENCES repairtypes(repair_name), 
     PRIMARY KEY (model_id, repair_name) 
  ); 

\d
\d Repairtypes
\d Truckmodels
\d Rentees
\d Trucks
\d Employees
\d Mechanics
\d Salesmen
\d Appointments
\d Rentals
\d Repairs
\d Datapoints
\d Repairfrequency
