-- Ensures that the start date is before the end date
ALTER TABLE rentals
DROP CONSTRAINT if exists CHK_dates;

ALTER TABLE rentals
ADD CONSTRAINT CHK_dates CHECK (start_date <= end_date);

INSERT INTO rentals (price, start_date, end_date, rentee_id, license_plate, employee_id) VALUES (1300, '2019-02-10', '2019-01-08', (SELECT rentee_id FROM rentees LIMIT 1), (SELECT license_plate FROM trucks LIMIT 1), (SELECT employee_id FROM salesmen LIMIT 1));

-- Validates license plates
ALTER TABLE trucks
DROP CONSTRAINT if exists CHK_license_plate;

ALTER TABLE trucks
ADD CONSTRAINT CHK_license_plate CHECK (license_plate SIMILAR TO '[A-Z]{3}[0-9]{3}');

INSERT INTO trucks (license_plate, color, model_id) VALUES ('AAA11A', 'Yellow', (SELECT model_id FROM truckmodels LIMIT 1))
