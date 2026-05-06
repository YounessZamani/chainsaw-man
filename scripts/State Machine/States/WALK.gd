extends State

func enter():
	fighter.anim.play("Walk")
	
func physics_update(_delta):
	if fighter.state_machine.current_state.name.begins_with("Attack"):
		return
	var move = fighter.get_move_from_input()

	if move != "":
		fighter.current_move = move
		fighter.current_move_data = fighter.get_move_data_by_name(move)
		machine.change_state("Attack_Startup")
		return

	if !fighter.is_on_floor():
		machine.change_state("Jump")
		return

	if fighter.wants_crouch:
		machine.change_state("Crouch_Start")
		return

	if fighter.velocity.x == 0:
		machine.change_state("Idle")
		return
	if fighter.dashable:
		if fighter.back_dashable:
			machine.change_state("Back_dash")
		else:
			machine.change_state("Dash")
			return
