extends State
var timer = 0.5
var dash_speed = 500
var dir = 1
func enter():
	timer = 0.30
	fighter.movement_lock = true
	fighter.anim.play("Back_Dash")
	if fighter.look_right:
		dir = -1
	else:
		dir = 1
func exit():
	fighter.movement_lock = false
func physics_update(delta):
	
	timer -= delta
	fighter.velocity.x = dash_speed * dir
	if timer <= 0:
		machine.change_state("Idle")
		return
