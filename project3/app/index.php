<?php
include 'config.php';
include 'helpers.php';

$db = new PDO('pgsql:host='.$CONFIG['database']['host'].';dbname='.$CONFIG['database']['db'],
$CONFIG['database']['user'],
$CONFIG['database']['password'],
[]);

$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">

<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8">
  <title>Truck Renting Company Management System</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>

<body>
  <div class="container">
    <h1>Truck Renting Company Management System</h1>
    <p>Brought to you by:
      <ul>
        <li>FRENETTE, Maxence - 260 685 124
        <li>GENOIS, Samuel - 260 692 287
        <li>LAPOINTE, Mathieu - 260 685 906
        <li>PLANTE, Maxime - 260 685 695
      </ul>
    </p>
    <h2>Menu</h2>
    <?php
    if (isset($_GET['error'])) {
      echo '<div class="alert alert-danger" role="alert">Error: '.$_GET['error'].'</div>';
    }
    if (isset($_GET['success'])) {
      echo '<div class="alert alert-success" role="alert">Success: '.$_GET['success'].'</div>';
    }
    ?>
    <p><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#schedule-rental">Schedule a Rental</button></p>
    <p><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#schedule-maintenance">Schedule a Maintenance</button></p>
    <p><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#show-rentals">Show Rentals</button></p>
    <p><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#sick-mechanics">A Mechanic is Sick Today</button></p>
    <p><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#change-specialization">Change Mechanics Specialization</button></p>
    <div class="card">
      <div class="card-body">
        Proudly powered by PHP!
      </div>
    </div>
  </div>

  <div class="modal fade" id="schedule-rental" tabindex="-1" role="dialog" aria-labelledby="schedule-rental-label" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="schedule-rental-label">Schedule a Rental</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <form role="form" method="post" action="schedule-rental.php">
            <div class="form-group">
              <label for="from" class="control-label">From</label>
              <input name="from" type="date" class="form-control" id="from">
            </div>
            <div class="form-group">
              <label for="to" class="control-label">To</label>
              <input name="to" type="date" class="form-control" id="to">
            </div>
            <div class="form-group">
              <label for="rentee" class="control-label">Rentee Id</label>
              <input name="rentee" type="text" class="form-control" id="rentee">
            </div>
            <div class="form-group">
              <label for="salesman" class="control-label">Salesman Id</label>
              <input name="salesman" type="text" class="form-control" id="salesman">
            </div>
            <button type="submit" class="btn btn-primary mb-2">Submit</button>
          </form>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="schedule-maintenance" tabindex="-1" role="dialog" aria-labelledby="schedule-maintenance-label" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="schedule-maintenance-label">Schedule a Maintenance</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <form role="form" method="post" action="schedule-maintenance.php">
            <div class="form-group">
              <label for="date" class="control-label">date</label>
              <input name="date" type="date" class="form-control" id="date">
            </div>
            <div class="form-group">
              <label for="license_plate" class="control-label">License plate</label>
              <input name="license_plate" type="text" class="form-control" id="license_plate">
            </div>
            <div class="form-group">
              <label for="employee_id" class="control-label">Employee Id</label>
              <input name="employee_id" type="text" class="form-control" id="employee_id">
            </div>
            <div class="form-group">
              <label for="cost" class="control-label">Cost</label>
              <input name="cost" type="text" class="form-control" id="cost">
            </div>
            <div class="form-group">
              <label for="repair_name" class="control-label">Repair type</label>
              <input name="repair_name" type="text" class="form-control" id="repair_name">
            </div>
            <button type="submit" class="btn btn-primary mb-2">Submit</button>
          </form>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="show-rentals" tabindex="-1" role="dialog" aria-labelledby="show-rentals-label" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="show-rentals-label">Show rentals</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <table class="table">
            <thead>
              <tr>
                <th scope="col">License Plate</th>
                <th scope="col">Start Date</th>
                <th scope="col">End Date</th>
              </tr>
            </thead>
            <tbody>
              <?php
                $sql = "SELECT * FROM rentals ORDER BY start_date;";

                $stmt = $db->prepare($sql);
                $stmt->execute();

                $appointments = $stmt->fetchAll();

                foreach ($appointments as $appointment) {
                  echo '<tr scope="row"><td>'.$appointment["license_plate"].'</td><td>'.$appointment["start_date"].'</td><td>'.$appointment["end_date"].'</td></tr>';
                }
              ?>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="change-specialization" tabindex="-1" role="dialog" aria-labelledby="change-specialization-label" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="change-specialization-label">Change Mechanics Specialization</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <form method="post" action="change-specialization.php">
            <table class="table">
              <thead>
                <tr>
                  <th scope="col">Employee Id</th>
                  <th scope="col">Specialization</th>
                </tr>
              </thead>
              <tbody>
                <?php
                  $sql = "SELECT * FROM mechanics ORDER BY employee_id;";

                  $stmt = $db->prepare($sql);
                  $stmt->execute();

                  $mechanics = $stmt->fetchAll();

                  foreach ($mechanics as $mechanic) {
                    echo '<tr scope="row"><td>'.$mechanic["employee_id"].'</td><td><input type="text"  class="form-control" name="'.$mechanic["employee_id"].'" value="'.$mechanic["specialization"].'"/></td></tr>';
                  }
                ?>
              </tbody>
            </table>
            <button type="submit" class="btn btn-primary mb-2">Save changes</button>
          </form>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="sick-mechanics" tabindex="-1" role="dialog" aria-labelledby="sick-mechanics-label" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="sick-mechanics-label">Schedule a Rental</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <form role="form" method="post" action="sick-mechanics.php">
            <div class="form-group">
              <label for="mechanics" class="control-label">Mechanics Id</label>
              <input name="mechanics" type="text" class="form-control" id="mechanics">
            </div>
            <div class="form-group">
              <label for="date" class="control-label">On Date</label>
              <input name="date" type="date" class="form-control" id="date">
            </div>
            <button type="submit" class="btn btn-primary mb-2">Submit</button>
            </form>
          </form>
        </div>
      </div>
    </div>
  </div>
</body>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</html>
