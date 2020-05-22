extends "res://src/entities/Entity.gd"

signal health_changed
signal dead

func _ready() -> void:
	._ready()
	emit_signal("health_changed", health, max_health)


func control(delta: float) -> void:
	$Staff.look_at(get_global_mouse_position())
	var prev_velocity := velocity
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		velocity.y = -speed
	if Input.is_action_pressed("down"):
		velocity.y = speed
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	if Input.is_action_pressed("right"):
		velocity.x = speed
	if Input.is_action_pressed("shoot"):
		if can_attack:
			shoot()
	# Flip sprite if direction changed
	if velocity.x < 0 and prev_velocity.x >= 0:
		# Now moving left
		$Body.set_flip_h(true)
	elif velocity.x > 0 and prev_velocity.x <= 0:
		# Now moving right
		$Body.set_flip_h(false)


func shoot() -> void:
	.shoot()
	var dir = Vector2(1, 0).rotated($Staff.global_rotation)
	emit_signal("attack", BasicAttack, $Staff/Tip.global_position, dir)


func take_damage(amount: int) -> void:
	health -= amount
	print(health)
	print(max_health)
	emit_signal("health_changed", health, max_health)
	if health <= 0:
		die()


func die() -> void:
	queue_free()
