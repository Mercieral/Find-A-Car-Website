<?php
	if($_SERVER['REQUEST_METHOD'] == 'POST'){
		$db = new PDO("mysql:dbname=findacar;host=localhost","root", "ait3ooCo");
		
		$errors = '';
		$username = $_POST["username"];
		$username = $db->quote($username);
		$username = htmlspecialchars($username);
		if (empty($username)){
			$errors .= '<li> Username is required</li>';
		} else{
			
			$check_result = $username;
			$db->query("CALL check_username($check_result)");
			if (!empty($check_result)) $errors .= '<li> The Username ' +  $check_result + ' already exists </li>';
		} 
		
		$name = $_POST["name"];
		$name = $db->quote($name);
		if (empty($name)) $errors .= '<li> Name is required';
		
		
		$email = $_POST["email"];
		$email = $db->quote($email);
		if (empty($email)) $errors .= '<li> Email is required';
		

		$password = $_POST["password"];
		$password = $db->quote($password);
		if (empty($password)) $errors .= '<li> Password is required';
		
		
		$confirm = $_POST['cpassword'];
		$confirm = $db->quote($confirm);
		if (strcmp($password, $confirm) != 0) $errors .= '<li> Passwords did not match </li>';
		
		if (!empty($errors)){
			?> <h1 style="color: red;"> There were the following errors with the registration </h1> <?php
			echo '<ul>' . $errors . '</ul>'
			?> </br> <a href="register.php"> click here to be redirected to the registration page</a> <?php
		} else {
			$db->query("Call register($username, $name, $email, $password)");
			?> <h1>account created succesfully</h1>
			<p>you will now be redirected to the home page</p>
			<?php 
			//header("refresh:2;url=../index.php");
		}
	}
?>