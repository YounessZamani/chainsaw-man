extends State

var timer = 24
var dash_speed = 600
var dir = 1

func enter():
	fighter.movement_lock = true
	fighter.air_dashable = false
	fighter.anim.play("Dash")
	fighter.velocity.y = 0

	if !fighter.back_dashable:
		timer = 24
		if fighter.look_right:
			dir = 1
		else:
			dir = -1
	else:
		timer = 12
		if fighter.look_right:
			dir = -1
		else:
			dir = 1

func physics_update(_delta):

	timer -= 1

	fighter.velocity.x = dash_speed * dir
	fighter.velocity.y = 0

	if try_attack():
		return

	if timer <= 0:
		machine.change_state("Fall")
func exit():
	fighter.movement_lock = false
