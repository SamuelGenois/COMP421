CREATE TABLE repairtypes
  (
     repair_name VARCHAR(30) PRIMARY KEY,
     description VARCHAR(200)
  );

CREATE TABLE truckmodels
  (
     model_id     SERIAL PRIMARY KEY,
     model_name   VARCHAR(20),
     manufacturer VARCHAR(20)
  );

CREATE TABLE rentees
  (
     rentee_id      SERIAL PRIMARY KEY,
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
     employee_id   SERIAL PRIMARY KEY,
     employee_name VARCHAR(40)
  );

CREATE TABLE mechanics
  (
     employee_id    INT PRIMARY KEY REFERENCES employees(employee_id),
     specialization VARCHAR(20)
  );

CREATE TABLE salesmen
  (
     employee_id    INT PRIMARY KEY REFERENCES employees(employee_id)
  );

CREATE TABLE appointments
  (
     appointment_id SERIAL PRIMARY KEY,
     date           DATE,
     license_plate  CHAR(6) REFERENCES trucks(license_plate),
     employee_id    INT REFERENCES mechanics(employee_id)
  );

CREATE TABLE rentals
  (
     rental_id     SERIAL PRIMARY KEY,
     price         FLOAT,
     start_date    DATE,
     end_date      DATE,
     rentee_id     INT REFERENCES rentees(rentee_id),
     license_plate CHAR(6) REFERENCES trucks(license_plate),
     employee_id   INT REFERENCES salesmen(employee_id)
  );

CREATE TABLE repairs
  (
     cost           FLOAT,
     appointment_id INT REFERENCES appointments(appointment_id),
     repair_name    VARCHAR(30) REFERENCES repairtypes,
     PRIMARY KEY (repair_name, appointment_id)
  );

CREATE TABLE datapoints
  (
     datetime   DATE,
     position   point,
     fuel_level FLOAT,
     rental_id  INT REFERENCES rentals(rental_id),
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
