<?php session_start();
if ($_SERVER['REQUEST_METHOD'] == 'POST' && !isset($_SESSION['account'])) {
	$un = $_POST['username'];
	$ps = $_POST['password'];
	$db = new PDO("mysql:dbname=findacar;host=localhost", "retrieving", "retrieving");
	$un = $db -> quote($un);
	$ps = $db -> quote($ps);
	$rows = $db -> query("CALL Login($un, $ps)");
	if ($rows -> rowCount() > 0) {
		$account = $rows -> fetch();
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
		<link rel="stylesheet" type="text/css" href="car.css"/>
		<script src="../libraries/prototype.js" type="text/javascript"></script>
		<script src="car.js" type="text/javascript"></script>
	</head>
	<body>
		<div id="topBanner">
			<div class="homeIcon">
				<a href="../index.php">
				<img src="../Images/homeIcon.png" alt="home"  />
				</a>
			</div>
			<h1>Models</h1>
			<div class="homeIcon">
				<a href="../index.php">
				<img src="../Images/homeIcon.png" alt="home" />
				</a>
			</div>
		</div>
		<div id="mainBody">
			<?php
			if (isset($_GET['vid'])){
				$vid = $_GET['vid'];
				if(isset($un)){
					?>
					<script type="text/javascript">
					var user =  "<?=$un?>";
					var vid = <?=$vid?>;
					</script>
				<?php } else if(isset($_SESSION['account'])){
				$acc = $_SESSION['account'];
					?>
					<script type="text/javascript">
						var user =  "<?=$acc['username']?>";
						var vid = <?=$vid?>;
					</script>
				<?php }

						$db = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
						$manf = $db->quote($vid);
						$rows = $db->query("CALL getVehicle($vid)");
						foreach($rows as $row){
					?>
					<h1> <?php echo $row['Year'] . " " . $row['manf'] . " " . $row['Name'] . " " .$row['Trim']?> </h1>
					<h2> <span class="attr">MPG/fuel:</span> <?=$row['MPG']?> <?=$row['Fuel']?></h2>
					<h2> <span class="attr">Fuel capacity:</span> <?=$row['Fuel_Capacity']?></h2>
					<h2> <span class="attr">Body_Type:</span> <?=$row['Body_Type']?></h2>
					<h2> <span class="attr">Drivetrain:</span> <?=$row['Drivetrain']?></h2>
					<h2> <span class="attr">Engine Options:</span> 
						<?php $db2 = new PDO("mysql:dbname=findacar;host=localhost", "retrieving", "retrieving");
						$rows2 = $db2 -> query("CALL GetEngine($vid)");
						?><ul><?php
						foreach($rows2 as $row2){
							?>
							<li> <?=$row2['Name']?></li>
							<?php } ?>
						</ul>
						
					</h2>
					<h2> <span class="attr">Transmission Options: </span>
						<?php $db2 = new PDO("mysql:dbname=findacar;host=localhost", "retrieving", "retrieving");
						$rows2 = $db2 -> query("CALL GetTransmission($vid)");
						?><ul><?php
						foreach($rows2 as $row2){
							if($row2['Gears'] == "-1"){
								?>
							<li> <?php echo '&#8734; '?>-gear <?=$row2['Type']?></li>
							<?php
							} else{
							?>
							<li> <?=$row2['Gears']?>-speed <?=$row2['Type']?></li>
							<?php }
							}
						?>
						</ul>
						
					</h2>
					<h2> <span class="attr">Color Options:</span>
						<?php $db2 = new PDO("mysql:dbname=findacar;host=localhost", "retrieving", "retrieving");
						$rows2 = $db2 -> query("CALL GetColor($vid)");
						?><ul><?php
						foreach($rows2 as $row2){
							?>
							<li> <?=$row2['Color']?> (<?=$row2['Gen_Color']?>)</li>
							<?php } ?>						
						
					</h2>
					<h2> <span class="attr">Number of Seats:</span> <?=$row['Seats']?> </h2>
					<h2> <span class="attr">Door Count:</span> <?=$row['Door_Count']?></h2>
					<a href="review.php?vid=<?=$vid?>"><h2> READ REVIEWS</h2></a>
					<?php if(isset($un) || isset($_SESSION['account'])){?>
						<h2 style="display: inline-block;"><button id="like" style="display: inline;"> I like this car! </button> <p style="display: inline; color: green" id="likemes"></p></h2>
						<h2 style="display: inline-block;"><button id="own" style="display: inline;"> I own this car!</button> <p style="display: inline; color: green" id="ownmes"></p></h2>
						<h2 style="display: inline-block;"><button id="favorite" style="display: inline;"> This is my favorite car!</button> <p style="display: inline; color: green" id="favmes"></p></h2>
						<?php } else{ ?>
						<button id="like" style="display: none;"></button> 
						<button id="own" style="display: none;"></button> 
						<button id="favorite" style="display: none";></button>
						<p> Login or create an account to like this car! </p> <?php }

						}
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