extends State

var frame = 0
# Called when the node enters the scene tree for the first time.
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
	fighter.anim.play("Throw_Startup")
	fighter.active_frame = 0
	fighter.hit_frame = 0
	fighter.startup_frame = 0
	fighter.action_frame = 0 # Replace with function body.
	fighter.fit_animation_to_frames(fighter.current_move_data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	frame +=1 
	fighter.startup_frame +=1 
	fighter.action_frame +=1
	var startup = fighter.current_move_data["startup"]
	if frame >= startup :
		machine.change_state("Throw_Active")
func activate_hit():
	print("GRab ACTIVE AT:",
		round(fighter.anim.current_animation_position * 60))
