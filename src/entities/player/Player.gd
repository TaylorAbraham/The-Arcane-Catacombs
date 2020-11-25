extends "res://src/entities/Entity.gd"

signal health_changed
signal dead
signal use_ability
signal left_combat

export (float) var outOfCombatDelay

var rotation_timer
var rolling = false
var roll_direction

enum P_STATES {
	idle,
	running,
	rolling
}


func _on_OutOfCombatTimer_timeout() -> void:
	emit_signal("left_combat")


func _ready() -> void:
	._ready()
	$OutOfCombatTimer.wait_time = outOfCombatDelay
	emit_signal("health_changed", health, max_health)


func control(delta: float) -> void:
	$Staff.look_at(get_global_mouse_position())
	var prev_velocity := velocity
	velocity = Vector2()
	if state == P_STATES.rolling:
		velocity = roll_direction * speed * 3
	else:
		if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			set_state(P_STATES.running)
		else:
			set_state(P_STATES.idle)
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
				$OutOfCombatTimer.start()
				attack(BasicAttack, get_staff_location(), get_staff_dir())
		if Input.is_action_pressed("ability1"):
			$OutOfCombatTimer.start()
			emit_signal("use_ability", 0)
		if Input.is_action_pressed("ability2"):
			$OutOfCombatTimer.start()
			emit_signal("use_ability", 1)
		if Input.is_action_pressed("ability3"):
			$OutOfCombatTimer.start()
			emit_signal("use_ability", 2)
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
	$OutOfCombatTimer.start()
	health -= amount
	emit_signal("health_changed", health, max_health)
	if health <= 0:
		die()


func die() -> void:
	queue_free()


func roll() -> void:
	set_state(P_STATES.rolling)
	roll_direction = (get_global_mouse_position() - global_position).normalized()
	$Body.speed_scale = 5
	rotation_timer = Timer.new()
	rotation_timer.set_one_shot(true)
	rotation_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	rotation_timer.set_wait_time(0.5)
	rotation_timer.connect("timeout", self, "_finish_roll")
	add_child(rotation_timer)
	rotation_timer.start()
	


func _finish_roll() -> void:
	$Body.rotation = 0
	$Body.speed_scale = 1	
	set_state(P_STATES.idle)
