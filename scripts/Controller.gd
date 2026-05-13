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
	var run = Input.is_action_pressed(body.buffer.dash_action)
	var dash = Input.is_action_just_pressed(body.buffer.dash_action)
	var _forward = (right and body.look_right) or (left and not body.look_right)
	var backward = (left and body.look_right) or (right and not body.look_right)
	if body.wants_crouch and body.is_on_floor():
		body.velocity.x = 0
	elif body.is_on_floor() and not body.movable:
		body.velocity.x = 0
	else:
		if not body.movement_lock:
			if right:
				body.velocity.x = body.SPEED
			elif left:
				body.velocity.x = -body.SPEED
			elif !left and !right and not body.dashable:
				body.velocity.x = 0
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
	if (left and body.look_right)or (right and not body.look_right):
		body.blocking = true
	else:
		body.blocking = false
	if dash and backward:
		body.back_dashable = true
		body.dashable = true

	elif dash:
		body.dashable = true
		body.back_dashable = false

	else:
		body.dashable = false
		body.back_dashable = false
	if run:
		body.runnable = true
	else:
		body.runnable = false
	
