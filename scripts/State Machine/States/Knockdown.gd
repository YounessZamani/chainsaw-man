extends State

var frames = 60
# Called when the node enters the scene tree for the first time.
func enter():
	fighter.grabable = false
	fighter.hurtbox.invincible =true # Replace with function body.
	frames = 50
	fighter.anim.play("Knockdown")
	fighter.movable= false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	frames -= 1
	if frames < 0:
		machine.change_state("Tech")



