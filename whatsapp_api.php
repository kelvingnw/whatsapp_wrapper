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
$priority = $_POST['priority'] ?? '100';

/* Connect using SQL Server Authentication. */
$conn = sqlsrv_connect($serverName, $connectionInfo);
if ($conn === false) {
    die(print_r(sqlsrv_errors(), true));
}
$tsql = "SELECT token FROM app_list WHERE node_type='whatsapp' AND app_type=?";

/* Execute the query. */

$stmt = sqlsrv_query($conn, $tsql, [$app_type]);
while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_NUMERIC)) {
    $hash = $row[0];
}

sqlsrv_free_stmt($stmt);


if (password_verify($token, $hash)) {
    if (isset($_FILES['attachment']['tmp_name'])) {
        $file = $_FILES['attachment']['tmp_name'];
        $filename = $_FILES['attachment']['name'];
        $folder = "./uploads/";
        move_uploaded_file($file, $folder . $filename);
        $handle = $folder . $filename;
        echo $handle . '<br>';
        $attachment_filename = $_POST['attachment_filename'] ?? $filename;
        $attachment = $handle;
        $attachment_location = 'local';
    }
    $usql = "INSERT INTO whatsapp_js (phone_number, message, attachment, attachment_type, attachment_location, attachment_filename, schedule_date, source_program, sender_refid, sender_notes, receiver_refid, receiver_notes, status, priority) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ? ,? ,? ,?,? ,?)";
    $uvar = array($phone_number, $message, $attachment, $attachment_type, $attachment_location, $attachment_filename, $schedule_date, $app_type, $sender_refid, $sender_notes, $receiver_refid, $receiver_notes, 0, $priority);

    if (!sqlsrv_query($conn, $usql, $uvar)) {
        echo ('Error: ' . sqlsrv_errors());
    } else echo "1 record added";
} else {
    echo 'Invalid Token.';
}


/* Free statement and connection resources. */
sqlsrv_close($conn);

// echo var_dump($result) . '--------------------' . $handle . ' - - - - ' . $id;
