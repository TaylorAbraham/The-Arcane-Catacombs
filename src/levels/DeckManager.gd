extends Node2D

signal deck_changed
signal hand_changed

var deck := [
	preload("res://src/cards/Roll.tscn").instance(),
	preload("res://src/cards/Roll.tscn").instance(),
	preload("res://src/cards/Roll.tscn").instance(),
	preload("res://src/cards/Roll.tscn").instance(),
	preload("res://src/cards/Roll.tscn").instance(),
	preload("res://src/cards/FireBlast.tscn").instance(),
	preload("res://src/cards/FireBlast.tscn").instance(),
	preload("res://src/cards/FireBlast.tscn").instance(),
	preload("res://src/cards/FireBlast.tscn").instance(),
	preload("res://src/cards/FireBlast.tscn").instance(),
]

var hand := []


func _init() -> void:
	deck.shuffle()
	hand.append(deck.pop_front())
	hand.append(deck.pop_front())
	emit_signal("deck_changed", deck)
	emit_signal("hand_changed", hand)
