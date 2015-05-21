<?php
session_start();
$vid = $_POST['VID'];
$un = $_POST['Username'];
$db = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
$rows = $db->query("CALL favcar($vid, '$un')");
$_SESSION['account']['favvid'] = $vid;
?>
