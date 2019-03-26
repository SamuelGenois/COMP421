-- ##########################
-- ###### Re-used Data ######
-- ##########################
-- This data is used for insert across multiple tables

-- Generating a list of first names
-- Source: http://listofrandomnames.com/
CREATE TEMPORARY TABLE firstname(
  name varchar(10)
);
insert into firstname (name) VALUES
  ('Maxime'),
  ('Mathieu'),
  ('Maxence'),
  ('Samuel'),
  ('John'),
  ('Bob'),
  ('Rick'),
  ('Alice'),
  ('Gabriella'),
  ('Shin'),
  ('Hobert'),
  ('Eleonor'),
  ('Pablo'),
  ('Catrina'),
  ('Sharyn'),
  ('Bettyann'),
  ('Jenniffer'),
  ('Alverta'),
  ('Olimpia'),
  ('Arianna'),
  ('Willis'),
  ('Mariah'),
  ('Jeramy'),
  ('Colby'),
  ('Kristeen'),
  ('Rona'),
  ('Terresa'),
  ('Stefania'),
  ('Juliann')
;
-- Generating a list of last names
-- Source: http://listofrandomnames.com/
CREATE TEMPORARY TABLE lastname(
  name varchar(10)
);
insert into lastname (name) VALUES
  ('Plante'),
  ('Lapointe'),
  ('Frenette'),
  ('Genois'),
  ('Montgomery'),
  ('Todd'),
  ('Parker'),
  ('Wright'),
  ('Bradley'),
  ('Brady'),
  ('Ruppert'),
  ('Simmon'),
  ('Fryman'),
  ('Riding'),
  ('Coyle'),
  ('Ketcham'),
  ('Zale'),
  ('Kopec'),
  ('Eaddy'),
  ('Frew'),
  ('Marsden'),
  ('Ballantyne'),
  ('Perrin'),
  ('Baum'),
  ('Bran'),
  ('Hunkins'),
  ('Winford'),
  ('Gandara'),
  ('Fontana')
;


-- #####################
-- ###### Rentees ######
-- #####################
-- Generating a list of street names for the rentees
-- Stree names are comgin from https://www.fantasynamegenerators.com/street-names.php
CREATE TEMPORARY TABLE road(
  name varchar(30)
);
insert into road (name) VALUES
  ('Gem Street'),
  ('College Lane'),
  ('Prospect Route'),
  ('Trinity Lane'),
  ('Lower Lane'),
  ('Long Avenue'),
  ('Dawn Lane'),
  ('Judge Passage'),
  ('Snowflake Avenue'),
  ('Petal Lane'),
  ('Kings Avenue'),
  ('Fountain Street'),
  ('Cannon Boulevard'),
  ('Coastline Street'),
  ('Windmill Boulevard'),
  ('Ivory Lane'),
  ('Java Avenue'),
  ('Cottage Street'),
  ('Fletcher Avenue'),
  ('Bath Row'),
  ('Flax Lane'),
  ('Hart Avenue'),
  ('Coach Route'),
  ('Broad Boulevard'),
  ('Vale Way'),
  ('Little Passage'),
  ('Arcade Lane'),
  ('Harbor Way'),
  ('Ocean Lane'),
  ('Legend Passage'),
  ('Underwood Street'),
  ('Sun Avenue'),
  ('Elmwood Avenue'),
  ('Providence Way'),
  ('Nightingale Boulevard'),
  ('Auburn Passage'),
  ('Dew Avenue'),
  ('Justice Street'),
  ('Baker Way'),
  ('Meadow Way')
;

-- Loop inserting rentees
DO $$
  DECLARE
    randomname varchar(100);
    randomaddress varchar(100);
  BEGIN
    FOR counter IN 1..200 LOOP
      -- Pick a first and last name at random
      randomname := CONCAT((SELECT name FROM firstname ORDER BY random() LIMIT 1), ' ', (SELECT name FROM lastname ORDER BY random() LIMIT 1));
      -- Pick a random street number and street name
      randomaddress := CONCAT(round(random() * 300 + 1), ' ', (SELECT name FROM road ORDER BY random() LIMIT 1));
      -- Put it all together in one rentee
      INSERT INTO Rentees (rentee_name, rentee_address) VALUES (randomname, randomaddress);
    END LOOP;
END$$;

-- #######################
-- ###### Employees ######
-- #######################
DO $$
  DECLARE
    randomname varchar(100);
  BEGIN
    FOR counter IN 1..20 LOOP
      -- Pick a first and last name at random
      randomname := CONCAT((SELECT name FROM firstname ORDER BY random() LIMIT 1), ' ', (SELECT name FROM lastname ORDER BY random() LIMIT 1));
      INSERT INTO employees (employee_name) VALUES (randomname);
    END LOOP;
END$$;

-- Insert half of the employees into the salesmen table
INSERT INTO salesmen
SELECT employee_id FROM employees LIMIT 10;

-- Insert all the employees that are not salesmen into the mechanics table
INSERT INTO mechanics
SELECT employee_id FROM employees EXCEPT (SELECT employee_id FROM salesmen) LIMIT 10;

-- Take half the mechanics and make them motor specialists
WITH halfMechanics AS (SELECT * FROM mechanics LIMIT 5)
UPDATE mechanics m SET specialization = 'Motors' FROM halfMechanics WHERE halfMechanics.employee_id = m.employee_id;

-- All the mechanics that are not motor specialist is a structure specialist
UPDATE mechanics SET specialization = 'Structure' WHERE specialization is NULL;

-- ##########################
-- ###### Truck Models ######
-- ##########################
INSERT INTO truckmodels (model_name, manufacturer) VALUES ('Full car transporter', 'Trucks & co.');
INSERT INTO truckmodels (model_name, manufacturer) VALUES ('Concrete mixer truck', 'Trucks & co.');
INSERT INTO truckmodels (model_name, manufacturer) VALUES ('Chiller truck', 'Trucks & co.');
INSERT INTO truckmodels (model_name, manufacturer) VALUES ('Mobile crane', 'Trucks & co.');
INSERT INTO truckmodels (model_name, manufacturer) VALUES ('Curtain side truck', 'Trucks & co.');
INSERT INTO truckmodels (model_name, manufacturer) VALUES ('Full car transporter', 'SuperTrucks');
INSERT INTO truckmodels (model_name, manufacturer) VALUES ('Concrete mixer truck', 'SuperTrucks');
INSERT INTO truckmodels (model_name, manufacturer) VALUES ('Curtain side truck', 'SuperTrucks');

-- ####################
-- ###### Trucks ######
-- ####################
-- All the possible colors of a truck
CREATE TEMPORARY TABLE colors(
  name varchar(15)
);
insert into colors (name) values ('White'), ('Yellow'), ('Orange'), ('Red'), ('Pink'), ('Purple'), ('Blue'), ('Green');

-- Create a bunch of hardcoded license plate to be used in other relationships
CREATE TEMPORARY TABLE plates(
  name varchar(6)
);
insert into plates (name) values ('HEV234'), ('GRY520'), ('GTL925'), ('QPC735'), ('LDY856'), ('APE510'), ('GND652'), ('HFB184');

-- Generate trucks by assigning them random colors and models
DO $$
  DECLARE
    random_license_plate VARCHAR(6);
    random_color VARCHAR(15);
    random_model INT;
  BEGIN
    FOR counter IN 1..3 LOOP
      -- Choose a plate
      random_license_plate := (SELECT name FROM plates EXCEPT (SELECT license_plate FROM trucks) LIMIT 1);
      -- Choose a color
      random_color := (SELECT name FROM colors ORDER BY random() LIMIT 1);
      -- Choose a model
      random_model := (SELECT model_id FROM truckmodels ORDER BY random() LIMIT 1);
      -- Create a truck
      INSERT INTO trucks VALUES (random_license_plate, random_color, random_model);
    END LOOP;
END$$;

-- ########################
-- ###### Datapoints ######
-- ########################
INSERT INTO datapoints VALUES ('2019-01-03', point(4551, -7358), 0.8, 1);
INSERT INTO datapoints VALUES ('2019-01-04', point(4370, -7941), 0.7, 1);
INSERT INTO datapoints VALUES ('2019-01-05', point(4370, -7358), 0.65, 1);
INSERT INTO datapoints VALUES ('2019-01-06', point(4551, -7358), 0.6, 1);
INSERT INTO datapoints VALUES ('2019-01-07', point(4683, -7125), 0.5, 1);
INSERT INTO datapoints VALUES ('2019-01-08', point(4560, -7135), 0.4, 1);
INSERT INTO datapoints VALUES ('2019-01-09', point(4440, -7376), 0.3, 1);
INSERT INTO datapoints VALUES ('2019-01-10', point(4230, -7333), 0.2, 1);
INSERT INTO datapoints VALUES ('2019-01-11', point(4370, -7938), 1, 1);
INSERT INTO datapoints VALUES ('2019-01-12', point(4540, -7320), 0.9, 1);
INSERT INTO datapoints VALUES ('2019-01-13', point(4551, -7358), 0.87, 1);

INSERT INTO datapoints VALUES ('2019-01-03', point(4551, -7358), 1, 2);
INSERT INTO datapoints VALUES ('2019-01-04', point(4370, -7941), 0.8, 2);
INSERT INTO datapoints VALUES ('2019-01-05', point(4551, -7358), 0.6, 2);

-- ##########################
-- ###### Repair Types ######
-- ##########################
INSERT INTO repairtypes VALUES ('Tire change', 'When the tires are used or winter tires need to be installed/removed.');
INSERT INTO repairtypes VALUES ('Oil change', '');
INSERT INTO repairtypes VALUES ('Inspection', 'General inspection of the truck');
INSERT INTO repairtypes VALUES ('Motor reparation', '');
INSERT INTO repairtypes VALUES ('Structure reparation', '');

-- ################################
-- ###### Repair Frequencies ######
-- ################################
INSERT INTO repairfrequency VALUES (300, 1, 'Oil change');
INSERT INTO repairfrequency VALUES (200, 2, 'Oil change');
INSERT INTO repairfrequency VALUES (200, 3, 'Oil change');
INSERT INTO repairfrequency VALUES (100, 4, 'Oil change');
INSERT INTO repairfrequency VALUES (500, 5, 'Oil change');
INSERT INTO repairfrequency VALUES (100, 6, 'Oil change');
INSERT INTO repairfrequency VALUES (200, 7, 'Oil change');
INSERT INTO repairfrequency VALUES (250, 8, 'Oil change');

INSERT INTO repairfrequency VALUES (440, 1, 'Tire change');
INSERT INTO repairfrequency VALUES (380, 2, 'Tire change');
INSERT INTO repairfrequency VALUES (340, 3, 'Tire change');
INSERT INTO repairfrequency VALUES (540, 4, 'Tire change');
INSERT INTO repairfrequency VALUES (440, 5, 'Tire change');
INSERT INTO repairfrequency VALUES (360, 6, 'Tire change');
INSERT INTO repairfrequency VALUES (620, 7, 'Tire change');
INSERT INTO repairfrequency VALUES (540, 8, 'Tire change');

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

--###########################
--######### Rentees #########
--###########################
SELECT * FROM Rentees LIMIT 10;
--#####################################
--######### Repair Frequenciy #########
--#####################################
SELECT * FROM repairfrequency LIMIT 10;
--#############################
--######### Employees #########
--#############################
SELECT * FROM employees LIMIT 10;
--############################
--######### Salesmen #########
--############################
SELECT * FROM salesmen LIMIT 10;
--#############################
--######### Mechanics #########
--#############################
SELECT * FROM mechanics LIMIT 10;
--################################
--######### Truck Models #########
--################################
SELECT * FROM truckmodels LIMIT 10;
--###########################
--######### Trucks ##########
--###########################
SELECT * FROM trucks LIMIT 10;
--###########################
--######### Rentals #########
--###########################
SELECT * FROM rentals LIMIT 10;
--################################
--######### Repair Types #########
--################################
SELECT * FROM repairtypes LIMIT 10;
--################################
--######### Appointments #########
--################################
SELECT * FROM appointments LIMIT 10;
--###########################
--######### Repair ##########
--###########################
SELECT * FROM repairs LIMIT 10;
