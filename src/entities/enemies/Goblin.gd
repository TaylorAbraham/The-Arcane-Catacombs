extends "res://src/entities/enemies/Enemy.gd"

var dash_timer

enum GOBLIN_STATES {
	preparing_dash,
	dashing,
}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func control(delta):
	.control(delta)
	if (target != null) and (state == STATES.running) and (Helpers.chance_per_sec(0.5, delta)):
		set_state(GOBLIN_STATES.preparing_dash)
		speed /= 10
		$Body.speed_scale /= 3
		dash_timer = Timer.new()
		dash_timer.set_one_shot(true)
		dash_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
		dash_timer.set_wait_time(1.5)
		dash_timer.connect("timeout", self, "_continue_dash")
		add_child(dash_timer)
		dash_timer.start()

func _continue_dash():
	# First, revert the slow
	speed *= 10
	$Body.speed_scale *= 3
	# Now accelerate!
	speed *= 4
	$Body.speed_scale *= 2
	dash_timer = Timer.new()
	dash_timer.set_one_shot(true)
	dash_timer.set_timer_process_mode(Timer.TIMER_PROCESS_PHYSICS)
	dash_timer.set_wait_time(0.8)
	dash_timer.connect("timeout", self, "_finish_dash")
	add_child(dash_timer)
	dash_timer.start()

func _finish_dash():
	speed /= 4
	$Body.speed_scale /= 2
	if target:
		set_state(STATES.running)
	else:
		set_state(STATES.idle)
