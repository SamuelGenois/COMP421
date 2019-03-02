-- #####################################
-- ###### Generate random rentees ######
-- #####################################
-- Generating a list of first names for the rentees
CREATE TEMPORARY TABLE firstname(
  name varchar(10)
);
insert into firstname (name) values ('Maxime'), ('Mathieu'), ('Maxence'), ('Samuel'), ('John'), ('Bob'), ('Rick'), ('Alice'), ('Gabriella');
-- Generating a list of last names for the rentees
CREATE TEMPORARY TABLE lastname(
  name varchar(10)
);
insert into lastname (name) values ('Plante'), ('Lapointe'), ('Frenette'), ('Genois'), ('Montgomery'), ('Todd'), ('Parker'), ('Wright'), ('Bradley');
-- Generating a list of street names for the rentees
CREATE TEMPORARY TABLE road(
  name varchar(30)
);
insert into road (name) values ('Liberty Lane'), ('Palm Way'), ('Hind Street'), ('Legend Route'), ('Castle Route'), ('Yew Avenue'), ('Duchess Lane'), ('Prince Way'), ('Cavern Avenue');

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
SELECT * FROM mechanics;
