extends State

var timer = 0.0

func enter():
	fighter.anim.play("Punched")
	timer = fighter.hitstun_time / 60.0
	fighter.movable = false
	print("hitsuned")



func physics_update(delta):
	
	timer -= delta

	if timer <= 0:
		fighter.movable = true

		if fighter.is_on_floor():
			machine.change_state("Idle")
		else:
			machine.change_state("Fall")
