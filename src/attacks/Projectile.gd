extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime

var velocity = Vector2()


func _on_Projectile_body_entered(body: Node) -> void:
	explode()
	if body.has_method('take_damage'):
		body.take_damage(damage)


func _on_Lifetime_timeout() -> void:
	explode()


func start(_position: Vector2, _direction: Vector2):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	velocity = _direction * speed
	$Sprite.play()
	$AudioPlayer.play()


func _process(delta: float) -> void:
	position += velocity * delta


func explode():
	queue_free()
