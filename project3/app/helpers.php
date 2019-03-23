<?php

function fail_on_error($msg) {
  echo $msg;
  header('location: index.php?error='.urlencode($msg));
  exit();
}
