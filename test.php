<?php
require_once realpath(__DIR__ . '/vendor/autoload.php');

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$DB_NAME = $_ENV['DB_NAME'];
$DB_SERVER = $_ENV['DB_SERVER'];
$DB_ID = $_ENV['DB_ID'];
$DB_PASS = $_ENV['DB_PASS'];

echo $DB_SERVER;
echo '<br><br><br><br>';
echo $DB_NAME;
echo '<br><br><br><br>';
echo $DB_ID;
