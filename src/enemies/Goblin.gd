extends "res://src/enemies/Enemy.gd"


func _on_DetectRadius_body_entered(body: Node) -> void:
	if body.name == "Player":
		target = body


func _on_DetectRadius_body_exited(body: Node) -> void:
	if body == target:
		target = null
