extends State


# Called when the node enters the scene tree for the first time.
func enter():
	fighter.anim.play("CrouchEnd")
	fighter.jumpable= true
	fighter.movable = true
	print("crouch over")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	if !fighter.is_on_floor():
		machine.change_state("Jump")
		return

	if !fighter.anim.is_playing():
		if abs(fighter.velocity.x) > 0:
			machine.change_state("Walk")
		else:
			machine.change_state("Idle")
		return
