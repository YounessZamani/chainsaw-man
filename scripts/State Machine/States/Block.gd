extends State

var timer = 0.0

func enter():
	fighter.anim.play("Block")
	timer = fighter.blockstun_time / 60.0
	fighter.movable = false
	



func physics_update(delta):
	
	timer -= delta

	if timer <= 0:
		fighter.movable = true

		if fighter.is_on_floor():
			machine.change_state("Idle")
			return
		else:
			machine.change_state("Fall")
			return
