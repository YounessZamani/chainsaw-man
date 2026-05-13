extends State
var timer = 0.10
var dash_speed = 900
var dir = 1
func enter():
	timer = 0.10
	fighter.anim.play("Dash")
	fighter.movement_lock = true
	if fighter.look_right:
		dir = 1
	else:
		dir = -1
	print(fighter.dashable, fighter.runnable)
func physics_update(delta):
	
	timer -= delta
	fighter.velocity.x = dash_speed * dir
	if timer <= 0:
		if try_attack():
			return
		if fighter.is_on_floor():
			if fighter.wants_crouch :
				machine.change_state("Crouch_Start")
				return

			if abs(fighter.velocity.x) > 0 and !fighter.runnable :
				fighter.movement_lock = false
				machine.change_state("Walk")
				return
			if fighter.runnable :
				machine.change_state("Run")
				return
			
			if fighter.velocity.x == 0 and !fighter.runnable :
				fighter.movement_lock = false
				machine.change_state("Idle")
				return

		
