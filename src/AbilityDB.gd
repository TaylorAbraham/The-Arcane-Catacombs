extends Node

const abilities = {
	fireBlast =  {
		id = "fire_blast",
		sprite = preload("res://resources/abilities/FireBlast.png"),
		scene = preload("res://src/attacks/friendly/FireBlast.tscn"),
		cooldown = 3.0,
	},
	roll = {
		id = "roll",
		sprite = preload("res://resources/abilities/Roll.png"),
		sound = preload("res://resources/abilities/Roll.wav"),
		cooldown = 5.0,
	},
}
