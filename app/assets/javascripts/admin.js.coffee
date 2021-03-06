member_data = []
$table = null
searching = false
$gather_member_search_button = null
$gather_member_search_field = null
$gather_member_search_message = null

toggleVisibility = (block) ->
	if block.css("display") == "none"
		block.css("display", "block")
	else
		block.css("display", "none")

changeGatherMessage = (newmessage) ->
	if $gather_member_search_message.html().length > 0
		$gather_member_search_message.fadeOut ->
			$gather_member_search_message.html(newmessage)
			$gather_member_search_message.fadeIn()
	else
		$gather_member_search_message.html(newmessage)
		$gather_member_search_message.fadeIn()

setSearchButtonState = (newSearchingValue) ->
	if newSearchingValue
		$gather_member_search_button.attr("disabled", "true")
		$gather_member_search_button.html("Searching...")
	else 
		$gather_member_search_button.removeAttr("disabled")
		$gather_member_search_button.html("Search")
	searching = newSearchingValue

doGatherSearch = ->
	if searching
		console.log("Searching Already")
		return
	fields = { 
		name_search: $gather_member_search_field.val(),	
		authenticity_token: AUTH_TOKEN
	}

	if fields.name_search.length < 3
		changeGatherMessage("Too short!")
		return 

	setSearchButtonState(true)
	jQuery.ajax
		data: fields
		url: "/seller/select.json",
		type: "POST",
		dataType: "json",
		error: (jqxhr, textStatus, errorThrown) -> 
			changeGatherMessage("Error: #{errorThrown}")
			setSearchButtonState(false)
		, success: (data, textStatus, jqxhr) ->
			searching = false
			$table.find("tr.datarow").remove()
			if data.users.length > 0
				changeGatherMessage("#{data.users.length} results!")
				$table.fadeIn()
			else
				changeGatherMessage("No Results found!")
				$table.fadeOut()
				
			member_data = []
			jQuery.each(data.users, (innerindex, innervalue) ->
				member_data[innervalue.id] = innervalue
				elem = "<tr id='" + innervalue.id + "' class='datarow'>"				
				if innervalue["member_detail_attributes[name_badge]"] != undefined
					name = innervalue["member_detail_attributes[name_badge]"]
					elem += "<td>" + name + "</td>"
				else
					elem += "<td></td>"
				if innervalue["member_detail_attributes[name_first]"] != undefined
					name = innervalue["member_detail_attributes[name_first]"] + " " +
						innervalue["member_detail_attributes[name_last]"]
					elem += "<td>" + name + "</td>"
				else
					elem += "<td></td>"
				elem += "<td>" + innervalue.username + "</td>"
				elem += "<td>" + innervalue.email + "</td>"
				elem += "<td>"
				elem += "<button class='verify'>Verify Details</button>"
				if innervalue.tickets? and innervalue.tickets.length > 0
					elem += "<button class='tickets'>Show Ticket Details</button>"
				elem += "</td>"
				elem += "</tr>"
				$elem = $(elem)
				$elem.find("button.verify").click ->
					id = innervalue.id
					showMemberForm(member_data[id])
				$elem.find("button.tickets").click ->
					unless innervalue.showingTickets
						innervalue.showingTickets = true
						jQuery.each innervalue.tickets, (innerindex, ticketValue) ->
							ticketRow = "<tr class='ticket_for_#{innervalue.id}'><td colspan='3'>#{ticketValue.name}</td>"
							ticketRow += "<td>"
							ticketRow += "<button class='redeem'>Redeem Ticket</button>"
							ticketRow += "</td>"
							ticketRow += "</tr>"
							$ticketRow = $(ticketRow)
							$ticketRow.find("button.redeem").click ->
								redeem = confirm "You've definitely given this person their stuff?"
								if redeem
									$(this).attr("disabled", "true").html("Redeeming...")
									jQuery.ajax
										url: "/seller/redeem/#{ticketValue.id}"
										type: "POST"
										dataType: "json",
										error: (jqxhr, textStatus, errorThrown) -> 
											$(this).removeAttr("disabled").html("Redeem Ticket")
											console.log(errorThrown)
										, success: (data, textStatus, jqxhr) ->
											index = innervalue.tickets.indexOf(ticketValue)
											innervalue.tickets.splice(index, 1)
											if innervalue.tickets.length == 0
												$elem.find("button.tickets").remove()
											$ticketRow.fadeOut ->
												$ticketRow.remove()
							$elem.after($ticketRow)
					else
						innervalue.showingTickets = false
						$(".ticket_for_#{innervalue.id}").fadeOut ->
							$(this).remove()
				$elem.appendTo($table)
			)
			setSearchButtonState(false)

showMemberForm = (data) ->
	unless data?
		data = {
			email: ""
			"member_detail_attributes[address_1]": ""
			"member_detail_attributes[address_2]": ""
			"member_detail_attributes[address_3]": ""
			"member_detail_attributes[address_country]": ""
			"member_detail_attributes[address_postcode]": ""
			"member_detail_attributes[address_state]": ""
			"member_detail_attributes[disclaimer_signed]": false
			"member_detail_attributes[email_optin]": false
			"member_detail_attributes[name_badge]": ""
			"member_detail_attributes[name_first]": ""
			"member_detail_attributes[name_last]": ""
			"member_detail_attributes[phone]": ""
			username: ""
		}
	$("#member_create_form").fadeIn()
	$('html, body').animate({
        scrollTop: $("#member_create_form").offset().top
    }, 250);
	$("#member_create_form").find("#username").focus()
	jQuery.each data, (innerindex, innervalue) -> 
		field = $("[name='user[" + innerindex + "]']")
		if field.attr("type") == "checkbox"
			field.prop('checked', innervalue);
		else
			field.val(innervalue)
	$("button#member_create_form_submit").attr("disabled", true)

createMember = ->
	fields = {authenticity_token: AUTH_TOKEN}
	$("#member_create_form input").each ->
		if $(this).attr("type") == "checkbox"
			if $(this).is(':checked')
				fields[$(this).attr("name")] = "true"
			else
				fields[$(this).attr("name")] = "false"
		else
			fields[$(this).attr("name")] = $(this).val();
	$("#member_create_form_submit").attr("disabled", true);
	$("#member_created_message").html("Sending...");
	jQuery.ajax
		data: fields,
		url: "/seller/create.json",
		dataType: "json",
		type: "POST",
		error: (jqxhr, textStatus, errorThrown) -> 
			$("#member_created_message").html("An Error Occured...");
			result = jQuery.parseJSON(jqxhr.responseText)
			errors = "Errors - "
			jQuery.each(result.error, (index, value) -> 
				errors += "" + index + ": "
				jQuery.each(value, (innerindex, innervalue) ->
					errors += innervalue + ", "
				)
			)
			$("#member_created_message").html(errors);
		, success: -> 
			$("#member_created_message").html("Created!");
			$("#member_create_form").fadeOut()

validateMember = ->
	attrs = 
		"user[username]": 4
		"user[email]": 4
		"user[member_detail_attributes[address_postcode]]": 4
		"user[member_detail_attributes[address_state]]": 2
		"user[member_detail_attributes[address_country]]": 2
		"user[member_detail_attributes[name_first]]": 1
		"user[member_detail_attributes[address_1]]": 1
		"user[member_detail_attributes[address_3]]": 1
	enable = true
	$("#member_create_form input").each (index, item) ->
		if enable
			$item = $(item)
			attr = attrs[$item.attr("name")]
			if attr?
				enable = $item.val().length >= attr
				msgsrc = "span[name='" + $item.attr("name") + "_msg']"
				if enable
					$(msgsrc).html("")
					$item.css("background-color", "white")
				else if $item.val().length > 0
					$(msgsrc).html("Too Short!")
					$item.css("background-color", "red")

	if enable
		if $("#disclaimer_signed").is(":checked")
			$("button#member_create_form_submit").removeAttr("disabled")
			return
	$("button#member_create_form_submit").attr("disabled", "true")

jQuery ->
	$(".hideable").hide()
	$("button#member_create").click ->
		showMemberForm(null)
	$("#member_create_form input[type=text]").blur ->
		validateMember()

	$("#member_create_form input[type=checkbox]").change ->
		validateMember()

	$("#member_create_form_submit").click(createMember);
	$(".link li").each ->
		$(this).click ->
			block = $("div.hideable#" + $(this).attr("id"))
			toggleVisibility(block)

	$gather_member_search_button = $("#gather_member_search").click(doGatherSearch)
	$gather_member_search_field = $("[name='gather_member_search']").keypress (event) ->
		if event.keyCode == 13
			doGatherSearch()
	$gather_member_search_message = $("#gather_member_search_message")

	$table = $("#gather_member_search_results")
