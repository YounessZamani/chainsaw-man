extends State

func enter():

	if fighter.current_move_data == null:
		push_error("Attack entered with NULL move data")
		machine.change_state("Idle")
		return
	fighter.buffer.clear_buffer()

	fighter.movable = false
	fighter.hit_active = false
	fighter.hit_targets.clear()

	fighter.anim.play(fighter.current_move_data["name"])
func physics_update(_delta):

	pass
func activate_hit():
	machine.change_state("Attack_Active")
