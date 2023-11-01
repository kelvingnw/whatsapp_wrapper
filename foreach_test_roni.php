<?php
session_start();
date_default_timezone_set('Asia/Jakarta');

require_once realpath(__DIR__ . '/vendor/autoload.php');

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$DB_NAME = $_ENV['DB_NAME'];
$DB_SERVER = $_ENV['DB_SERVER'];
$DB_ID = $_ENV['DB_ID'];
$DB_PASS = $_ENV['DB_PASS'];

$serverName = $DB_SERVER;
$uid = $DB_ID;
$pwd = $DB_PASS;
$databaseName = $DB_NAME;

$connectionInfo = array(
    "UID" => $uid,
    "PWD" => $pwd,
    "Database" => $databaseName,
    "TrustServerCertificate" => true
);

$handle = $hash = '';

$token = $_POST['token'] ?? '';
$app_type = $_POST['app_type'] ?? '';
$phone_number = $_POST['phone_number'] ?? '';
$message = $_POST['message'] ?? '';
$attachment = '';
$attachment_filename = '';
$attachment_location = '';
$attachment_type = $_POST['attachment_type'] ?? '';
$sender_refid = $_POST['sender_refid'] ?? '';
$sender_notes = $_POST['sender_notes'] ?? '';
$receiver_refid = $_POST['receiver_refid'] ?? '';
$receiver_notes = $_POST['receiver_notes'] ?? '';
$schedule_date = $_POST['schedule_date'] ?? date("Y-m-d H:i:s");


/* Connect using SQL Server Authentication. */
$conn = sqlsrv_connect($serverName, $connectionInfo);
if ($conn === false) {
    die(print_r(sqlsrv_errors(), true));
}

for ($i = 0; $i < 30; $i++) {
    $usql = "INSERT INTO whatsapp_js (phone_number, message, attachment, attachment_type, attachment_location, attachment_filename, schedule_date, source_program, sender_refid, sender_notes, receiver_refid, receiver_notes, status) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ? ,? ,? ,? ,?)";
    $uvar = array($phone_number, $i . ' Maaf Spam', $attachment, $attachment_type, $attachment_location, $attachment_filename, $schedule_date, $app_type, $sender_refid, $sender_notes, $receiver_refid, $receiver_notes, 0);

    if (!sqlsrv_query($conn, $usql, $uvar)) {
        echo ('Error: ' . sqlsrv_errors());
    } else echo "1 record added, number " . $i;
}



/* Free statement and connection resources. */
sqlsrv_close($conn);

// echo var_dump($result) . '--------------------' . $handle . ' - - - - ' . $id;
