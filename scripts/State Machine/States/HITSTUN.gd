extends State

var timer = 0

func enter():
	fighter.anim.play("Punched")
	timer = fighter.hitstun_time 
	fighter.movable = false
	fighter.movement_lock = true
	fighter.current_move = ""
	fighter.current_move_data = {}
	fighter.hitbox.disable_all_boxes()
	



func physics_update(_delta):
	
	timer -= 1

	if timer <= 0:
		fighter.movable = true
		fighter.movement_lock = false
		if fighter.is_on_floor():
			machine.change_state("Idle")
		else:
			machine.change_state("Fall")

	
