<?php

// Connect to database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "synapsis";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Read data from request
$username = $_POST["username"];
$password = $_POST["password"];
$fullname = $_POST["fullname"];

// Create user in database
$sql = "INSERT INTO users (username, password, fullname) VALUES ('$username', '$password', '$fullname')";

if ($conn->query($sql) === TRUE) {
    $last_id = $conn->insert_id;
    $response = array("status" => 201, "message" => "User created successfully", "data" => array("id" => $last_id, "username" => $username, "fullname" => $fullname));
} else {
    $response = array("status" => 400, "message" => "Error creating user: " . $conn->error);
}

// Close connection
$conn->close();

// Send response
header('Content-Type: application/json');
echo json_encode($response);

?>
