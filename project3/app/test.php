<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include 'config.php';

$db = new PDO('pgsql:host='.$CONFIG['database']['host'].';dbname='.$CONFIG['database']['db'],
              $CONFIG['database']['user'],
              $CONFIG['database']['password'],
              []);

$stmt = $db->prepare('SELECT * FROM truckmodels WHERE model_id>=:model_id');
$id = 1;
$stmt->bindParam(':model_id', $id, PDO::PARAM_INT);
$stmt->execute();

while($row = $stmt->fetchObject()){
  echo $row->model_name . '<br>';
}
