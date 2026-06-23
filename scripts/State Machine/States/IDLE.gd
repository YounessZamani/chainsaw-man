extends State

func enter():
	fighter.anim.play("Idle")
	fighter.movable = true
	fighter.jumpable = true
	fighter.can_act = true
	fighter.anim.speed_scale = 1
	fighter.Sprites.scale = Vector2.ONE * fighter.default_size
	fighter.no_switch = false
func physics_update(_delta):
	if try_attack():
		return

	if !fighter.is_on_floor() :
		machine.change_state("Jump")
		return

	if fighter.wants_crouch:
		machine.change_state("Crouch_Start")
		return

	if abs(fighter.velocity.x) > 0:
		machine.change_state("Walk")
		return
	if fighter.dashable:
		if fighter.back_dashable:
			machine.change_state("Back_dash")
		else:
			machine.change_state("Dash")
			return
func exit():
	fighter.action_frame = 0
	fighter.startup_frame =0
