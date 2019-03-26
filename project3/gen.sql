DELETE FROM repairs;
DELETE FROM datapoints;
DELETE FROM appointments;
DELETE FROM rentals;
DO $$
  DECLARE
    random_license_plate VARCHAR(6);
    random_employee_id INT;
    random_rentee_id INT;
    random_revenue INT;
    d DATE;
  BEGIN
    FOR c1 IN 0..354 LOOP
      d := DATE '2018-01-01' + c1 * INTERVAL '1 day';
      -- Create appointments and repairs
      FOR c2 IN 1..2 LOOP
        random_license_plate := (SELECT license_plate FROM trucks ORDER BY random() LIMIT 1);
        random_employee_id := (SELECT employee_id FROM mechanics ORDER BY random() LIMIT 1);
        random_revenue := floor(random()*(499))+1;
        INSERT INTO appointments VALUES (c1*2+c2, d, random_license_plate, random_employee_id);
        INSERT INTO repairs VALUES (random_revenue, c1*2+c2, 'Oil change');
      END LOOP;
      -- Create retals
      FOR c2 IN 1..2 LOOP
        random_license_plate := (SELECT license_plate FROM trucks ORDER BY random() LIMIT 1);
        random_employee_id := (SELECT employee_id FROM salesmen ORDER BY random() LIMIT 1);
        random_rentee_id := (SELECT employee_id FROM salesmen ORDER BY random() LIMIT 1);
        random_revenue := floor(random()*(399))+1;
        INSERT INTO rentals VALUES (c1*2+c2, random_revenue, d, d + INTERVAL '1 month', random_rentee_id, random_license_plate, random_employee_id);
      END LOOP;
      
    END LOOP;
  END $$
