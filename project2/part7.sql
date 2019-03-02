-- Lists the experience that a given mechanic has with working with specific truck models
-- This can be useful to determine which mechanics to assign to which trucks

DROP VIEW if exists MECHANICS_EXPERIENCE;
CREATE VIEW MECHANICS_EXPERIENCE as
SELECT
    employees.employee_id,
    employees.employee_name,
    truckmodels.model_id,
    truckmodels.model_name,
    truckmodels.manufacturer,
    Count(appointments.date) as number_of_repairs
FROM employees
INNER JOIN appointments
ON employees.employee_id = appointments.employee_id
INNER JOIN trucks
ON appointments.license_plate = trucks.license_plate
INNER JOIN truckmodels
ON trucks.model_id = truckmodels.model_id
GROUP BY employees.employee_id, employees.employee_name, truckmodels.model_id, truckmodels.model_name, truckmodels.manufacturer;

-- Since the role of this view is simply to create a report, the most interesting thing to do is simply to query it
SELECT * from MECHANICS_EXPERIENCE;



-- A simple view that contains this rentals and all the data associated to them
DROP VIEW if exists DETAILED_RENTALS;
CREATE VIEW DETAILED_RENTALS as
SELECT 
    rentals.rental_id,
    rentals.price,
    rentals.start_date,
    rentals.end_date,
    rentees.rentee_id,
    rentees.rentee_name,
    rentees.rentee_address,
    trucks.license_plate,
    trucks.color,
    trucks.model_id,
    employees.employee_id,
    employees.employee_name
FROM rentals
INNER JOIN rentees ON rentals.rentee_id = rentees.rentee_id
INNER JOIN trucks ON rentals.license_plate = trucks.license_plate
INNER JOIN salesmen ON rentals.employee_id = salesmen.employee_id
INNER JOIN employees ON rentals.employee_id = employees.employee_id;

-- Since the role of this view is simply to create a report, the most interesting thing to do is simply to query it
SELECT * from DETAILED_RENTALS;

-- It is also possible to create reports of which trucks are rented on a given date
SELECT *
from DETAILED_RENTALS
WHERE
    start_date <= '2019-01-19' AND
    end_date >= '2019-01-19';




-- Trying to insert data into views
-- Data cannot be inserted into this view because it utilises aggregate functions and a GROUP BY clause.
INSERT INTO MECHANICS_EXPERIENCE VALUES (13, 'Mathieu Fryman', 3, 'Chiller truck', 'Trucks & co.', 7);
-- Data cannot be inserted as a full row of this view because it queries data from multiple tables.
INSERT INTO DETAILED_RENTALS VALUES (4, 5.23, '2019-01-30', '2019-01-15', 4, 'Bob Ruppert', '248 Prospect Route', 'LDY856', 'Yellow', 3, 3, 'Alverta Ketcham');
