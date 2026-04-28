extends State

func enter():
	fighter.anim.play("Fall")
	fighter.jumpable = false
	print("falling")
func physics_update(_delta):
	if fighter.state_machine.current_state.name.begins_with("Attack"):
		return
	var move = fighter.get_move_from_input()

	if move != "":
		fighter.current_move = move
		fighter.current_move_data = fighter.get_move_data_by_name(move)
		machine.change_state("Attack_Startup")
		return

	if fighter.is_on_floor():
		machine.change_state("Idle")
		return
