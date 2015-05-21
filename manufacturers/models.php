<?php
session_start();
if ($_SERVER['REQUEST_METHOD'] == 'POST' && !isset($_SESSION['account'])){
				$un = $_POST['username'];
				$ps = $_POST['password'];
				$db = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
				$un = $db->quote($un);
				$ps = $db->quote($ps);
				$rows = $db->query("CALL Login($un, $ps)");
				if($rows->rowCount() > 0){
					$account = $rows->fetch();
					session_destroy();
					session_regenerate_id(TRUE);
					session_start();
					$_SESSION['account'] = $account;
				}
}
?>
<!DOCTYPE html>
<html>
	<head>
		<title>Find A Car</title>
		<meta charset="UTF-8">
		</meta>
		<link rel="stylesheet" type="text/css" href="years.css"/>
	</head>
	<body>
		<div id="topBanner">
			<div class="homeIcon">
				<a href="../index.php">
				<img src="../Images/homeIcon.png" alt="home"  />
				</a>
			</div>
			<?php 
			if (isset($_GET['manf']) && isset($_GET['year']) && isset($_GET['model'])){
				?> <h1><?=$_GET['manf']?> <?=$_GET['year']?> <?=$_GET['model']?></h1><?php
				$manf = $_GET['manf'];
				$year = $_GET['year'];
				$model = $_GET['model'];
			} else {
				$manf = "";
				$year = 0;
				$model = "";
				?>
				<h1>ERROR: Manufacturer, year, or model not found</h1>
			<?php } ?>
			<div class="homeIcon">
				<a href="../index.php">
				<img src="../Images/homeIcon.png" alt="home" />
				</a>
			</div>
		</div>
		<div id="mainBody">
			<h2 style="font-style: underline;"> Available Trims </h2>
			<?php
			$db2 = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
			$manf2 = $db2->quote($manf);
			$model2 = $db2->quote($model);
			$rows = $db2->query("CALL getTrim($manf2, $year, $model2);");
			foreach($rows as $row){
				?> <a class="model" href="../Search/car.php?vid=<?=$row['VID']?>"> <?=$row['Trim']?></a>
				<?php
			}
			?>
		</div>
		<div id="rightSide">
			<div id="accountBanner">
				<?php
				if (isset($_SESSION['account'])){
					$account = $_SESSION['account'];
				?>
				<div>
					<h1> User: </h1>
					<h3><?php echo $account['name']  ?></h3>
					<a href="../user/user.php"> View your profile</a> 
					<div> </div>
					<a href="../logout.php"> Logout </a>
				</div>
				<?php
				} 
			else{
			?>
			
			<form method="post" action="">
				<div class="formstuff">
					Username: <input type="text" size="15" name="username">
				</div>
				<div class="formstuff">
					Password: <input type="password" size="15"name="password">
				</div>
				<a class="formstuff" href="../register/register.php">don't have an account? register here</a><br>
				<input class="formstuff" type="submit" value="Login" name="submit">
			</form>
			
			<?php 
			}
			?>
			</div>
		</div>
	</body>
</html>