jQuery ->
	$("body").on('click', '.remote_click_fadeout', -> 
		fadeid = $(this).data("fade-id");
		$(fadeid).fadeOut();
	)
	$("body").on('ajax:beforeSend', '.remote_send_fadeout', -> 
		fadeid = $(this).data("fade-id");
		$(fadeid).fadeOut();
	)
