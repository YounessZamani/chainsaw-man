extends State

func enter():
	fighter.anim.play("Fall")
	fighter.jumpable = false
	fighter.velocity.y = 0

func physics_update(_delta):
	if try_attack():
		return

	if fighter.is_on_floor():
		machine.change_state("Land")
		fighter.air_dashable = true
		return
	if fighter.air_dashable and fighter.dashable:
		machine.change_state("Air_dash")
		fighter.air_dashable = false
		return
