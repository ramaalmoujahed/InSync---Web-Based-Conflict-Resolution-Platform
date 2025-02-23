<?php
// Database connection details
$serverName = "localhost"; // Your server name or IP address, e.g., "localhost" or "127.0.0.1"
$database = "SYNC"; // Your database name

// Use Windows Authentication
$connectionInfo = array(
    "Database" => $database,
    "TrustServerCertificate" => true,
    "CharacterSet" => "UTF-8",
    "Trusted_Connection" => "yes"
);

// Establishing the connection using SQLSRV driver
$conn = sqlsrv_connect($serverName, $connectionInfo);

// Check connection
if ($conn === false) {
    die(print_r(sqlsrv_errors(), true)); // Print any errors if the connection fails
}

echo "Connected successfully!";

