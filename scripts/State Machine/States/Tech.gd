extends State


# Called when the node enters the scene tree for the first time.
func enter():
	fighter.anim.play("Tech") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	_on_animation_player_animation_finished("Tech")
func exit():
	fighter.grabable = true
	fighter.hurtbox.invincible = false

func _on_animation_player_animation_finished(_anim_name):
	machine.change_state("Idle") # Replace with function body.
