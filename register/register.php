<!DOCTYPE html>
<html>
	<head>
		<title>Find A Car</title>
		<meta charset="UTF-8">
		</meta>
		<link rel="stylesheet" type="text/css" href="register.css"/>
	</head>
	<body>

		<?php
	if($_SERVER['REQUEST_METHOD'] == 'POST'){
		$db = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
		
		$errors = '';
		$username = $_POST["username"];

		if (empty($username)){
			$errors .= '<li> Username is required</li>';
		} else{
			$username = $db->quote($username);
			$rows = $db->query("Call check_username($username);");
			if ($rows->rowCount() > 0) $errors .= '<li> The Username ' . $username . ' already exists </li>';
			//echo $username;

		} 
		
		$name = $_POST["name"];
		if (empty($name)) $errors .= '<li> Name is required';
		$name = $db->quote($name);
		
		//echo $name;
		
		
		$email = $_POST["email"];
		if (empty($email)) $errors .= '<li> Email is required';
		$email = $db->quote($email);
		$db3 = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
		$rows2 = $db3->query("Call check_email($email);");
		if ($rows2->rowCount() > 0) $errors .= '<li> There is already an account with the email ' . $email .' already exists </li>';
		//echo $email;
		

		$password = $_POST["password"];
		if (empty($password)) $errors .= '<li> Password is required';
		$password = $db->quote($password);
		//echo $password;
		
		
		$confirm = $_POST['cpassword'];
		$confirm = $db->quote($confirm);
		if (strcmp($password, $confirm) != 0) $errors .= '<li> Passwords did not match </li>';
		//echo $confirm;
		
		if (!empty($errors)){
			?>
			<h1 style="color: red;"> There were the following errors with the registration </h1> <?php
			echo '<ul>' . $errors . '</ul>'
			?> </br> <a href="register.php"> click here to be redirected to the registration page</a><?php 
		} else {
			$db2 = new PDO("mysql:dbname=findacar;host=localhost","retrieving", "retrieving");
			$db2->query("CALL register($username, $name, $email, $password);");
			?>
			<h1>account created succesfully</h1>
			<p>
				you will now be redirected to the home page
			</p>
			<?php 
			header("refresh:2;url=../index.php");
		}
	} else {
		?>
		<h1>Register</h1>
		<form method="post" action="">
			Name:
			<input type="text" name="name">
			<br>
			Username:
			<input type="text" name="username">
			<br>
			Email:
			<input type="text" name="email">
			<br>
			Password:
			<input type="password" name="password">
			<br>
			Confirm Password:
			<input type="password" name="cpassword">
			<br>
			<input type="submit" name="submit">
		</form>

		<a href="../index.php"> go back to the homepage </a>
		<?php } ?>
	</body>
</html>