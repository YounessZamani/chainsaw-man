extends State

var timer = 0
func enter():
	fighter.anim.play("Punched")
	fighter.movable = false
	fighter.movement_lock = true
	fighter.current_move = ""
	fighter.current_move_data = {}
	fighter.hitbox.disable_all_boxes()
	fighter.Sprites.scale.x = 1
	fighter.Sprites.scale.y = 1
	fighter.can_act = false
	fighter.grabable = false
	timer = 0
	fighter.gravity = ProjectSettings.get_setting("physics/2d/default_gravity")* 0.5
	fighter.anim.speed_scale = 1
func physics_update(_delta):
	timer +=1
	if timer < 3:
		return
	if fighter.is_on_floor():
		fighter.combo_hits = 0
		if timer <40:
			machine.change_state("Idle")
		else:
			machine.change_state("Knockdown")

	
func exit():
	fighter.can_act = true
	fighter.grabable = true
	fighter.gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
