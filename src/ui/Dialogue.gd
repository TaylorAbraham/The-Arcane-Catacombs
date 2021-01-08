extends Node2D

signal dialogue_advanced(option)

var animating := false
var textQueue := []


func display(text: String):
	animating = true
	$Textbox.show()
	for ch in text:
		textQueue.append(ch)
	if !textQueue.empty():
		$Textbox/Label.text = textQueue.pop_front()
		$Textbox/Timer.start()


func close():
	$Textbox.hide()


func _on_Timer_timeout():
	var ch: String = " "
	while !textQueue.empty() and ch == " ":
		ch = textQueue.pop_front()
		$Textbox/Label.text += ch
	if !textQueue.empty():
		if ch == "." or ch == "!" or ch == "?":
			$Textbox/Timer.wait_time = 0.4
		else:
			$Textbox/Timer.wait_time = 0.03
		$Textbox/Timer.start()
	else:
		animating = false
