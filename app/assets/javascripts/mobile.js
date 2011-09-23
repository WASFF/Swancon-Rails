//= require jquery
//= require jquery_ujs

function linkbarSlide() {
	var block = $("#linkbar");
	if (block.position().left > 2 ) {
		block.animate({"left": "-=160px"}, "fast", "swing", function() {
			$("#linkbar .close").html("&gt;&gt;");		
		});
	} else {
		block.animate({"left": "+=160px"}, "fast", "swing", function() {
			$("#linkbar .close").html("&lt;&lt;");
		});
	}
}

function loginbarSlide() {
	var block = $("#loginbar");
	if (block.position().left > 2 ) {
		block.animate({"left": "-=160px"}, "fast", "swing", function() {
			$("#loginbar .close").html("&gt;&gt;");		
		});
	} else {
		block.animate({"left": "+=160px"}, "fast", "swing", function() {
			$("#loginbar .close").html("&lt;&lt;");
		});
	}
}

$().ready(function() {
	$("#loginbar").bind("click", loginbarSlide);
	$("#linkbar").bind("click", linkbarSlide);
});