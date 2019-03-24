<?php
// Necessary includes
include 'config.php';
include 'helpers.php';

// Display errors for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Check the input data integrity
if (!isset($_POST['mechanics'])) {
  fail_on_error('Missing mechanics id');
}
if (!isset($_POST['date'])) {
  fail_on_error('Missing date');
}
if (intval($_POST['mechanics']) == 0) {
  fail_on_error('The mechanics id is not a valid int');
}
if (!strtotime($_POST['date'])) {
  fail_on_error('The mechanics id is not a valid int');
}

$mechanics = $_POST['mechanics'];
$date = $_POST['date'];

// TODO: Check if the mechanics id exists

try {
  // Open database connection
  $db = new PDO('pgsql:host='.$CONFIG['database']['host'].';dbname='.$CONFIG['database']['db'],
  $CONFIG['database']['user'],
  $CONFIG['database']['password'],
  []);

  $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  var_dump(maintenances_to_move($db, $mechanics, $date));
  exit();
} catch (PDOException $e) {
  fail_on_error("An SQL error occured: <strong>" . $e->getMessage() . "</strong>");
}

success('A new rental was created from date '.$from_date.' to date '.$to_date);

// ###################
// ## SQL FUNCTIONS ##
// ###################

// This functions reuse a query made during part 2 of the project
function maintenances_to_move($db, $mechanics_id, $date) {
  $sql = "SELECT * FROM appointments WHERE employee_id=:employee_id AND date=:date";

  $stmt = $db->prepare($sql);
  $stmt->bindParam(':employee_id', $mechanics_id, PDO::PARAM_INT);
  $stmt->bindParam(':date', $date, PDO::PARAM_STR);
  $stmt->execute();
  return $stmt->fetchAll();
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
