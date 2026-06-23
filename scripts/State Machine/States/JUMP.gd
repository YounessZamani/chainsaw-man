extends State

func enter():
	fighter.anim.play("Jump")
	fighter.movement_lock = true
	fighter.no_switch = true
func physics_update(_delta):
	if try_attack():
		return

	if fighter.velocity.y > 0:
		machine.change_state("Fall")
		return
	if fighter.air_dashable and fighter.dashable:
		machine.change_state("Air_dash")
		return
