extends CharacterBody2D



var movable = true
var jumpable = true
var hit_active = false
var look_right = true
var wants_crouch = false

var health = 100
var opponent = null

const SPEED = 250
const JUMP_FORCE = -450

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



var current_move = ""
var current_move_data = {}
var move_timer = 0
var hit_targets = []

var hitstun_time = 0



@onready var buffer = $InputBuffer
@onready var anim = $sprites
@onready var controller = $Controller
@onready var state_machine = $StateMachine
@onready var hitbox = $hitbox


var moves = [
{
	"name":"test",
	"input":["2","3","6","H"],
	"startup":3,
	"active":4,
	"recovery":3,
	"damage":10,
	"push":150,
	"stun":30,
	"ground_ok":true,
	"air_ok":false
},
{
	"name":"low",
	"input":["2","H"],
	"startup":3,
	"active":2,
	"recovery":2,
	"damage":7,
	"push":120,
	"stun":24,
	"ground_ok":true,
	"air_ok":false
},{
	"name":"Punch",
	"input":["H"],
	"startup":3,
	"active":2,
	"recovery":2,
	"damage":5,
	"push":100,
	"stun":20,
	"ground_ok":true,
	"air_ok":true
}

]



func _ready():
	buffer.body = self
	find_opponent()
	state_machine.start(self)


func _physics_process(delta):

	if controller:
		controller.control(self)

	if !is_on_floor():
		velocity.y += gravity * delta

	updateside()

	state_machine.physics_update(delta)

	check_hits()

	move_and_slide()

	update_hitbox_position()

func set_crouch(value):
	wants_crouch = value

func get_move_from_input():

	var grounded = is_on_floor()

	for move in moves:

		if buffer.check_combo(move["input"]):

			if grounded and move["ground_ok"]:
				return move["name"]

			if !grounded and move["air_ok"]:
				return move["name"]

	return ""

func get_current_move_data():

	for move in moves:
		if move["name"] == current_move:
			return move

	return null


func take_hit(damage, push, stun):

	health -= damage
	if !look_right:
		velocity.x = push
	else: velocity.x = -push
	hitstun_time = stun

	state_machine.change_state("Hitstun")

# =========================
# HIT DETECTION
# =========================

func check_hits():

	if !hit_active:
		return

	for area in hitbox.get_overlapping_areas():

		if area.is_in_group("Hurtbox") and area.get_parent() != self:

			var enemy = area.get_parent()

			if enemy in hit_targets:
				continue

			hit_targets.append(enemy)

			var move = current_move_data

			enemy.take_hit(
				move["damage"],
				move["push"],
				move["stun"]
			)



func updateside():

	if opponent == null:
		return

	if opponent.global_position.x > global_position.x:
		look_right = true
	elif opponent.global_position.x < global_position.x:
		look_right = false

func update_hitbox_position():

	if look_right:
		hitbox.scale.x = 1
		anim.flip_h = false
	else:
		hitbox.scale.x = -1
		anim.flip_h = true

func is_in_state(state_name):
	return state_machine.current_state.name == state_name

func find_opponent():

	for f in get_tree().get_nodes_in_group("Fighters"):
		if f != self:
			opponent = f
func get_move_data_by_name(Name):

	for move in moves:
		if move["name"] == Name:
			return move

	return null
func frames(n):
	return n / 60.0


func _on_sprites_frame_changed():

	if current_move_data.is_empty(): return
	var f = anim.frame 
	var startup = current_move_data["startup"]
	var active = current_move_data["active"] 
	var recovery = current_move_data["recovery"]
	 # startup -> active 
	if f == startup: 
		state_machine.change_state("Attack_Active") 
		hit_active = true
	 # active -> recovery 
	elif f == startup + active: 
		state_machine.change_state("Attack_Recovery") 
		hit_active = false
	

func _on_sprites_animation_finished():
	if state_machine.current_state.name.begins_with("Attack"):
		hit_active = false
		movable = true
		current_move = ""
		current_move_data = {}
		state_machine.change_state("Idle")# Replace with function body.
