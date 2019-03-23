<?php
// Necessary includes
include 'config.php';
include 'helpers.php';

// Display errors for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Check the input data integrity
if (!isset($_POST['from'])) {
  fail_on_error('Missing "from" date.');
}
if (!isset($_POST['to'])) {
  fail_on_error('Missing "to" date.');
}
if (!isset($_POST['rentee'])) {
  fail_on_error('Missing the rentee id.');
}
if (!isset($_POST['salesman'])) {
  fail_on_error('Missing the salesman id.');
}
if (!strtotime($_POST['from'])) {
  fail_on_error('Invalid "from" date.');
}
if (!strtotime($_POST['to'])) {
  fail_on_error('Invalid "to" date.');
}
if (intval($_POST['rentee']) == 0) {
  fail_on_error('The rentee id is not a valid int');
}
if (intval($_POST['salesman']) == 0) {
  fail_on_error('The salesman id is not a valid int');
}

$from_date = $_POST['from'];
$to_date = $_POST['to'];
$rentee_id = $_POST['rentee'];
$salesman_id = $_POST['salesman'];

// TODO: Check if the rentee and salesman id exists

try {
  // Open database connection
  $db = new PDO('pgsql:host='.$CONFIG['database']['host'].';dbname='.$CONFIG['database']['db'],
  $CONFIG['database']['user'],
  $CONFIG['database']['password'],
  []);

  $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  // Find an available truck
  $available_truck = get_one_available_truck($db, $from_date, $to_date);
  // Display an error if there is no truck available for the given dates
  if (!$available_truck) {
  fail_on_error('No truck is available on that date');
  }

  rent_truck($db, $available_truck['license_plate'], $from_date, $to_date, $rentee_id, $salesman_id);
} catch (PDOException $e) {
  fail_on_error("An SQL error occured: <strong>" . $e->getMessage() . "</strong>");
}

// ###################
// ## SQL FUNCTIONS ##
// ###################

// This functions reuse a query made during part 2 of the project
function rent_truck($db, $license_plate, $from_date, $to_date, $rentee_id, $employee_id) {
  $sql = "
    INSERT INTO rentals (price, start_date, end_date, rentee_id, license_plate, employee_id) VALUES (
    0, -- The price will be updated with distance
     :from_date,
     :to_date,
     :rentee_id,
     :license_plate,
     :employee_id
    );";

  $stmt = $db->prepare($sql);
  $data = [
    'from_date' => $from_date,
    'to_date' => $to_date,
    'license_plate' => $license_plate,
    'rentee_id' => $rentee_id,
    'employee_id' => $employee_id,
  ];
  $stmt->execute($data);
}

// Returns one object representing one available truck
// If there are not available truck, the method returns NULL
// This functions reuse a query made during part 2 of the project
function get_one_available_truck($db, $from_date, $to_date) {
  $sql = "
    SELECT * FROM trucks t
    WHERE
      -- Ignore all trucks that have a repair appointment during the desired renting period
      (SELECT COUNT(*) FROM appointments WHERE license_plate = t.license_plate AND date >= :from_date AND date <= :to_date)=0
    AND
      -- Ignore all trucks that already have a renting overlapping the desired period
      (SELECT COUNT(*) FROM rentals
        WHERE license_plate = t.license_plate
        AND (
          (start_date >= :from_date AND start_date <= :to_date)
          OR (end_date >= :from_date AND end_date <= :to_date)
          OR (start_date <= :from_date AND end_date >= :to_date)))=0";

  $stmt = $db->prepare($sql);
  $stmt->bindParam(':from_date', $from_date, PDO::PARAM_STR);
  $stmt->bindParam(':to_date', $to_date, PDO::PARAM_STR);
  $stmt->execute();

  return $stmt->fetch();
}
