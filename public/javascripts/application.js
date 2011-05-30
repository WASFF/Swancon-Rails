// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function createCookie(name,value,days) {
	if (days)
	{
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++)
	{
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}

function styleLinkDisable() {
	var style = $(this).html();
	if (style != readCookie("style")) {
		$(this).fadeIn('fast');
	} else {
		$(this).fadeOut('fast');
	}
}

function styleChangeLink() {
	styleChange($(this).html());
}

function styleChange(style) {
	console.log("Changing to: " + style);
	createCookie("style", style), 365;
	$('link[@rel*=style][title]').each(
		function(i) {
			this.disabled = true;
			if (this.getAttribute('title') == style) {
				this.disabled = false;
			}
		}
	);
  $(".stylechange").each(styleLinkDisable);
}