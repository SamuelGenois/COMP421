<?php

function fail_on_error($msg) {
  header('location: index.php?error='.urlencode($msg));
  exit();
}

function success($msg) {
  header('location: index.php?success='.urlencode($msg));
  exit();
}

function property_array_to_string($array, $property_name) {
  $output = "";
  foreach ($array as $element) {
    $output .= $element[$property_name];
  }
  return $output;
}
