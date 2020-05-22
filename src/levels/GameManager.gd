extends Node2D


func _ready() -> void:
	$Player.connect("attack", self, "_on_Entity_attack")
	$Player.connect("health_changed", $HUD, "_on_Player_health_changed")
	$Goblin.connect("attack", self, "_on_Entity_attack")


func _on_Entity_attack(attack, _position, _direction):
	var a = attack.instance()
	add_child(a)
	a.start(_position, _direction)
