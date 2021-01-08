extends "res://src/entities/Entity.gd"

func on_interact():
	emit_signal("start_dialogue")
	yield(dialogue("All that glitters is not gold. By the pricking of my thumbs, Something wicked this way comes. Open, locks, Whoever knocks! Hell is empty and all the devils are here. Now is the winter of our discontent. The lady doth protest too much, methinks."), "completed")
	yield(dialogue("These violent delights have violent ends... Brevity is the soul of wit. Fair is foul, and foul is fair: Hover through the fog and filthy air. Good night, good night! Parting is such sweet sorrow, That I shall say good night till it be morrow. If music be the food of love, play on."), "completed")
	emit_signal("end_dialogue")
