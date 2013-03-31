member_data = []

toggleVisibility = (block) ->
	if block.css("display") == "none"
		block.css("display", "block")
	else
		block.css("display", "none")

doGatherSearch = ->
	fields = { 
		"name_search": $("[name='gather_member_search']").val(),
		authenticity_token: AUTH_TOKEN
	}
	jQuery.ajax
		data: fields
		url: "/seller/select.json",
		type: "POST",
		dataType: "json",
		error: (jqxhr, textStatus, errorThrown) -> 
			console.log("Error!")
		, success: (data, textStatus, jqxhr) ->
			table = $("#gather_member_search_results")
			table.find("tr.datarow").remove()
			member_data = []
			jQuery.each(data, (innerindex, innervalue) ->
				member_data[innervalue.id] = innervalue
				elem = "<tr id='" + innervalue.id + "' class='datarow'>"				
				if innervalue["member_detail_attributes[name_first]"] != undefined
					name = innervalue["member_detail_attributes[name_first]"] + " " +
						innervalue["member_detail_attributes[name_last]"]
					elem += "<td>" + name + "</td>"
				elem += "<td>" + innervalue.username + "</td>"
				elem += "<td>" + innervalue.email + "</td>"
				elem += "<td><button class='verify'>Verify Details</button></td>"
				elem += "</tr>"
				$(elem).appendTo(table)
			)
			$("button.verify").click ->
				id = $(this).parent().parent().attr("id")
				data = member_data[id]
				$("#member_create_form").css("display", "block")
				jQuery.each(data, (innerindex, innervalue) -> 
					field = $("[name='user[" + innerindex + "]']")
					if field.attr("type") == "checkbox"
						field.prop('checked', innervalue);
					else
						field.val(innervalue)
				)

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
			$("#member_create_form input[type='text']").each ->
				$(this).val("");
			$("#member_create_form input[type='hidden']").each ->
				$(this).val("0");
			$("button#member_create_form_submit").attr("disabled", true)

jQuery ->
	$("button#member_create").click ->
		toggleVisibility($("#member_create_form"))
	$("#member_create_form input").blur ->
		attrs = [
				"user[username]",
				"user[email]",
				"user[member_detail_attributes[address_postcode]]"
			]
		if attrs.indexOf($(this).attr("name")) != -1
			msgsrc = "span[name='" + $(this).attr("name") + "_msg']"
			if $(this).val().length < 4
				$(msgsrc).html("Too Short!")
				$(this).css("background-color", "red")
				$(this).focus();
				return
			else
				$(this).css("background-color", "white")
				$(msgsrc).html("")
				return

		attrs = [
			"user[member_detail_attributes[address_state]]",
			"user[member_detail_attributes[address_country]]"
		]
		if attrs.indexOf($(this).attr("name")) != -1
			msgsrc = "span[name='" + $(this).attr("name") + "_msg']"
			if $(this).val().length < 2
				$(msgsrc).html("Too Short!")
				$(this).css("background-color", "red")
				$(this).focus();
				return
			else
				$(this).css("background-color", "white")
				$(msgsrc).html("")
				if "user[member_detail_attributes[address_country]]" == $(this).attr("name")
					$("button#member_create_form_submit").removeAttr("disabled")
				return

		attrs = [
			"user[member_detail_attributes[name_first]]",
			"user[member_detail_attributes[address_1]]",
			"user[member_detail_attributes[address_3]]"
		]
		if attrs.indexOf($(this).attr("name")) != -1
			msgsrc = "span[name='" + $(this).attr("name") + "_msg']"
			if $(this).val().length < 1
				$(msgsrc).html("Too Short!")
				$(this).css("background-color", "red")
				$(this).focus();
				return
			else
				$(this).css("background-color", "white")
				$(msgsrc).html("")
				return

	$("#member_create_form_submit").click(createMember);
	$(".link li").each ->
		$(this).click ->
			block = $("div.hideable#" + $(this).attr("id"))
			toggleVisibility(block)

	$("#gather_member_search").click(doGatherSearch)

	$("[name='gather_member_search']").keypress (event) ->
		if event.keyCode == 13
			doGatherSearch()
