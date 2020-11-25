extends Node2D
var card_db = preload("res://src/card_db.gd")

signal card_played

func _on_Player_play_card(card_index: int) -> void:
	var card = hand[card_index]
	hand[card_index] = null
	discard.append(card)
	emit_signal("card_played", card, card_index)


func _on_Player_left_combat() -> void:
	refill_hand()


func draw_card_to(idx: int) -> void:
	if deck.size() <= 0:
		refill_deck()
	var card = deck.pop_front()
	emit_signal("draw_card", card, idx)
	hand[idx] = card
	emit_signal("deck_changed", deck)
	$DrawCardPlayer.play()


func refill_hand() -> void:
	for i in range(3):
		if hand[i] == null:
			draw_card_to(i)
			# Wait before drawing another
			var t = Timer.new()
			t.set_wait_time(0.5)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")


func refill_deck() -> void:
	while discard.size() > 0:
		deck.append(discard.pop_front())
	deck.shuffle()
