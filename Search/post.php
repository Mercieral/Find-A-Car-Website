<?php

$vid = $_POST['VID'];
$un = $_POST['Username'];
$text = $_POST['text'];
$rate = $_POST['rating'];
$db = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
$un = $db->quote($un);
$un = htmlspecialchars($un);
$text = $db->quote($text);
$text = htmlspecialchars($text);
$rows = $db->query("CALL writeReview($un, $vid, $rate, $text)");

?>