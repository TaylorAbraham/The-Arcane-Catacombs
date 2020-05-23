extends "res://src/entities/Entity.gd"

export (float) var attack_distance
export (int) var detect_radius
export (int) var attack_radius

var target: KinematicBody2D = null
var target_in_range := false


func _on_DetectRadius_body_entered(body: Node) -> void:
	if body.name == "Player":
		target = body


func _on_DetectRadius_body_exited(body: Node) -> void:
	if body == target:
		target = null


func _on_AttackRadius_body_entered(body: Node) -> void:
	if body == target:
		target_in_range = true


func _on_AttackRadius_body_exited(body: Node) -> void:
	if body == target:
		target_in_range = false


func _on_AttackCooldown_timeout() -> void:
	can_attack = true


func _ready() -> void:
	._ready()
	$DetectRadius.connect("body_entered", self, "_on_DetectRadius_body_entered")
	$DetectRadius.connect("body_exited", self, "_on_DetectRadius_body_exited")
	$AttackRadius.connect("body_entered", self, "_on_AttackRadius_body_entered")
	$AttackRadius.connect("body_exited", self, "_on_AttackRadius_body_exited")
	$DetectRadius/DetectCollider.shape = CircleShape2D.new()
	$DetectRadius/DetectCollider.shape.radius = detect_radius
	$AttackRadius/AttackCollider.shape = CircleShape2D.new()
	$AttackRadius/AttackCollider.shape.radius = attack_radius


func control(delta: float):
	velocity = Vector2()


func _physics_process(delta: float) -> void:
	if not alive:
		return
	control(delta)
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var target_vect = Vector2(target_dir[0], target_dir[1])
		var prev_velocity := velocity
		velocity = move_and_slide(target_vect * speed * delta)
		# Flip sprite if direction changed
		if velocity.x < 0 and prev_velocity.x >= 0:
			# Now moving left
			$Body.set_flip_h(true)
		elif velocity.x > 0 and prev_velocity.x <= 0:
			# Now moving right
			$Body.set_flip_h(false)
		if target_in_range and can_attack:
			var target_pos = $Hitbox.global_position + (attack_distance * target_dir.normalized())
			attack(globals.attacks.swing, target_pos, target_dir)
	else:
		velocity = move_and_slide(velocity)
