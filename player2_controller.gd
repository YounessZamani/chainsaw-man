extends Node

func control(body):
	var dir = Input.get_axis("p2_left", "p2_right")
	if body.wants_crouch and body.is_on_floor():
		body.velocity.x = 0
	elif body.is_on_floor() and not body.movable :
		body.velocity.x = 0
	else:
		body.velocity.x = dir * body.SPEED
	if dir < 0:
		body.anim.flip_h = true
	elif dir > 0:
		body.anim.flip_h = false
	if Input.is_action_pressed("p2_down") and body.is_on_floor():
		body.set_crouch(true)
	else:
		body.set_crouch(false)
	if Input.is_action_just_pressed("p2_up") and body.is_on_floor() and  body.jumpable:
		body.velocity.y = body.JUMP_FORCE

	
	if Input.is_action_just_released("p2_down"):
		body.jumpable= true
	
