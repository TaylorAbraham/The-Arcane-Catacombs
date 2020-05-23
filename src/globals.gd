extends Node

const attacks = {
	energy_bolt =  {
		sound = preload("res://resources/attacks/friendly_attacks/EnergyBolt.wav"),
		scene = preload("res://src/attacks/friendly/EnergyBolt.tscn"),
	},
	swing = {
		sound = preload("res://resources/attacks/enemy_attacks/Swing.wav"),
		scene = preload("res://src/attacks/enemy/Swing.tscn"),
	},
}
