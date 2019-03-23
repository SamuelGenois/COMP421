<?php

function fail_on_error($msg) {
  header('location: index.php?error='.urlencode($msg));
  exit();
}

function success($msg) {
  header('location: index.php?success='.urlencode($msg));
  exit();
}
