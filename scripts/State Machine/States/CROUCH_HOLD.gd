extends State


# Called when the node enters the scene tree for the first time.
func enter():
	fighter.anim.play("CrouchHold") # Replace with function body.
	
	fighter.jumpable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	fighter.velocity.x = 0

	if try_attack():
		return
	if !fighter.is_on_floor():
		machine.change_state("Super_Jump")
		return

	if !fighter.wants_crouch:
		fighter.jumpable = true
		machine.change_state("Crouch_End")
		return
