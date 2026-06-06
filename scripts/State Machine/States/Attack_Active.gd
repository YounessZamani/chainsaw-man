extends State
var frames = 0
func enter():

	
	fighter.hitbox.enable_box(fighter.current_move_data["box_type"])
	frames = 0

func physics_update(_delta):
	frames += 1
	fighter.active_frame +=1
	var cancel_data = fighter.current_move_data.get("cancel", {})

	if !cancel_data.is_empty():

		var start = cancel_data.get("start_window", 0)
		var end = cancel_data.get("end_window", 999)

		if frames >= start and frames <= end:

			if try_cancel():
				return
		var active = fighter.current_move_data["active"] - fighter.current_move_data["startup"]
		if frames >= active :
			machine.change_state("Attack_Recovery")

func exit():

	fighter.hitbox.disable_all_boxes()
func recover():
		print("goes to recovery  AT:",
		round(fighter.anim.current_animation_position * 60))
