extends CanvasLayer

func _on_Player_health_changed(health: int, max_health: int) -> void:
	var new_value := float(health) / max_health * 100
	if new_value < 100:
		$HealthContainer/HealthBar/Tween.interpolate_property($HealthContainer/HealthBar,
				'value', $HealthContainer/HealthBar.value, new_value, 0.1, Tween.TRANS_LINEAR,
				Tween.EASE_IN_OUT)
		$HealthContainer/HealthBar/Tween.start()
		$AnimationPlayer.play("healthbar_flash")
	else:
		$HealthContainer/HealthBar.value = new_value


func _on_DeckManager_deck_changed(deck: Array) -> void:
	pass # Replace with function body.


func _on_DeckManager_hand_changed(hand: Array) -> void:
	if hand.size() != 3:
		push_error("Hand is not 3 elements")
	if hand[0] != null:
		$CardContainer/Card1.texture = hand[0].sprite
	else:
		$CardContainer/Card1.texture = null
	if hand[1] != null:
		$CardContainer/Card2.texture = hand[1].sprite
	else:
		$CardContainer/Card2.texture = null
	if hand[2] != null:
		$CardContainer/Card3.texture = hand[2].sprite
	else:
		$CardContainer/Card3.texture = null
