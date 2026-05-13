extends State
var timer = 3.0
var dir = 1
var run_speed = 400
func enter():
	timer = 1.0
	fighter.anim.play("Run")
	if fighter.look_right:
		dir = 1
	else:
		dir = -1
func exit():
	fighter.movement_lock = false	
func physics_update(delta):
	timer -= delta
	fighter.velocity.x = run_speed * dir
	if timer<=0 or not fighter.runnable:
		if try_attack():
			return

		if !fighter.is_on_floor() :
			machine.change_state("Jump")
			return

		if fighter.wants_crouch:
			machine.change_state("Crouch_Start")
			return

		if abs(fighter.velocity.x) > 0 and !fighter.dashable:
			fighter.dashable = false
			machine.change_state("Walk")
			return
		if fighter.velocity.x == 0 and !fighter.dashable:
			machine.change_state("Idle")
			return
