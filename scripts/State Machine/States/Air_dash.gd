extends State
func enter():
	fighter.anim.play("Dash")
	if fighter.look_right:
		fighter.position.x += 70
	else:
		fighter.position.x -= 70
	
func physics_update(delta):
	
	
	if fighter.state_machine.current_state.name.begins_with("Attack"):
		return
	var move = fighter.get_move_from_input()

	if move != "":
		fighter.current_move = move
		fighter.current_move_data = fighter.get_move_data_by_name(move)
		machine.change_state("Attack_Startup")
		return
	if not fighter.is_on_floor():
		machine.change_state("Fall") 
		return
