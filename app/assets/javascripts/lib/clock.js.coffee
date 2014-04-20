$countdown = null
end = null

renderCountdown = ->
	diff = end.diff(moment(), "seconds")
	unless diff > 0
		$countdown.html("Now!")
		location.reload()
		return
	days = Math.floor(diff / 86400)
	remainder = moment((diff % 86400) * 1000).utc()
	subtend = 0
	daytext = days + " days"
	hourtext = remainder.format("H") + " hours"
	minutetext = remainder.format("m") + " minutes"
	showand = true
	text = null
	if remainder.seconds() > 0
		text = remainder.format("s") + " seconds"
	else
		text = null

	if remainder.minute() > 0
		if text?
			showand = false
			text = minutetext + " and " + text
		else
			text = minutetext

	if remainder.hours() > 0
		if text?
			if showand
				showand = false
				text = hourtext + " and " + text
			else
				text = hourtext + ", " + text
		else
			text = hourtext

	if days > 0
		if text?
			if showand
				text = daytext + " and " + text
				showand = false
			else
				text = daytext + ", " + text
		else
			text = daytext

	text = "in " + text

	$countdown.html(text)
	setTimeout renderCountdown, 1000

$(document).ready -> 
	$(".countdown").each (index, item) ->
		$countdown = $(item)
		end = moment($countdown.data("time"), "YYYY-MM-DD HH:mm ZZ")
		renderCountdown()
