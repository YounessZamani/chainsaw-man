extends Node

func control(body):
	if body.state == body.State.HITSTUN:
		return
	body.velocity.x = 0
	body.anim.flip_h = true
	# does nothing / stands still
