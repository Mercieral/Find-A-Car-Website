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
		<link rel="stylesheet" type="text/css" href="models.css"/>
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