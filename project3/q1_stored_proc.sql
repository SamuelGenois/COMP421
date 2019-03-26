-- Alter the structure of the database to add a distance field. This should only be run once in a real-life scenario.
ALTER TABLE rentals
DROP COLUMN cost;

ALTER TABLE rentals
ADD cost FLOAT;

-- Create the stored proc. This should only be run once in a real-life scenario.
CREATE OR REPLACE FUNCTION compute_cost(fuel_cost FLOAT, distance_cost FLOAT) RETURNS void AS $$
DECLARE
    total_distance FLOAT;
    initial_fuel FLOAT;
    final_fuel FLOAT;
    fuel_loss FLOAT;
    total_cost FLOAT;
    rec_rental RECORD;
    cur_rentals CURSOR
        FOR SELECT * FROM rentals;
BEGIN
    -- Open the cursor
    OPEN cur_rentals;
 
    LOOP
        FETCH cur_rentals INTO rec_rental;
        EXIT WHEN NOT FOUND;
    
        total_cost := 0;

        -- Calculate total cost
        total_distance := (
            SELECT SUM(delta_distance)
            FROM (
                SELECT (position <-> lag(position, 1, position) OVER (ORDER BY datetime)) delta_distance
                FROM datapoints
                WHERE rental_id = rec_rental.rental_id
            ) DD
        );

        initial_fuel := (
            SELECT fuel_level
            FROM datapoints
            WHERE rental_id = rec_rental.rental_id
            ORDER BY datetime ASC
            LIMIT 1
        );

        final_fuel := (
            SELECT fuel_level
            FROM datapoints
            WHERE rental_id = rec_rental.rental_id
            ORDER BY datetime DESC
            LIMIT 1
        );

        IF final_fuel < initial_fuel THEN
            fuel_loss = final_fuel - initial_fuel;
        ELSE
            fuel_loss := 0;
        END IF;
        
        total_cost := fuel_cost * fuel_loss + distance_cost * total_distance;

        
        -- Update the rentals table
        UPDATE rentals 
        SET cost = total_cost
        WHERE CURRENT OF cur_rentals;
    END LOOP;
  
    -- Close the cursor
    CLOSE cur_rentals;
END;
$$ LANGUAGE plpgsql;

-- Query distances. The distances are all NULL.
SELECT rental_id, price, cost from rentals;

-- Run the stored proc
SELECT compute_cost(7, 0.07);

-- Query distances again. They have been populated !
SELECT rental_id, price, cost from rentals;
