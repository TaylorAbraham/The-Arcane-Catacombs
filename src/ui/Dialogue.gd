extends Node2D

signal dialogue_progressed(option)

var active := false
var wasActiveLastFrame := false # This prevents the dialogue instantly closing when opened
var animating := false
var textQueue := []


func display(text: String):
	animating = true
	active = true
	$Textbox.show()
	for ch in text:
		textQueue.append(ch)
	if !textQueue.empty():
		$Textbox/Label.text = textQueue.pop_front()
		$Textbox/Timer.start()


func close():
	$Textbox.hide()


func _process(delta: float) -> void:
	if wasActiveLastFrame and Input.is_action_just_pressed("interact"):
		if animating:
			animating = false
			for ch in textQueue:
				$Textbox/Label.text += ch
			textQueue.clear()
		else:
			active = false
			emit_signal("dialogue_progressed", 0)
	wasActiveLastFrame = active


func _on_Timer_timeout():
	var ch: String = " "
	while !textQueue.empty() and ch == " ":
		ch = textQueue.pop_front()
		$Textbox/Label.text += ch
		$Textbox/SoundPlayer.play()
	if !textQueue.empty():
		if ch == "." or ch == "!" or ch == "?":
			$Textbox/Timer.wait_time = 0.4
		else:
			$Textbox/Timer.wait_time = 0.03
		$Textbox/Timer.start()
	else:
		animating = false
