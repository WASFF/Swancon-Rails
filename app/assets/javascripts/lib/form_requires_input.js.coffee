class ValueChecker
	constructor: (@$button) ->
		id = @$button.data("requires-value")
		@$linked = @$button.parent().find("##{id}")
		console.log(@$linked)
		@checkVal()
		@$linked.change =>
			@checkVal()

	checkVal: ->
		if @$linked.val()? && @$linked.val().length > 0
			@$button.removeAttr("disabled")
		else
			@$button.attr("disabled", "disabled")

$().ready ->
	$("input[type=submit]").each (index, item) ->
		$item = $(item)
		if $item.data("requires-value")?
			new ValueChecker($item)
