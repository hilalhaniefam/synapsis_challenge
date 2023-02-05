<?php

// koneksi ke database
$host = "localhost";
$user = "user";
$password = "password";
$dbname = "synapsis";

$conn = mysqli_connect($host, $user, $password, $dbname);

// membuat fungsi untuk menambahkan tanggal dan waktu
function createDateTime($conn, $datetime) {
  $sql = "INSERT INTO datetime (datetime) VALUES ('$datetime')";
  if (mysqli_query($conn, $sql)) {
    return true;
  } else {
    return false;
  }
}

// membuat fungsi untuk mengambil semua tanggal dan waktu
function readDateTime($conn) {
  $sql = "SELECT * FROM datetime";
  $result = mysqli_query($conn, $sql);
  if (mysqli_num_rows($result) > 0) {
    return $result;
  } else {
    return false;
  }
}

// membuat fungsi untuk mengubah tanggal dan waktu
function updateDateTime($conn, $id, $datetime) {
  $sql = "UPDATE datetime SET datetime='$datetime' WHERE id=$id";
  if (mysqli_query($conn, $sql)) {
    return true;
  } else {
    return false;
  }
}

// membuat fungsi untuk menghapus tanggal dan waktu
function deleteDateTime($conn, $id) {
  $sql = "DELETE FROM datetime WHERE id=$id";
  if (mysqli_query($conn, $sql)) {
    return true;
  } else {
    return false;
  }
}

// menutup koneksi ke database
mysqli_close($conn);

