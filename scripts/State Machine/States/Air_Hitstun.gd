extends State

var timer = 0

func enter():
	fighter.anim.play("Punched")
	timer = fighter.hitstun_time 
	fighter.movable = false
	fighter.movement_lock = true
	fighter.current_move = ""
	fighter.current_move_data = {}
	fighter.hitbox.disable_all_boxes()
	fighter.Sprites.scale.x = 1
	fighter.Sprites.scale.y = 1
	fighter.can_act = false
	fighter.grabable = false
	fighter.gravity = ProjectSettings.get_setting("physics/2d/default_gravity")* 0.5
func physics_update(_delta):
	
	timer -= 1

	if timer <= 0:
		fighter.movable = true
		fighter.movement_lock = false
		fighter.combo_hits = 0
		fighter.scaling = 100
		if fighter.is_on_floor():
			machine.change_state("Knockdown")
		else:
			machine.change_state("Fall")

func exit():
	fighter.can_act = true
	fighter.grabable = true
	fighter.gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
