extends State


# Called when the node enters the scene tree for the first time.
func enter():
	fighter.anim.play("Landing") # Replace with function body.
	fighter.movable = false
	print("landing")

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_sprites_animation_finished():
	if fighter.anim.animation == "Landing" :
		machine.change_state("Idle")# Replace with function body.
