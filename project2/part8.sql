ALTER TABLE rentals
DROP CONSTRAINT if exists CHK_dates;

ALTER TABLE rentals
ADD CONSTRAINT CHK_dates CHECK (start_date <= end_date);

INSERT INTO rentals (price, start_date, end_date, rentee_id, license_plate, employee_id) VALUES (1300, '2019-02-10', '2019-01-08', (SELECT rentee_id FROM rentees LIMIT 1), (SELECT license_plate FROM trucks LIMIT 1), (SELECT employee_id FROM salesmen LIMIT 1));
