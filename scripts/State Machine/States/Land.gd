extends State


# Called when the node enters the scene tree for the first time.
func enter():
	fighter.anim.play("Landing") # Replace with function body.
	fighter.movable = false
	fighter.movement_lock = false
	fighter.air_dashable = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.



func Landing():
	machine.change_state("Idle")
