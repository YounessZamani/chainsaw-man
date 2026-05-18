extends State
var frames = 0
func enter():


	fighter.hit_active = true
	frames = 0

func physics_update(_delta):
	frames +=1 
	var active = fighter.current_move_data["active"] - fighter.current_move_data["startup"]
	if frames >= active :
		machine.change_state("Attack_Recovery")

func exit():
	print("goes to recovery  AT:",
		round(fighter.anim.current_animation_position * 60))
	fighter.hit_active = false
