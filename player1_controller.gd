extends Node

func control(body):
	
	var dir = Input.get_axis("p1_left", "p1_right")
	if body.wants_crouch and body.is_on_floor():
		body.velocity.x = 0
	elif body.is_on_floor() and not body.movable :
		body.velocity.x = 0
	else:
		body.velocity.x = dir * body.SPEED
	if body.look_right:
		body.anim.flip_h = false
	else :
		body.anim.flip_h = true
	if Input.is_action_pressed("p1_down") and body.is_on_floor():
		body.set_crouch(true)
	else:
		body.set_crouch(false)
	if Input.is_action_just_pressed("p1_up") and body.is_on_floor() and  body.jumpable:
		body.velocity.y = body.JUMP_FORCE

	
	if Input.is_action_just_released("p1_down"):
		body.jumpable= true
	
