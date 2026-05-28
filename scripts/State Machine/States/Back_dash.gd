extends State
var timer = 30
var dash_speed = 500
var dir = 1
func enter():
	timer = 18
	fighter.movement_lock = true
	fighter.anim.play("Back_Dash")
	if fighter.look_right:
		dir = -1
	else:
		dir = 1
func exit():
	fighter.movement_lock = false
func physics_update(_delta):
	
	timer -= 1
	fighter.velocity.x = dash_speed * dir
	if timer <= 0:
		machine.change_state("Idle")
		return
