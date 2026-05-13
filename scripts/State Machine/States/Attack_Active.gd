extends State

func enter():


	fighter.hit_active = true


func physics_update(_delta):

	pass
func recover():
	machine.change_state("Attack_Recovery")

