extends State
var frame = 0
func enter():
	frame = 0
	if fighter.is_on_floor():
		fighter.velocity.x = 0
	if fighter.current_move_data == null:
		push_error("Attack entered with NULL move data")
		machine.change_state("Idle")
		return
	fighter.buffer.clear_buffer()
	fighter.attack_connected = false
	fighter.attack_blocked = false
	fighter.movement_lock = true
	fighter.can_act = false
	fighter.hitbox.disable_all_boxes()
	fighter.hit_targets.clear()
	fighter.anim.stop()
	fighter.anim.play(fighter.current_move_data["name"])
	fighter.active_frame = 0
	fighter.hit_frame = 0
	fighter.startup_frame = 0
	fighter.action_frame = 0
	fighter.fit_animation_to_frames(fighter.current_move_data)
func physics_update(_delta):
	frame +=1 
	fighter.startup_frame +=1 
	fighter.action_frame +=1 
	var startup = fighter.current_move_data["startup"]
	if frame >= startup :
		machine.change_state("Attack_Active")
func activate_hit():
	print("ACTIVE AT:",
		round(fighter.anim.current_animation_position * 60))

