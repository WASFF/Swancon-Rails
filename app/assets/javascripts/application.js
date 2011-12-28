// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs

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

function show(id) {
	$("#" + id).show();
}

function hide(id) {
	$("#" + id).hide();
}

$().ready(function() {
	$(".hidden").hide();
});