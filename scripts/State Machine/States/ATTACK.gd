extends State

func enter():

	if fighter.current_move_data == null:
		push_error("Attack entered with NULL move data")
		machine.change_state("Idle")
		return

	fighter.movable = false
	fighter.hit_active = false
	fighter.hit_targets.clear()

	fighter.anim.play(fighter.current_move)

	print("STARTUP")

	fighter.anim.play(fighter.current_move_data["name"])
func physics_update(_delta):

	pass
