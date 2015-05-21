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
		<link rel="stylesheet" type="text/css" href="review.css"/>
		<script src="../libraries/prototype.js" type="text/javascript"></script>
		<script src="review.js" type="text/javascript"></script>		
	</head>
	<body>
		<div id="topBanner">
			<div class="homeIcon">
				<a href="../index.php">
				<img src="../Images/homeIcon.png" alt="home"  />
				</a>
			</div>
			<?php 
			if (isset($_GET['vid'])){
				$vid = $_GET['vid'];
				$db = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
				$rows = $db->query("CALL getVehicle($vid);");
				foreach($rows as $row){
					?> <h1> Reviews for <?=$row['Year']?> <?=$row['manf']?> <?=$row['Name']?> </h1> <?php
				}
			}else{
				?> <h1> Review Page</h1> <?php
			}?>
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
				$db = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
				$rows = $db->query("CALL ReadReview($vid);");
				if (($rows->rowCount()) == 0 ){
					?>
					<h2> There are no reviews currently for this car </h2>
					<?php
				}
				foreach($rows as $row){
					?>
					<div class="review">
						<p> Username: <?=$row['Username']?></p>
						<p>Rating: <?=$row['Rating']?></p>
						<p style="display: inline"> Review: <?=$row['Description']?></p>
					</div>
					<?php
				}
				if (isset($_SESSION['account'])){
					$acc = $_SESSION['account'];
					?>
					<script type="text/javascript">
						var user = "<?=$acc['username']?>";
						var vid = "<?=$vid?>";
					</script>
					<fieldset>
						<legend>Write a review</legend>	
						<select id="rating" name="rating">
							<option value="0"> 0 </option>
							<option value="1"> 1 </option>
							<option value="2"> 2 </option>
							<option value="3"> 3 </option>
							<option value="4"> 4 </option>
							<option value="5"> 5 </option>
							<option value="6"> 6 </option>
							<option value="7"> 7 </option>
							<option value="8"> 8 </option>
							<option value="9"> 9 </option>
							<option value="10"> 10 </option>
							
								
						</select>
						<textarea id="textbox" name="text" cols="50" rows="10" maxlength="1000"></textarea>	
						<button id="button" type="submit" value="post" name="post"/> POST </button>				
					</fieldset>

					<?php
				} else{?>
					<button id="button" style="display: none;"/> POST </button>
					<?php	
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