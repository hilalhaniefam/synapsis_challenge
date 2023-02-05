<?php

// Connect to database
$servername = "localhost";
$dbusername = "root";
$dbpassword = "";
$dbname = "synapsis";

// Create connection
$conn = new mysqli($servername, $dbusername, $dbpassword, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Read data from request
$username = $_POST["username"];
$password = $_POST["password"];

// Query user from database
$sql = "SELECT * FROM users WHERE username='$username' AND password='$password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $response = array("status" => 200, "message" => "Login success", "data" => array("id" => $row["id"], "username" => $row["username"], "fullname" => $row["fullname"]));
} else {
    $response = array("status" => 400, "message" => "Login failed: invalid username or password");
}

// Close connection
$conn->close();

// Send response
header('Content-Type: application/json');
echo json_encode($response);

?>
