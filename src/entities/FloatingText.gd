extends Position2D

var amount = 0
var velocity = Vector2(0, 0)

func _ready():
	$Label.set_text(str(amount))
	randomize()
	var side_movement = randi() % 21 - 10 # random int from -10 to +10
	velocity = Vector2(side_movement, 10)
	$Tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.1, 0.1), 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	$Tween.start()


func _on_Tween_tween_all_completed():
	self.queue_free()

func _process(delta):
	position -= velocity * delta
