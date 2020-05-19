extends KinematicBody2D

signal health_changed
signal dead

export (int) var health
export (int) var speed
export (float) var attack_cooldown
export (int) var detect_radius

var velocity = Vector2()
var can_attack = true
var alive = true
var target = null


func _ready() -> void:
	$Timer.wait_time = attack_cooldown
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius


func control(delta: float):
	velocity = Vector2()


func _physics_process(delta: float) -> void:
	if not alive:
		return
	control(delta)
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var target_vect = Vector2(target_dir[0], target_dir[1])
		move_and_slide(target_vect * speed * delta)
	else:
		move_and_slide(velocity)
