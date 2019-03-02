--Display appointments and their total costs
SELECT DISTINCT A.appointment_id, "date", SUM(R.cost) AS total_cost
FROM Appointments AS A
INNER JOIN Repairs AS R
ON A.appointment_id=R.appointment_id
GROUP BY A.appointment_id;

--Display all trucks that require repair
SELECT DISTINCT T.license_plate, TM.model_name, TM.manufacturer
FROM Trucks AS T
INNER JOIN truckmodels AS TM
ON T.model_id=TM.model_id
INNER JOIN Appointments AS A
ON T.license_plate=A.license_plate
INNER JOIN Repairfrequency AS RF
ON T.model_id=RF.model_id
WHERE A.date <= current_date AND ( current_date - A.date > RF.frequency );

--Display list of salesman in decressing order of total rental sales
SELECT DISTINCT E.employee_id, E.employee_name, SUM(R.price) AS total_sales
FROM Employees AS E
INNER JOIN Rentals AS R
ON E.employee_id=R.employee_id
GROUP BY E.employee_id
ORDER BY total_sales DESC;

--Diplay all possible kinds of repairs (type and truck model) and the average cost
SELECT DISTINCT TM.model_id, TM.model_name, TM.manufacturer, R.repair_name,
COALESCE(AVG(R.cost), 0) AS avg_cost
FROM truckmodels AS TM
INNER JOIN Repairfrequency AS RF
ON TM.model_id=RF.model_id
LEFT JOIN Repairs AS R
ON RF.repair_name=R.repair_name
GROUP BY TM.model_id, R.repair_name, TM.model_name, TM.manufacturer
ORDER BY TM.model_id, R.repair_name;

--Display list of employees sorted by latest activity (latest completed appointment/rental sale)
SELECT DISTINCT E.employee_id, E.employee_name,
COALESCE(MAX(R.start_date)) AS latest_activity
FROM Employees AS E
INNER JOIN Salesmen AS S
ON E.employee_id=S.employee_id
LEFT JOIN Rentals AS R
ON E.employee_id=R.employee_id
GROUP BY E.employee_id
UNION
SELECT DISTINCT E.employee_id, E.employee_name,
COALESCE(MAX(A.date)) AS latest_activity
FROM Employees AS E
INNER JOIN Mechanics AS M
ON E.employee_id=M.employee_id
LEFT JOIN Appointments AS A
ON E.employee_id=A.employee_id
GROUP BY E.employee_id
ORDER BY latest_activity DESC;
