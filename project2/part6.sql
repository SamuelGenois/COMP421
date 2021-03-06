-- ########################################

-- ###### Create a truck appointment ######

-- ########################################

-- It will not pick a truck that is already rented during the period or had an appointment during the rent period
-- This variable contains all the trucks that can be rented
-- Here the desired renting period is from the '2019-01-14' to '2019-01-20'

WITH rentableTrucks AS

  (SELECT * FROM trucks t

    WHERE

      -- Ignore all trucks that have a repair appointment during the desired renting period

      (SELECT COUNT(*) FROM appointments WHERE license_plate = t.license_plate AND date >= '2019-01-14' AND date <= '2019-01-20')=0

    AND

      -- Ignore all trucks that already have a renting overlapping the desired period

      (SELECT COUNT(*) FROM rentals

        WHERE license_plate = t.license_plate

        AND (

          (start_date >= '2019-01-14' AND start_date <= '2019-01-20')

          OR (end_date >= '2019-01-14' AND end_date <= '2019-01-20')

          OR (start_date <= '2019-01-14' AND end_date >= '2019-01-20')))=0)

INSERT INTO rentals (price, start_date, end_date, rentee_id, license_plate, employee_id) VALUES (

  0, -- The price will be updated with distance

  '2019-01-14',

  '2019-01-20',

  (SELECT rentee_id FROM rentees ORDER BY random() LIMIT 1),

  -- Take a random truck from the rentable trucks

  (SELECT license_plate FROM rentableTrucks ORDER BY random() LIMIT 1),

  (SELECT employee_id FROM salesmen ORDER BY random() LIMIT 1)

);



-- ##############################################################################################

-- ###### Compute the price of a rental based on the distance computed from GPS datapoints ######

-- ##############################################################################################



-- Update all rentals

-- 0.15 is the price rate (could be different depending on other factors)

UPDATE rentals r SET price=0.15*

  -- Take half of the sum of the distance between the closest datapoints

  (SELECT SUM(dist)/2 FROM

    -- For every datapoint, find the closest datapoint in time (in the past) and compute their distance

    (SELECT position <->

      -- Get the closest datapoint in time by ordering by date

      (SELECT position FROM datapoints e WHERE e.rental_id=r.rental_id AND datetime < d.datetime ORDER BY datetime DESC LIMIT 1) AS dist

    -- Ignore the first day since there is no previous datapoint to compare to

    FROM datapoints d WHERE d.rental_id=r.rental_id ORDER BY datetime OFFSET 1) AS datapointDifferences);



-- #######################################################################

-- ###### Delete all maintenance that are happening during a rental ######

-- #######################################################################

-- It is useful when there are missing available trucks for rental and we need to force a rental on a truck that is supposed to be in maintenance

DELETE FROM repairs WHERE appointment_id in (SELECT appointment_id from appointments a WHERE (SELECT COUNT(*) FROM rentals WHERE a.date >= start_date AND a.date <= end_date)>0);

DELETE FROM appointments WHERE appointment_id in (SELECT appointment_id from appointments a WHERE (SELECT COUNT(*) FROM rentals WHERE a.date >= start_date AND a.date <= end_date)>0);



-- ######################################################################################

-- ###### Decrease the price of the rental if the fuel tank was not full initially ######

-- ######################################################################################

-- It is useful when there are missing available trucks for rental and we need to force a rental on a truck that is supposed to be in maintenance

UPDATE rentals r SET price = price - 60 * (1 - (SELECT fuel_level FROM datapoints WHERE rental_id = r.rental_id ORDER BY datetime LIMIT 1)) WHERE (SELECT COUNT(*) FROM datapoints WHERE rental_id = r.rental_id)>0;
