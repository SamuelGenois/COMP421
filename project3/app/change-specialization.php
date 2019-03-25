<?php
// Necessary includes
include 'config.php';
include 'helpers.php';

// Display errors for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// TODO check license plate validity

try {
  // Open database connection
  $db = new PDO('pgsql:host='.$CONFIG['database']['host'].';dbname='.$CONFIG['database']['db'],
  $CONFIG['database']['user'],
  $CONFIG['database']['password'],
  []);

  $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  foreach ($_POST as $employee_id => $specialization) {
    if (intval($employee_id) == 0) {
      continue;
    }
    update_mechanics_specialization($db, $employee_id, $specialization);
  }

} catch (PDOException $e) {
  fail_on_error("An SQL error occured: <strong>" . $e->getMessage() . "</strong>");
}

success('All changes were saved.');

// ###################
// ## SQL FUNCTIONS ##
// ###################

function update_mechanics_specialization($db, $employee_id, $specialization) {
  $sql = "UPDATE mechanics SET specialization=:specialization WHERE employee_id=:employee_id";

  $stmt = $db->prepare($sql);
  $data = [
    "employee_id" => $employee_id,
    "specialization" => $specialization,
  ];
  $stmt->execute($data);
}
