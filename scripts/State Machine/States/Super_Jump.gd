extends State

func enter():
	fighter.anim.play("Jump")
	fighter.movement_lock = true
func physics_update(_delta):
	if try_attack():
		return

	if fighter.velocity.y > 0:
		machine.change_state("Fall")
		return
	if fighter.air_dashable and fighter.dashable:
		fighter.air_dashable = false
		machine.change_state("Air_dash")
		return
