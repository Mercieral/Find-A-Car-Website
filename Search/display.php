<?php session_start();
if (isset($_POST['username']) && !isset($_SESSION['account'])) {
	$un = $_POST['username'];
	$db = new PDO("mysql:dbname=findacar;host=localhost", "retrieving", "retrieving");
	$un = $db -> quote($un);
	$rows = $db -> query("CALL Login($un, $ps)");
	if ($rows -> rowCount() > 0) {
		$account = $rows -> fetch();
		if ($account['password'] == $_POST['password']) {
			session_destroy();
			session_regenerate_id(TRUE);
			session_start();
			$_SESSION['account'] = $account;
		}
	}
}
?>
<!DOCTYPE html>
<html>
	<head>
		<title>Find A Car</title>
		<meta charset="UTF-8">
		</meta>
		<link rel="stylesheet" type="text/css" href="display.css"/>
	</head>
	<body>
		<div id="topBanner">
			<div class="homeIcon">
				<a href="../index.php">
				<img src="../Images/homeIcon.png" alt="home"  />
				</a>
			</div>
			<h1>Search For A Car</h1>
			<div class="homeIcon">
				<a href="../index.php">
				<img src="../Images/homeIcon.png" alt="home" />
				</a>
			</div>
		</div>
		<div id="mainBody">
			<h3>Your Results</h3>
			<div id="search">
				<?php $trans = $_GET["transmission"];
				$constant = '**';
				$constant2 = "'";
				$db = new PDO("mysql:dbname=findacar;host=localhost", "retrieving", "retrieving");
				$trans = $db -> quote($constant2 . implode("$constant", $trans) . $constant2);
				$gears = $_GET["gears"];
				#$gears = join(', ', $gears);
				$gears = $db -> quote($constant2 . implode("$constant", $gears) . $constant2);
				$manf = $_GET["manf"];
				#$manf = join(', ', $manf);
				$manf = $db -> quote($constant2 . implode("$constant", $manf) . $constant2);
				$colors = $_GET["color"];
				#$colors = join(', ', $colors);
				$colors = $db -> quote($constant2 . implode("$constant", $colors) . $constant2);
				$fuelType = $_GET["fuelTypes"];
				#$fuelType = join(', ', $fuelType);
				$fuelType = $db -> quote($constant2 . implode("$constant", $fuelType) . $constant2);
				#echo "Call SearchACar2($trans, $gears, $manf, $colors, $fuelType);";
				$results = $db -> query("Call SearchACar2($trans, $gears, $manf, $colors, $fuelType);");
					?>
					<div class= "resultDisplay">
						<?php if ($results->rowCount() == 0){ ?>
								<h2>No Available Results</h2>
								<h3>Try New Criteria</h3>
								<?php }
									else{
									foreach($results as $row){
									if($row["error"] != NULL){
									echo "Error in Database!";
									echo "<br/>";
									echo $row["error"];
									} else{
							?>
							<div class="cars"><a href="car.php?vid=<?=$row["VID"] ?>">
								<?php
								echo $row["year"] . " ";
								echo $row["manf"] . " ";
								echo $row["mod"] . " ";
								echo $row["trim"];
								?>
							</a>
							</div>
								
							<?php
							}
							}
							}
						?>
					</div>
					<?php ?>
				
				
				
				
			</div>
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
				<?php }
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