extends KinematicBody2D

signal health_changed
signal dead

export (PackedScene) var BasicAttack
export (int) var speed
export (float) var rotation_speed
export (float) var basic_cooldown
export (int) var health

var velocity = Vector2()
var can_shoot = true
var alive = true

func _ready() -> void:
	$Timer.wait_time = basic_cooldown

func control(delta: float):
	$Staff.look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		velocity.y = -speed
	if Input.is_action_pressed("down"):
		velocity.y = speed
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	if Input.is_action_pressed("right"):
		velocity.x = speed

func _physics_process(delta: float) -> void:
	if not alive:
		return
	control(delta)
	move_and_slide(velocity)
