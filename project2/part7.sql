-- Lists the experience that a given mechanic has with working with specific truck models
-- This can be useful to determine which mechanics to assign to which trucks

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
-- Note that we cannot insert into this view because it utilises aggregate functions and a GROUP BY clause
SELECT * from MECHANICS_EXPERIENCE
