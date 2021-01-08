extends Node2D

signal use_ability

var AbilityDB = preload("res://src/AbilityDB.gd")

var abilities := [AbilityDB.abilities.fireBlast, AbilityDB.abilities.roll, AbilityDB.abilities.lightningBall]
var abilitiesReady := [true, true, true]

# Incremented for each occurrence that freezes the game, and decrements when resumed
# It is a counter and not a boolean to account for multiple different sources trying to pause/unpause the game
# I.E. Opening a menu after entering dialogue. We don't want to immediately unpause when the menu is closed.
var freezeCounter := 0


func _ready() -> void:
	$PlayerHealthPlayer.set_stream(preload("res://resources/entities/player/PlayerDamage.wav"))	
	$MusicPlayer.set_stream(preload("res://resources/music/upperdepths.ogg"))
	$MusicPlayer.play()
	$Entities/Player.connect("health_changed", $HUD, "_on_Player_health_changed")
	# TODO: This is not scalable, as it will not work for newly spawned enemies
	# This should instead be a connect called by the enemy on ready.
	# But how do I run the connect from entity to the GameManager?
	for mob in $Entities.get_children():
		# This includes the player
		mob.connect("attack", self, "_on_Entity_attack")
		mob.connect("start_dialogue", self, "_on_Entity_start_dialogue")
		mob.connect("end_dialogue", self, "_on_Entity_end_dialogue")
		mob.connect("dialogue", self, "_on_Entity_dialogue")


func _on_Entity_attack(Attack: PackedScene, _position: Vector2, _direction: Vector2):
	var a = Attack.instance()
	add_child(a)
	a.start(_position, _direction)


func _on_Entity_start_dialogue():
	freezeCounter += 1
	if freezeCounter == 1:
		for mob in $Entities.get_children():
			mob.freeze()


func _on_Entity_end_dialogue():
	freezeCounter -= 1
	if freezeCounter == 0:
		for mob in $Entities.get_children():
			mob.unfreeze()
	$HUD.close_text()


func _on_Entity_dialogue(text: String):
	$HUD.display_text(text)


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
