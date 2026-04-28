extends Node

func control(body):
	if body.is_in_state("Hitstun"):
		return
	var dir = body.buffer.get_direction()
	var last= body.buffer.last_dir
	if body.wants_crouch and body.is_on_floor():
		body.velocity.x = 0
	elif body.is_on_floor() and not body.movable :
		body.velocity.x = 0
	else:
		if dir in ["6","9"]:
			body.velocity.x = body.SPEED if body.look_right else -body.SPEED
		elif dir in ["4","7"]:
			body.velocity.x = -body.SPEED if body.look_right else body.SPEED
		else:
			body.velocity.x = 0
	if body.look_right:
		body.anim.flip_h = false
	else :
		body.anim.flip_h = true
	if dir in ["1","2","3"] and body.is_on_floor():
		body.set_crouch(true)
	else:
		body.set_crouch(false)
	if dir in ["7","8","9"] and body.is_on_floor() and  body.jumpable:
		body.velocity.y =1.8* body.JUMP_FORCE

	
	if dir not in ["1","2","3"]:
		body.jumpable= true
	
