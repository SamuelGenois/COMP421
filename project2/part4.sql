-- ####################################
-- ###### Reused data generation ######
-- ####################################
-- This data is used for insert across multiple tables

-- Generating a list of first names
CREATE TEMPORARY TABLE firstname(
  name varchar(10)
);
insert into firstname (name) values ('Maxime'), ('Mathieu'), ('Maxence'), ('Samuel'), ('John'), ('Bob'), ('Rick'), ('Alice'), ('Gabriella');
-- Generating a list of last names
CREATE TEMPORARY TABLE lastname(
  name varchar(10)
);
insert into lastname (name) values ('Plante'), ('Lapointe'), ('Frenette'), ('Genois'), ('Montgomery'), ('Todd'), ('Parker'), ('Wright'), ('Bradley');


-- #####################################
-- ###### Generate random rentees ######
-- #####################################

-- Generating a list of street names for the rentees
CREATE TEMPORARY TABLE road(
  name varchar(30)
);
insert into road (name) values ('Liberty Lane'), ('Palm Way'), ('Hind Street'), ('Legend Route'), ('Castle Route'), ('Yew Avenue'), ('Duchess Lane'), ('Prince Way'), ('Cavern Avenue');

-- Loop inserting rentees
DO $$
  DECLARE
    randomname varchar(100);
    randomaddress varchar(100);
  BEGIN
    FOR counter IN 1..20 LOOP
      -- Pick a first and last name at random
      randomname := CONCAT((SELECT name FROM firstname ORDER BY random() LIMIT 1), ' ', (SELECT name FROM lastname ORDER BY random() LIMIT 1));
      -- Pick a random street number and street name
      randomaddress := CONCAT(round(random() * 300 + 1), ' ', (SELECT name FROM road ORDER BY random() LIMIT 1));
      -- Put it all together in one rentee
      INSERT INTO Rentees VALUES (random() * 100000, randomname, randomaddress);
    END LOOP;
END$$;
SELECT * FROM Rentees;

-- #######################################
-- ###### Generate random employees ######
-- #######################################
DO $$
  DECLARE
    randomname varchar(100);
  BEGIN
    FOR counter IN 1..20 LOOP
      -- Pick a first and last name at random
      randomname := CONCAT((SELECT name FROM firstname ORDER BY random() LIMIT 1), ' ', (SELECT name FROM lastname ORDER BY random() LIMIT 1));
      INSERT INTO employees VALUES (round(random() * 100000), randomname);
    END LOOP;
END$$;
SELECT * FROM employees;

-- Insert half of the employees into the salesmen table
INSERT INTO salesmen
SELECT employee_id FROM employees LIMIT 10;
SELECT * FROM salesmen;

-- Insert all the employees that are not salesmen into the mechanics table
INSERT INTO mechanics
SELECT employee_id FROM employees EXCEPT (SELECT employee_id FROM salesmen) LIMIT 10;

-- Take half the mechanics and make them motor specialists
WITH halfMechanics AS (SELECT * FROM mechanics LIMIT 5)
UPDATE mechanics m SET specialization = 'Motors' FROM halfMechanics WHERE halfMechanics.employee_id = m.employee_id;

-- All the mechanics that are not motor specialist is a structure specialist
UPDATE mechanics SET specialization = 'Structure' WHERE specialization is NULL;

SELECT * FROM mechanics;

-- ###################################
-- ###### Generate truck models ######
-- ###################################
INSERT INTO truckmodels VALUES (0, 'Full car transporter', 'Trucks & co.');
INSERT INTO truckmodels VALUES (1, 'Concrete mixer truck', 'Trucks & co.');
INSERT INTO truckmodels VALUES (2, 'Chiller truck', 'Trucks & co.');
INSERT INTO truckmodels VALUES (3, 'Mobile crane', 'Trucks & co.');
INSERT INTO truckmodels VALUES (4, 'Curtain side truck', 'Trucks & co.');
INSERT INTO truckmodels VALUES (5, 'Full car transporter', 'SuperTrucks');
INSERT INTO truckmodels VALUES (6, 'Concrete mixer truck', 'SuperTrucks');
INSERT INTO truckmodels VALUES (7, 'Curtain side truck', 'SuperTrucks');

SELECT * FROM truckmodels;

-- #############################
-- ###### Generate trucks ######
-- #############################
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
    FOR counter IN 1..8 LOOP
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

SELECT * FROM trucks;
