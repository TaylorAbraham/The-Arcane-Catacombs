extends CanvasLayer

func _on_Player_health_changed(health: int, max_health: int) -> void:
	print("Hello!")
	$Margin/Container/HealthBar.value = float(health) / max_health * 100
