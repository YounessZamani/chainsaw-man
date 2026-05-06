extends State
var timer = 0.10
var dash_speed = 900
var dir = 1
func enter():
	timer = 0.10
	fighter.anim.play("Dash")
	if fighter.look_right:
		dir = 1
	else:
		dir = -1
	
func physics_update(delta):
	
	timer -= delta
	fighter.velocity.x = dash_speed * dir
	if timer <= 0:
		if fighter.state_machine.current_state.name.begins_with("Attack"):
			return
		var move = fighter.get_move_from_input()

		if move != "":
			fighter.current_move = move
			fighter.current_move_data = fighter.get_move_data_by_name(move)
			machine.change_state("Attack_Startup")
			return

		if fighter.wants_crouch and fighter.is_on_floor():
			machine.change_state("Crouch_Start")
			return

		if abs(fighter.velocity.x) > 0 and !fighter.dashable and fighter.is_on_floor():
			machine.change_state("Walk")
			return
		if fighter.dashable and fighter.is_on_floor():
			machine.change_state("Run")
			return
		if fighter.velocity.x == 0 and !fighter.dashable and fighter.is_on_floor():
			machine.change_state("Idle")
			return
