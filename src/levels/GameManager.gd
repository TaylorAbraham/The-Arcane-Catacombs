extends Node2D

signal use_ability

var AbilityDB = preload("res://src/AbilityDB.gd")

var abilities := [AbilityDB.abilities.fireBlast, AbilityDB.abilities.roll, AbilityDB.abilities.fireBlast]
var abilitiesReady := [true, true, true]


func _ready() -> void:
	$PlayerHealthPlayer.set_stream(preload("res://resources/entities/player/PlayerDamage.wav"))	
	$MusicPlayer.set_stream(preload("res://resources/music/upperdepths.ogg"))
	$MusicPlayer.play()
	$Entities/Player.connect("health_changed", $HUD, "_on_Player_health_changed")
	for mob in $Entities.get_children():
		# This includes the player
		mob.connect("attack", self, "_on_Entity_attack")


func _on_Entity_attack(Attack: PackedScene, _position: Vector2, _direction: Vector2):
	var a = Attack.instance()
	add_child(a)
	a.start(_position, _direction)


func _on_Player_health_changed(health: int, max_health: int) -> void:
	if health < 100:
		if health > 0:
			$PlayerHealthPlayer.set_stream(preload("res://resources/entities/player/PlayerDamage.wav"))
		else:
			$PlayerHealthPlayer.set_stream(preload("res://resources/entities/player/PlayerDeath.wav"))
		$PlayerHealthPlayer.play()
	$HUD._on_Player_health_changed(health, max_health)


func _on_Player_use_ability(i: int):
	if abilitiesReady[i]:
		abilitiesReady[i] = false
		var ability = abilities[i]
		emit_signal("use_ability", i, ability)
		if ability.id == "roll":
			$Entities/Player.roll()
		if ability.has("scene"):
			_on_Entity_attack(ability.scene, $Entities/Player.get_staff_location(), $Entities/Player.get_staff_dir())
		elif ability.has("sound"):
			var sound_player = preload("res://src/attacks/AttackAudioPlayer.tscn").instance()
			add_child(sound_player)
			sound_player.position = $Entities/Player.global_position
			sound_player.play_sound(ability.sound)
			


func _on_HUD_ability_ready(i):
	abilitiesReady[i] = true
