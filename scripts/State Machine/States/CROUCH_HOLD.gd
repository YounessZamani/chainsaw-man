extends State


# Called when the node enters the scene tree for the first time.
func enter():
	fighter.anim.play("CrouchHold") # Replace with function body.
	print("holding crouch")
	fighter.jumpable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	fighter.velocity.x = 0

	var move = fighter.get_move_from_input()
	if move != "":
		fighter.current_move = move
		fighter.current_move_data = fighter.get_move_data_by_name(move)
		machine.change_state("Attack_Startup")
		return

	if !fighter.is_on_floor():
		machine.change_state("Jump")
		return

	if !fighter.wants_crouch:
		machine.change_state("Crouch_End")
		return
