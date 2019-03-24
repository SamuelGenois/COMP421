<?php
// Necessary includes
include 'config.php';
include 'helpers.php';

// Display errors for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// TODO check license plate validity

// Check the input data integrity
if (!isset($_POST['date'])) {
  fail_on_error('Missing appointment date.');
}
if (!isset($_POST['license_plate'])) {
  fail_on_error('Missing the license plate');
}
if (!isset($_POST['employee_id'])) {
  fail_on_error('Missing the employee id');
}
if (!isset($_POST['cost'])) {
  fail_on_error('Missing the cost');
}
if (!isset($_POST['repair_name'])) {
  fail_on_error('Missing the repair name');
}
if (!strtotime($_POST['date'])) {
  fail_on_error('Invalid date.');
}
if (intval($_POST['employee_id']) == 0) {
  fail_on_error('The employee id is not a valid int');
}

$date = $_POST['date'];
$license_plate = $_POST['license_plate'];
$employee_id = $_POST['employee_id'];
$cost = $_POST['cost'];
$repair_name = $_POST['repair_name'];

try {
  // Open database connection
  $db = new PDO('pgsql:host='.$CONFIG['database']['host'].';dbname='.$CONFIG['database']['db'],
  $CONFIG['database']['user'],
  $CONFIG['database']['password'],
  []);

  $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  $employees = try_find_employee($db, $employee_id);
  if (empty($employees)) { 
    fail_on_error('Employee does not exist');
  }

  $repair = try_find_repair_type($db, $repair_name);
  if (empty($repair)) { 
    fail_on_error('Repair type does not exist');
  }

  // Create an appointment
  $appointment = make_appointment($db, $date, $license_plate, $employee_id);

  //TODO check appointment successfully created
  if (!$appointment) {
    fail_on_error('Could not create appointment');
  }

  schedule_maintenance($db, $cost, $appointment['appointment_id'], $repair_name);

} catch (PDOException $e) {
  fail_on_error("An SQL error occured: <strong>" . $e->getMessage() . "</strong>");
}

success('A new maintenance appointment was schduled on date '.$date);

// ###################
// ## SQL FUNCTIONS ##
// ###################

function schedule_maintenance($db, $cost, $appointment_id, $repair_name) {
  $sql = "
    INSERT INTO repairs (cost, appointment_id, repair_name) VALUES (
      :cost,
      :appointment_id,
      :repair_name
    );";

  $stmt = $db->prepare($sql);
  $data = [
    'cost' => $cost,
    'appointment_id' => $appointment_id,
    'repair_name' => $repair_name,
  ];

  $stmt->execute($data);
}

function make_appointment($db, $date, $license_plate, $employee_id) {
  $sql = "
    INSERT INTO appointments (date, license_plate, $employee_id) VALUES (
      :date,
      :license_plate,
      :employee_id
    );";

  $stmt = $db->prepare($sql);
  $data = [
    'date' => $date,
    'license_plate' => $license_plate,
    'employee_id' => $employee_id,
  ];

  $stmt->execute($data);

  return $stmt->fetch();
}

function try_find_employee($db, $employee_id) {
  $sql = "
    SELECT * FROM employees WHERE employee_id = '".$employee_id."'
  ;";

  $stmt = $db->prepare($sql);
  $stmt->execute();

  return $stmt->fetch();
}

function try_find_repair_type($db, $repair_name) {
  $sql = "
    SELECT * FROM repairtypes WHERE repair_name = '".$repair_name."'
  ;";

  $stmt = $db->prepare($sql);
  $stmt->execute();

  return $stmt->fetch();
}
