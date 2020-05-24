extends Node2D


func _ready() -> void:
	$Entities/Player.connect("health_changed", $HUD, "_on_Player_health_changed")
	for mob in $Entities.get_children():
		# This includes the player
		mob.connect("attack", self, "_on_Entity_attack")


func _on_Entity_attack(attack: Dictionary, _position: Vector2, _direction: Vector2):
	var a = attack.scene.instance()
	var sound_player = preload("res://src/attacks/AttackAudioPlayer.tscn").instance()
	
	add_child(a)
	a.start(_position, _direction)
	
	add_child(sound_player)
	sound_player.position = _position
	sound_player.play_sound(attack.sound)


func _on_Player_health_changed(health: int, max_health: int) -> void:
	if health < 100:
		if health > 0:
			$AudioStreamPlayer.set_stream(preload("res://resources/entities/player/PlayerDamage.wav"))
		else:
			$AudioStreamPlayer.set_stream(preload("res://resources/entities/player/PlayerDeath.wav"))
		$AudioStreamPlayer.play()
	$HUD._on_Player_health_changed(health, max_health)


func _on_DeckManager_card_played(card: Dictionary) -> void:
	if card.id == "roll":
		$Entities/Player.roll()
	if card.has("scene"):
		_on_Entity_attack(card, $Entities/Player.get_staff_location(), $Entities/Player.get_staff_dir())
