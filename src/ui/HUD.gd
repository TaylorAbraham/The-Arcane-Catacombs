extends CanvasLayer

signal ability_ready

onready var Ab1 = $AbilityContainer/Ability1
onready var Ab1Timer = $AbilityContainer/Ability1/Timer
onready var Ab1Sweep = $AbilityContainer/Ability1/Sweep
onready var Ab1Value = $AbilityContainer/Ability1/MarginContainer/Value
onready var Ab2 = $AbilityContainer/Ability2
onready var Ab2Timer = $AbilityContainer/Ability2/Timer
onready var Ab2Sweep = $AbilityContainer/Ability2/Sweep
onready var Ab2Value = $AbilityContainer/Ability2/MarginContainer/Value
onready var Ab3 = $AbilityContainer/Ability3
onready var Ab3Timer = $AbilityContainer/Ability3/Timer
onready var Ab3Sweep = $AbilityContainer/Ability3/Sweep
onready var Ab3Value = $AbilityContainer/Ability3/MarginContainer/Value
onready var HpBar = $HealthContainer/HealthBar
onready var HpBarTrue = $HealthContainer/HealthBar/HealthBarTrue
onready var HpBarTween = $HealthContainer/HealthBar/Tween

export (Color) var healthyColor = Color.green
export (Color) var cautionColor = Color.yellow
export (Color) var dangerColor = Color.red
export (int, 0, 100) var cautionThreshold = 50
export (int, 0, 100) var dangerThreshold = 20

func _ready():
	Ab1Value.hide()
	Ab1Sweep.texture_progress = Ab1.texture
	Ab1Sweep.value = 0
	Ab2Value.hide()
	Ab2Sweep.texture_progress = Ab2.texture
	Ab2Sweep.value = 0
	Ab3Value.hide()
	Ab3Sweep.texture_progress = Ab3.texture
	Ab3Sweep.value = 0


func _process(delta):
	if(Ab1Timer.time_left > 0):
		Ab1Value.text = "%3.1f" % Ab1Timer.time_left
		Ab1Sweep.value = int(((Ab1Timer.time_left + 0.1)
				/ Ab1Timer.wait_time) * 100)
	if(Ab2Timer.time_left > 0):
		Ab2Value.text = "%3.1f" % Ab2Timer.time_left
		Ab2Sweep.value = int(((Ab2Timer.time_left + 0.1)
				/ Ab2Timer.wait_time) * 100)
	if(Ab3Timer.time_left > 0):
		Ab3Value.text = "%3.1f" % Ab3Timer.time_left
		Ab3Sweep.value = int(((Ab3Timer.time_left + 0.1)
				/ Ab3Timer.wait_time) * 100)


func display_text(text):
	$Dialogue.display(text)

func close_text():
	$Dialogue.close()


func _on_Player_health_changed(health: int, max_health: int) -> void:
	var new_value := float(health) / max_health * 100
	$HealthContainer/HealthBar/HealthBarTrue.value = new_value
	if new_value < 100:
		if new_value < dangerThreshold:
			HpBarTrue.tint_progress = dangerColor
		elif health < cautionThreshold:
			HpBarTrue.tint_progress = cautionColor
		else:
			HpBarTrue.tint_progress = healthyColor
		HpBarTween.interpolate_property(HpBar,
				'value', HpBar.value, new_value, 0.3, Tween.TRANS_LINEAR,
				Tween.EASE_IN_OUT)
		HpBarTween.start()
		$AnimationPlayer.play("healthbar_flash")
	else:
		$HealthContainer/HealthBar.value = new_value


func _on_GameManager_use_ability(i, ability):
	match(i):
		0:
			# The 0.1 is to make the ability come off of cooldown slightly earlier than the user expects
			Ab1Timer.wait_time = ability.cooldown - 0.1
			Ab1Timer.start()
			Ab1Value.show()
			Ab1.modulate = Color(0.5, 0.5, 0.5)
		1:
			Ab2Timer.wait_time = ability.cooldown - 0.1
			Ab2Timer.start()
			Ab2Value.show()
			Ab2.modulate = Color(0.5, 0.5, 0.5)
		2:
			Ab3Timer.wait_time = ability.cooldown - 0.1
			Ab3Timer.start()
			Ab3Value.show()
			Ab3.modulate = Color(0.5, 0.5, 0.5)


func _on_Timer1_timeout():
	Ab1Sweep.value = 0
	Ab1Value.hide()
	Ab1.modulate = Color(1, 1, 1)
	emit_signal("ability_ready", 0)


func _on_Timer2_timeout():
	Ab2Sweep.value = 0
	Ab2Value.hide()
	Ab2.modulate = Color(1, 1, 1)
	emit_signal("ability_ready", 1)


func _on_Timer3_timeout():
	Ab3Sweep.value = 0
	Ab3Value.hide()
	Ab3.modulate = Color(1, 1, 1)
	emit_signal("ability_ready", 2)
