extends Node

func control(body):
	var move = body.get_move_from_input()
	var dir = Input.get_axis("p1_left", "p1_right")
	if body.wants_crouch and body.is_on_floor:
		body.velocity.x = 0
	else:
		body.velocity.x = dir * body.SPEED
	if dir < 0:
		body.anim.flip_h = true
	elif dir > 0:
		body.anim.flip_h = false
	if Input.is_action_pressed("p1_down") and body.is_on_floor():
		body.set_crouch(true)
	else:
		body.set_crouch(false)
	if Input.is_action_just_pressed("p1_up") and body.is_on_floor() and  body.jumpable:
		body.velocity.y = body.JUMP_FORCE

	if Input.is_action_just_pressed("p1_H"):
		if move != "":
			body.start_move(move)
		else:
			body.start_move("Punch")
	

	
