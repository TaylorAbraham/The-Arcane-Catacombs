extends "res://src/attacks/Projectile.gd"


func _on_Sprite_animation_finished() -> void:
	explode()


func _on_Projectile_body_entered(body: Node) -> void:
	if body.has_method('take_damage'):
		body.take_damage(damage)
