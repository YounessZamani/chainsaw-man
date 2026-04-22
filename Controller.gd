extends Node

func control(body):

	var dir = Input.get_axis("p1_left", "p1_right")

	body.velocity.x = dir * body.SPEED

	if Input.is_action_just_pressed("p1_jump") and body.is_on_floor():
		body.velocity.y = body.JUMP_FORCE

	if Input.is_action_just_pressed("p1_punch"):
		body.punch()
