extends State
var frames = 0
func enter():

	
	
	frames = 0


func physics_update(_delta):
	frames += 1
	fighter.active_frame +=1
	fighter.action_frame +=1 
	var active = fighter.current_move_data["active"] - fighter.current_move_data["startup"]
	if fighter.is_in_grab_range() and fighter.opponent.grabable:
		machine.change_state("Throw_Success")
		return
	if frames >= active :
		machine.change_state("Throw_Recovery")
		fighter.anim.play("Throw_Whiff")

func exit():

	fighter.hitbox.disable_all_boxes()
func recover():
		print("goes to recovery  AT:",
		round(fighter.anim.current_animation_position * 60))
