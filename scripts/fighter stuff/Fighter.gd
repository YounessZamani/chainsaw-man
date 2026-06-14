extends CharacterBody2D
class_name Fighter
# all fighter variable declaration
		#able variable, fighter is able to do blank

var runnable = false
var blocking = false
var movable = true
var jumpable = true
var dashable = false
var back_dashable = false
var air_dashable = false
var look_right = true
var wants_crouch = false
var crouch_charged = false
var health = 200
var opponent = null
var grabable = true
var countered = false

const SPEED = 250
const JUMP_FORCE = -700
var movement_lock = false
var can_act = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

		# move data things
var active_frame = 0
var hit_frame = 0
var startup_frame = 0
var action_frame = 0
var combo_hits = 0
var scaling = 100
var scale_reduc
		# move stuff
var current_move = ""
var current_move_data = {}
var move_timer = 0
var hit_targets = []
var moves =[]
var attack_connected = false
var attack_blocked = false
			# time stuff
var hitstun_time = 0
var blockstun_time = 0

var hitstop_time = 0

#children references
@onready var buffer = $InputBuffer
@onready var Sprites = $sprites
@onready var controller = $Controller
@onready var state_machine = $StateMachine
@onready var hitbox = $hitbox
@onready var hurtbox = $hurtbox
@onready var anim = $AnimationPlayer




func _ready():
	
	load_moves()
	for move in moves:
		print(move["name"],get_anim_frames(move["name"]))
	buffer.body = self
	find_opponent()
	state_machine.start(self)
	hitbox.hit_landed.connect(_on_hit_landed)

func _physics_process(delta):
	if hitstop_time > 0:

		anim.speed_scale = 0

		hitstop_time -= delta

		if hitstop_time <= 0:
			anim.speed_scale = 1

		return
	if controller:
		controller.control(self)
	
	if !is_on_floor():
		velocity.y += gravity * delta
	updateside()

	state_machine.physics_update(delta)


	move_and_slide()
	resolve_pushbox()
	update_hitbox_position()



					#	helper functions
func set_crouch(value):
	wants_crouch = value
func frames(n):
	return n / 60.0
func get_anim_frames(anim_name):
	var animframes = $AnimationPlayer.get_animation(anim_name)
	return round(animframes.length * 60)
func apply_hitstop(freeze):
	hitstop_time = freeze/60
func is_in_state(state_name):
	return state_machine.current_state.name == state_name
					#	move data stuff
func load_moves():

	var file = FileAccess.open("res://Moves.json", FileAccess.READ)

	if file == null:
		push_error("Failed to load moves.json")
		return

	var text = file.get_as_text()

	var json = JSON.new()

	var result = json.parse(text)

	if result != OK:
		push_error("JSON parse failed")
		return

	moves = json.data
func get_move_from_input():

	var grounded = is_on_floor()

	for move in moves:

		if buffer.check_combo(move["input"]):

			if grounded and move["ground_ok"]:
				buffer.consume_combo()
				return move["name"]

			if !grounded and move["air_ok"]:
				buffer.consume_combo()
				return move["name"]

	return ""
func get_move_data_by_name(Name):

	for move in moves:
		if move["name"] == Name:
			return move

	return null
func _on_hit_landed(enemy, move):
	hit_frame = active_frame
	print(hit_frame)
	apply_hitstop(move["freeze"])
	var was_blocked = enemy.take_hit(move)
	if !was_blocked:
		attack_connected = true
	else:
		attack_blocked = true
func can_block(move):

	if !blocking:
		return false

	match move["attack_type"]:

		"overhead":
			return !wants_crouch

		"low":
			return wants_crouch

		"mid":
			return true

	return false


func get_current_move_data():

	for move in moves:
		if move["name"] == current_move:
			return move

	return null
func take_hit(move):
	var blocked = can_block(move)
	apply_hitstop(move["freeze"])
	if !blocked:
		if is_in_state("Attack_Startup"):
			apply_counter(move)
		else:
			apply_hit(move)
	else:
		apply_block(move)
	return blocked
#							#side stuff basically opponent locating and updatign sides
func updateside():
	if not is_on_floor() and state_machine.current_state.name != "Fall":
		return
	if opponent == null:
		return

	if opponent.global_position.x > global_position.x:
		look_right = true
	elif opponent.global_position.x < global_position.x:
		look_right = false

func update_hitbox_position():

	if look_right:
		hitbox.scale.x = 1
		Sprites.flip_h = false
	else:
		hitbox.scale.x = -1
		Sprites.flip_h = true
func find_opponent():

	for f in get_tree().get_nodes_in_group("Fighters"):
		if f != self:
			opponent = f
func resolve_pushbox():

	if opponent == null:
		return

	# only push when both grounded
	if abs(opponent.global_position.y - global_position.y) <=80:
		var min_distance = 80

		var dist = opponent.global_position.x - global_position.x

		if abs(dist) < min_distance:

			var push = (min_distance - abs(dist)) / 2.0

			if dist > 0:
				global_position.x -= push
				opponent.global_position.x += push
			else:
				global_position.x += push
				opponent.global_position.x -= push
#-------------------- grab method attempts
func is_in_grab_range():
	if abs(opponent.position.x -position.x )< 100:
		return true
	else:
		return false
func apply_hit(move):
	health -= move["damage"]*scaling/100
	scale_reduc = combo_hits *10
	combo_hits +=1
	scaling -= scale_reduc
	print("scaling reduction is : ",scale_reduc," and total scaling is :", scaling )
	if !look_right:
		velocity.x = move["push"]
	else:
		velocity.x = -move["push"]
	var launch = move.get("launch", null)
	if launch != null:
		velocity.y = launch
	hitstun_time = move["stun"]
	if is_on_floor():
		state_machine.change_state("Hitstun")
	else:
		state_machine.change_state("Air_Hitstun")
func apply_block(move):
		health -= move["damage"] / 100

		if !look_right:
			velocity.x = move["push"] / 20
		else:
			velocity.x = -move["push"] / 20

		blockstun_time = move["stun"] / 2
		state_machine.change_state("Block")
func apply_counter(move):
	var counter = 1.5
	health -= counter *move["damage"]*scaling/100
	scale_reduc = combo_hits *10
	combo_hits +=1
	scaling -= scale_reduc
	print( "COOOOOOOOOOUNTER")
	countered = true
	print("scaling reduction is : ",scale_reduc," and total scaling is :", scaling )
	if !look_right:
		velocity.x = counter * move["push"]
	else:
		velocity.x = -counter *move["push"]

	hitstun_time = counter * move["stun"]
	
	state_machine.change_state("Hitstun")
func fit_animation_to_frames(move_data):
	var anim_frames = get_anim_frames(move_data["name"])
	var data_frames = move_data["startup"]+ move_data["active"]+ move_data["recovery"]


	anim.speed_scale = float(anim_frames) / float(data_frames)
