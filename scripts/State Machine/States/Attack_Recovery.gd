extends State

func enter():


	fighter.hit_active = false
	

func physics_update(_delta):

	pass
func end_move():
		fighter.hit_active = false
		fighter.movable = true
		fighter.current_move = ""
		fighter.current_move_data = {}
		if fighter.is_on_floor():
			machine.change_state("Idle")
		elif fighter.velocity.y>0 :
			machine.change_state("Fall")
		elif fighter.velocity.y<0:
			machine.change_state("Jump")
