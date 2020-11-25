extends Area2D

export (AudioStream) var StartSound
export (int) var speed
export (int) var damage
export (float) var damage_interval = 0.5
export (float) var lifetime
export (bool) var explodes_on_hit = true

var velocity = Vector2()
var recentlyDamagedEntities = []
var timer


func _on_Lifetime_timeout() -> void:
	explode()


func start(_position: Vector2, _direction: Vector2):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	velocity = _direction * speed
	$Sprite.play()
	if StartSound:
		var sound_player = preload("res://src/attacks/AttackAudioPlayer.tscn").instance()
		get_parent().add_child(sound_player)
		sound_player.position = position
		sound_player.play_sound(StartSound)


func _process(delta: float) -> void:
	position += velocity * delta
	for body in get_overlapping_bodies():
		if !recentlyDamagedEntities.has(body) and body.has_method('take_damage'):
			recentlyDamagedEntities.push_back(body)
			body.take_damage(damage)
			timer = Timer.new()
			timer.set_one_shot(true)
			timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
			timer.set_wait_time(damage_interval)
			timer.connect("timeout", self, "_make_eligible_for_damage")
			add_child(timer)
			timer.start()
		if explodes_on_hit or body.get_name() == "OtherTerrain" or body.get_name() == "Ground+FrontWalls":
			explode()


func _make_eligible_for_damage() -> void:
	recentlyDamagedEntities.pop_front()


func explode():
	queue_free()
