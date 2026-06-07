extends State

func enter():
	fighter.anim.play("Fall")
	fighter.jumpable = false
	fighter.velocity.y = 0
	fighter.movement_lock = true

func physics_update(_delta):
	if try_attack():
		return

	if fighter.is_on_floor():
		machine.change_state("Land")
		
		return
	if fighter.air_dashable and fighter.dashable:
		machine.change_state("Air_dash")
		return
