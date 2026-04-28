extends State


# Called when the node enters the scene tree for the first time.
func enter():
	fighter.anim.play("CrouchStart")
	fighter.movable = false# Replace with function body.
	fighter.jumpable = false
	fighter.crouch_charged = true
	print("crouchstarting")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	if !fighter.is_on_floor():
		machine.change_state("Jump")
		return

	if !fighter.anim.is_playing():
		if fighter.wants_crouch:
			machine.change_state("Crouch_Hold")
		else:
			machine.change_state("Crouch_End")
		return
