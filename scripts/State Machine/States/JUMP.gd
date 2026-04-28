extends State

func enter():
	fighter.anim.play("Jump")
	print("jumping")
func physics_update(_delta):
	if fighter.state_machine.current_state.name.begins_with("Attack"):
		return
	var move = fighter.get_move_from_input()

	if move != "":
		fighter.current_move = move
		fighter.current_move_data = fighter.get_move_data_by_name(move)
		machine.change_state("Attack_Startup")
		return

	if fighter.velocity.y > 0:
		machine.change_state("Fall")
		return
