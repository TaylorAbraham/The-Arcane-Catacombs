extends Node

func chance_per_sec(chance: float, delta: float) -> bool:
	if delta == 0:
		# Prevents a division by 0 error which can occur on rare occasion
		return false
	return (randf() / delta) < chance
