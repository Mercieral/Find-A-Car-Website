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
		<link rel="stylesheet" type="text/css" href="search.css"/>
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
			<h3>Search Constraints</h3>
			<div id="search">
				<?php $db = new PDO("mysql:dbname=findacar;host=localhost", "retrieving", "retrieving"); ?>
				<form method="get" action="display.php">
					<div class="formInfo" class="row1">
						<p class="searchLabels">General Color(s):</p>
						<select name="color[]" size="5" multiple="multiple" >
							<?php $error = '';
							$result = $db -> query("Call retrieveValues('Gen_Color');");
							foreach ($result as $row) {
								if ($row["error"] != NULL) {
									echo "Error Occured";
									echo $row["error"];
								} else {
									echo '<option id=' . $row[0] . '> ' . $row[0] . '</option>';

								}
							}
							?>
						</select>
					</div>
					<div class="formInfo" class="row1">
						<p class="searchLabels">Manfacturer(s):</p>
						<select name="manf[]" size="5" multiple="multiple">
							<?php $result -> closeCursor();
							$result = $db -> query("Call retrieveValues('Name');");
							foreach ($result as $row) {
								if ($row["error"] != NULL) {
									echo "Error Occured";
									echo $row["error"];
								} else {
									echo '<option id=' . $row[0] . '> ' . $row[0] . '</option>';
								}
							}
							?>
						</select>
					</div>
					<div class="formInfo" class="row1">
						<p class="searchLabels">Fuel Type(s):</p>
						<select name="fuelTypes[]" size="5" multiple="multiple">
							<?php $result -> closeCursor();
							$result = $db -> query("Call retrieveValues('Fuel');");
							foreach ($result as $row) {
								if ($row["error"] != NULL) {
									echo "Unable to retrieve fuel";
									echo $row["error"];
								} else {
									echo '<option id=' . $row[0] . '> ' . $row[0] . '</option>';
								}
							}
							?>
						</select>
					</div>
					<div class="formInfo" class="row2">
						<p class="searchLabels">Gear(s):</p>
						<select name="gears[]" size="5" multiple="multiple">
							<?php $result -> closeCursor();
							$result = $db -> query("Call retrieveValues('Gears');");
							foreach ($result as $row) {
								if ($row[0] == "-1") {
									echo '<option id=' . $row[0] . ' value=' . $row[0] . '> &#8734 </option>';
								} else {
									echo '<option id=' . $row[0] . '  value=' . $row[0] . '> ' . $row[0] . '</option>';
								}
							}
							?>
						</select>
					</div>
					<div class="formInfo" class="row2" id="radioButton">
						<p class="searchLabels">Transmission(s):</p>
						<?php $result -> closeCursor();
							$result = $db -> query("Call retrieveValues('Type');");
							foreach ($result as $row) {
								echo '<input type="checkbox" name="transmission[]" value="' . $row[0] . '" />' . $row[0];
								echo '<br />';
							}
							?>
					</div>
					<input type="submit" value="Post"/>
				</form>
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