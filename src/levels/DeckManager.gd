extends Node2D
var card_db = preload("res://src/card_db.gd")

signal deck_changed
signal hand_changed
signal card_played

var deck := [
	card_db.cards.fire_blast,
	card_db.cards.fire_blast,
	card_db.cards.fire_blast,
	card_db.cards.fire_blast,
	card_db.cards.fire_blast,
	card_db.cards.roll,
	card_db.cards.roll,
	card_db.cards.roll,
	card_db.cards.roll,
	card_db.cards.roll,
]

var hand := [null, null, null]


func _ready() -> void:
	randomize()
	deck.shuffle()
	hand[0] = deck.pop_front()
	hand[1] = deck.pop_front()
	hand[2] = deck.pop_front()
	emit_signal("deck_changed", deck)
	emit_signal("hand_changed", hand)


func _on_Player_play_card(card_index: int) -> void:
	var card = hand[card_index]
	hand[card_index] = null
	emit_signal("hand_changed", hand)
	emit_signal("card_played", card)
