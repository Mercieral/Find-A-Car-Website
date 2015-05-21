<?php
$vid = $_POST['VID'];
$un = $_POST['Username'];
$db = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
$rows = $db->query("CALL own($vid, '$un')");
?>
