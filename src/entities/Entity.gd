extends KinematicBody2D

signal attack
signal start_dialogue
signal dialogue(text)
signal end_dialogue

export (PackedScene) var BasicAttack
export (int) var speed
export (float) var basic_cooldown
export (int) var max_health

var floating_text = preload("./FloatingText.tscn")

var velocity := Vector2()
var can_attack := true
var alive := true
var invulnerable := false
var health: int
var state: int
var frozen := false

enum STATES {
	idle,
	running,
}


func _on_AttackCooldown_timeout() -> void:
	can_attack = true


func _ready() -> void:
	$AttackCooldown.wait_time = basic_cooldown
	health = max_health
	state = STATES.idle


func _physics_process(delta: float) -> void:
	if frozen or not alive:
		return
	control(delta)
	velocity = move_and_slide(velocity)


func control(delta: float) -> void:
	pass


func set_state(new_state: int) -> void:
	if state == new_state:
		# Ignore state changes to the same state
		return
	match new_state:
		STATES.idle:
			$Body.play('idle')
		STATES.running:
			$Body.play('running')
	state = new_state


func attack(_attack, pos: Vector2, dir: Vector2) -> void:
	can_attack = false
	$AttackCooldown.start()
	emit_signal('attack', _attack, pos, dir)


func take_damage(amount: int) -> void:
	health -= amount
	var text = floating_text.instance() # Copy the preloaded scene
	text.amount = amount
	text.global_position = global_position
	get_parent().add_child(text)
	if health <= 0:
		die()


func dialogue(text: String) -> void:
	emit_signal("dialogue", text)
	yield(get_tree().get_root().find_node("HUD", true, false), "dialogue_progressed")


func die() -> void:
	queue_free()

func freeze() -> void:
	frozen = true

func unfreeze() -> void:
	frozen = false
