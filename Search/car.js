window.onload = function() {
	$('like').onclick = function() {
		var ajax = new Ajax.Request("like.php", {
			method : "post",
			parameters : {
				VID : vid,
				Username: user
			},
			onSuccess: likesuccess,
			onFailure: likefail,
			onException: likefail
		});
	}
	$('own').onclick = function() {
		var ajax = new Ajax.Request("own.php", {
			method : "post",
			parameters : {
				VID : vid,
				Username: user 
			},
			onSuccess: ownsuccess,
			onFailure: ownfail,
			onException: ownfail
		});
	}
	$('favorite').onclick = function(){
		var ajax = new Ajax.Request("fav.php", {
			method: "post",
			parameters: {
				VID: vid,
				Username: user
			},
			onSuccess: favsuccess,
			onFailure: favfail,
			onException: favfail
		});
	}
}

function likesuccess(){
	if ($('likemes').firstChild){
		$('likemes').removeChild($('likemes').firstChild);
	}
	$('likemes').appendChild(document.createTextNode("like successful"));
}

function likefail(){
	if ($('likemes').firstChild){
		$('likemes').removeChild($('likemes').firstChild);
	}
	$('likemes').appendChild(document.createTextNode("like failed"));
}

function ownsuccess(){
	if ($('ownmes').firstChild){
		$('ownmes').removeChild($('ownmes').firstChild);
	}
	$('ownmes').appendChild(document.createTextNode("own successful"));
}

function ownfail(){
	if ($('ownmes').firstChild){
		$('ownmes').removeChild($('ownmes').firstChild);
	}
	$('ownmes').appendChild(document.createTextNode("own failed"));
}

function favsuccess(){
	if ($('favmes').firstChild){
		$('favmes').removeChild($('favmes').firstChild);
	}
	$('favmes').appendChild(document.createTextNode("favorite changed"));
}

function favfail(){
	if ($('favmes').firstChild){
		$('favmes').removeChild($('favmes').firstChild);
	}
	$('favmes').appendChild(document.createTextNode("favorite failed"));
}
