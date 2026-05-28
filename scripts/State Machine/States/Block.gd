extends State

var timer = 0.0

func enter():
	fighter.anim.play("Block")
	timer = fighter.blockstun_time 
	fighter.movable = false
	
	fighter.current_move = ""
	fighter.current_move_data = {}
	fighter.hitbox.disable_all_boxes()


func physics_update(_delta):
	
	timer -= 1

	if timer <= 0:
		fighter.movable = true

		if fighter.is_on_floor():
			machine.change_state("Idle")
			return
		else:
			machine.change_state("Fall")
			return
