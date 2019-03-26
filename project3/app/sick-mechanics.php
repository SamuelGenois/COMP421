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

  $appointments = appointments_to_move($db, $mechanics, $date);

  $appointments_to_cancel = [];

  foreach ($appointments as $appointment) {
    $new_mechanic = free_mechanic($db, $date);
    if ($new_mechanic != NULL) {
      array_push($appointments_to_cancel, $appointment);
      continue;
    }
    change_appointment_mechanic($db, $appointment["appointment_id"], $new_mechanic["employee_id"]);
  }

  foreach ($appointments_to_cancel as $appointment_to_cancel) {
    cancel_appointment($db, $appointment_to_cancel["appointment_id"]);
  }

  $message = "Correctly rescheduled appointments ".property_array_to_string($appointments, "appointment_id");

  if (count($appointments_to_cancel) > 0) {
    $message .= "but had to cancel appointments "
    .property_array_to_string($appointments_to_cancel, "appointment_id")
    ." had to be canceled due to missing available mechanics";
  }

  success($message);
} catch (PDOException $e) {
  fail_on_error("An SQL error occured: <strong>" . $e->getMessage() . "</strong>");
}

success('A new rental was created from date '.$from_date.' to date '.$to_date);

// ###################
// ## SQL FUNCTIONS ##
// ###################

// This functions reuse a query made during part 2 of the project
function appointments_to_move($db, $mechanics_id, $date) {
  $sql = "SELECT * FROM appointments WHERE employee_id=:employee_id AND date=:date";

  $stmt = $db->prepare($sql);
  $stmt->bindParam(':employee_id', $mechanics_id, PDO::PARAM_INT);
  $stmt->bindParam(':date', $date, PDO::PARAM_STR);
  $stmt->execute();
  return $stmt->fetchAll();
}

// Returns a mechanics that has no appointment on that day (NULL is none)
function free_mechanic($db, $date) {
  $sql = "SELECT * FROM mechanics WHERE
    NOT EXISTS(
      SELECT * FROM appointments WHERE
        date=:date AND employee_id=mechanics.employee_id);";

  $stmt = $db->prepare($sql);
  $stmt->bindParam(':date', $date, PDO::PARAM_STR);
  $stmt->execute();
  return $stmt->fetch();
}

function change_appointment_mechanic($db, $appointment_id, $mechanics_id) {
  $sql = "UPDATE appointments SET employee_id=:mechanics_id WHERE appointment_id=:appointment_id";

  $stmt = $db->prepare($sql);
  $data = [
    "appointment_id" => $appointment_id,
    "mechanics_id" => $mechanics_id,
  ];
  $stmt->execute($data);
}

function cancel_appointment($db, $appointment_id) {
  $sql = "DELETE FROM appointments WHERE appointment_id=:appointment_id";

  $stmt = $db->prepare($sql);
  $data = [
    "appointment_id" => $appointment_id,
  ];
  $stmt->execute($data);
}
