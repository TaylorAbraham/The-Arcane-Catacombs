extends "res://src/entities/Entity.gd"

signal health_changed
signal dead
signal play_card

export (float) var outOfCombatDelay


func _ready() -> void:
	._ready()
	$OutOfCombatTimer.wait_time = outOfCombatDelay
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
	if Input.is_action_pressed("attack"):
		if can_attack:
			attack(globals.attacks.energy_bolt, get_staff_location(), get_staff_dir())
	if Input.is_action_just_pressed("card1"):
		emit_signal("play_card", 0)
	if Input.is_action_just_pressed("card2"):
		emit_signal("play_card", 1)
	if Input.is_action_just_pressed("card3"):
		emit_signal("play_card", 2)
	# Flip sprite if direction changed
	if velocity.x < 0 and prev_velocity.x >= 0:
		# Now moving left
		$Body.set_flip_h(true)
	elif velocity.x > 0 and prev_velocity.x <= 0:
		# Now moving right
		$Body.set_flip_h(false)


func get_staff_location() -> Vector2:
	return $Staff/Tip.global_position


func get_staff_dir() -> Vector2:
	return Vector2(1, 0).rotated($Staff.global_rotation)


func take_damage(amount: int) -> void:
	health -= amount
	emit_signal("health_changed", health, max_health)
	if health <= 0:
		die()


func die() -> void:
	queue_free()


func roll() -> void:
	print("ROLLIN ROLLIN ROLLIN")
