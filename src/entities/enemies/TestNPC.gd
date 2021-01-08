extends "res://src/entities/Entity.gd"

func on_interact():
	emit_signal("start_dialogue")
#	yield(dialogue("Now, this is a story all about how\nMy life got flipped-turned upside down\nAnd I'd like to take a minute\nJust sit right there\nI'll tell you how I became the prince of a town called Bel Air"), "completed")
	yield(dialogue("Lorem hizzle dolizzle sizzle amet, consectetuer adipiscing fizzle. Nullam sapien izzle, nizzle volutpizzle, the bizzle quizzle, ma nizzle vizzle, ghetto. Pellentesque eget tortizzle. Sed eros. Brizzle dang dolor dapibus sheezy tellivizzle tempor. Maurizzle pellentesque nibh izzle. Vestibulum break it down tortor. Owned owned gangsta funky fresh. Pimpin' hac dang platea hizzle."), "completed")
	emit_signal("end_dialogue")
