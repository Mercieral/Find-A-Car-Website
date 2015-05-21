window.onload = function(){
	$('button').onclick = function(){
		var ajax = new Ajax.Request("post.php", {
			method : "post",
			parameters : {
				text : $('textbox').value,
				Username: user,
				VID: vid,
				rating: $('rating').options[$('rating').selectedIndex].value
			},
			onSuccess: postsuccess,
			onFailure: postfail,
			onException: postfail
		});
	}
}

function postsuccess(){
	alert("post successful!");
	location.reload();
}

function postfail(){
	alert('post failed');
}
