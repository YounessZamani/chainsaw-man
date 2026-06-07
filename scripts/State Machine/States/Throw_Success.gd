extends State

var frames = 0
# Called when the node enters the scene tree for the first time.
func enter():
	fighter.anim.play("Throw_Success") # Replace with function body.
	fighter.opponent.state_machine.change_state("Thrown")
	frames = 30
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	frames -= 1
	if frames <0:
		machine.change_state("Throw_Recovery")
