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
		<meta charset="UTF-8"></meta>
		<link rel="stylesheet" type="text/css" href="index.css"/>
	</head>
	<body style="background-image:url('Images/car.jpg');">
		<div id="topBanner">
			<h1>Welcome to Find A Car</h1>
			<div id="under">
				<p>A way to find if a car exists</p>
			</div>
		</div>
		<div id="rightsideBanner">
			<?php
			if (isset($_SESSION['account'])){
				$account = $_SESSION['account'];
				?>
						<div>
							<h1> Welcome <?php echo $account['name']  ?>!</h1>
							<a href="user/user.php"> View your profile </a>
							<a href="logout.php"> Logout </a>
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
				<a class="formstuff" href="register/register.php">don't have an account? register here</a><br>
				<input class="formstuff" type="submit" value="Login" name="submit">
			</form>
			
			<?php 
			}
			?>
		</div>
		<div id="leftsideBanner">
			<h4 id="topLine">Menu</h4>
			<div id="subSection">
				<!-- <input id="searchCar" value="Search for a car"/> -->
				<a href="Search/search.php">
					<p>Search for a Car</p>
					<div id="carSearch" class="searchObjects"></div>
				</a>
				<a href="manufacturers/manufacturers.php">
					<p>Manufacturers</p>
					<div id="manList" class="searchObjects"></div>
				</a>
				<!-- <a href="models/models.php">
					<p>Models</p>
					<div id="carList" class="searchObjects"></div>
				</a>
				<p>Testing more stuff</p> -->
			</div>
		</div>
	</body>
	<marquee direction="up"><font color="#00FFF0">Use it Well!</font></marquee>
	<marquee><font color="#FFFFFF">Best Page For Cars</font></marquee>
	 <marquee behavior="alternate"><font color="#FFFFFF">!!!! Welcome to the real world of cars !!!!</font> </marquee>
	</html>