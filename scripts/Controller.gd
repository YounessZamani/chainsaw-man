extends Node

func control(body):
	if body.is_in_state("Hitstun"):
		return
	var _dir = body.buffer.get_direction()
	var _last = body.buffer.prev_dir
	var down = Input.is_action_pressed(body.buffer.down_action)
	var up = Input.is_action_pressed(body.buffer.up_action)
	var right = Input.is_action_pressed(body.buffer.right_action)
	var left= Input.is_action_pressed(body.buffer.left_action)
	var _upper= Input.is_action_just_released(body.buffer.up_action)
	if body.wants_crouch and body.is_on_floor():
		body.velocity.x = 0
	elif body.is_on_floor() and not body.movable :
		body.velocity.x = 0
	else:
		if right:
			body.velocity.x = body.SPEED
		elif left:
			body.velocity.x = -body.SPEED
		else:
			body.velocity.x = 0
	if body.look_right:
		body.anim.flip_h = false
	else :
		body.anim.flip_h = true
	if down and body.is_on_floor():
		body.set_crouch(true)
	else:
		body.set_crouch(false)
	
	if up and body.is_on_floor() and body.jumpable:
		if body.crouch_charged:
			body.velocity.y = 1.8 * body.JUMP_FORCE
		else:
			body.velocity.y = 1.3* body.JUMP_FORCE
		body.jumpable = false
		body.crouch_charged = false
			
			
	
	
