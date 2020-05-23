extends KinematicBody2D
const globals = preload("res://src/globals.gd")

signal attack

export (PackedScene) var BasicAttack
export (int) var speed
export (float) var basic_cooldown
export (int) var max_health
export (float) var invulnerability_time

var velocity := Vector2()
var can_attack := true
var alive := true
var invulnerable := false
var health: int


func _on_AttackCooldown_timeout() -> void:
	can_attack = true


func _ready() -> void:
	$AttackCooldown.wait_time = basic_cooldown
	$InvulnerabilityTimer.wait_time = invulnerability_time
	health = max_health


func _physics_process(delta: float) -> void:
	if not alive:
		return
	control(delta)
	velocity = move_and_slide(velocity)


func control(delta: float) -> void:
	pass


func attack(_attack, pos: Vector2, dir: Vector2) -> void:
	can_attack = false
	$AttackCooldown.start()
	emit_signal('attack', _attack, pos, dir)


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()


func die() -> void:
	queue_free()
