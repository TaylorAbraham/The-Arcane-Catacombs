extends CanvasLayer

func _on_Player_health_changed(health: int, max_health: int) -> void:
	var new_value := float(health) / max_health * 100
	if new_value < 100:
		$Container/HealthBar/Tween.interpolate_property($Container/HealthBar,
				'value', $Container/HealthBar.value, new_value, 0.1, Tween.TRANS_LINEAR,
				Tween.EASE_IN_OUT)
		$Container/HealthBar/Tween.start()
		$AnimationPlayer.play("healthbar_flash")
	else:
		$Container/HealthBar.value = new_value


func _on_DeckManager_deck_changed(deck: Array) -> void:
	pass # Replace with function body.


func _on_DeckManager_hand_changed(hand: Array) -> void:
	pass # Replace with function body.
