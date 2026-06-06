extends State
var frames = 0
func enter():


	fighter.hitbox.disable_all_boxes()
	frames = 0

func physics_update(_delta):
	frames +=1 
	var recover = fighter.current_move_data["recovery"] - fighter.current_move_data["active"]
	if frames >= recover :
		if fighter.is_on_floor():
			machine.change_state("Idle")
		elif fighter.velocity.y>0 :
			machine.change_state("Fall")
		elif fighter.velocity.y<0:
			machine.change_state("Jump")

func end_move():
	
	print("ends AT:",
	round(fighter.anim.current_animation_position * 60))
func exit():
	if fighter.is_on_floor():
		fighter.air_dashable= true
	fighter.movable = true
	fighter.current_move = ""
	fighter.hitbox.disable_all_boxes()
	fighter.current_move_data = {}
	fighter.movement_lock = false
	fighter.Sprites.scale.x = 1
	fighter.Sprites.scale.y = 1
