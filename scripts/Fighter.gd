extends CharacterBody2D
var movable = true
var hit_active = false
var look_right = true 
const SPEED = 250
const JUMP_FORCE = -450
var jumpable = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var buffer = $InputBuffer
@onready var anim = $sprites
@onready var controller = $Control
var wants_crouch = false
var health = 100
var current_move = ""
var hit_targets = []
var opponent
var moves =[{
	"name":"low",
	"input": ["2","H"],
	"active_frame":3,
	"end_frame" :6
},
{
	"name": "test",
	"input" :["2","3","6","H"],
	"active_frame":3,
	"end_frame" :6
},
{
	"name" : "Punch",
	"input" :["5","H"],
	"active_frame":3,
	"end_frame" :6
}
]

enum State {
	IDLE,
	RUN,
	JUMP,
	CROUCH_START,
	CROUCH_HOLD,
	CROUCH_END,
	ATTACK,
	HITSTUN
}

var state = State.IDLE
func _ready():
	find_opponent()
	buffer.body = self
func _physics_process(delta):

	if controller:
		controller.control(self)
	var move = get_move_from_input()
	if move != "":
		start_move(move)

	if not is_on_floor():
		velocity.y += gravity * delta
	check_hits()
	move_and_slide()
	update_hitbox()
	update_state()
	update_animation()
	updateside()
func update_state():
	if state == State.HITSTUN:
		return
	if state == State.ATTACK:
		jumpable = false
		if is_on_floor() :
			movable = false
		return

	if wants_crouch and is_on_floor():

		if state != State.CROUCH_START and state != State.CROUCH_HOLD:
			state = State.CROUCH_START
			jumpable = false

		return

	if state == State.CROUCH_HOLD:
		state = State.CROUCH_END
		return

	if state == State.CROUCH_END:
		jumpable = true
		return

	if not is_on_floor():
		state = State.JUMP
		return

	if abs(velocity.x) > 0:
		state = State.RUN
	else:
		state = State.IDLE

func update_animation():

	match state:

		State.IDLE:
			anim.play("Idle")

		State.RUN:
			anim.play("Run")

		State.JUMP:
			anim.play("Jump")

		State.CROUCH_START:
			if anim.animation != "CrouchStart":
				anim.play("CrouchStart")

		State.CROUCH_HOLD:
			if anim.animation != "CrouchHold":
				anim.play("CrouchHold")

		State.CROUCH_END:
			if anim.animation != "CrouchEnd":
				anim.play("CrouchEnd")
		State.HITSTUN:
			if anim.animation != "Punched":
				anim.play("Punched")
		State.ATTACK:
			pass

func start_move(move_name):

	if state == State.ATTACK:
		return
	hit_targets.clear()
	state = State.ATTACK
	current_move = move_name
	anim.play(move_name)

func _on_sprites_animation_finished():

	if state == State.ATTACK:
		state = State.IDLE
		current_move = ""
		jumpable = true
		movable = true

	elif anim.animation == "CrouchStart":
		state = State.CROUCH_HOLD

	elif anim.animation == "CrouchEnd":
		state = State.IDLE
func set_crouch(value):
	wants_crouch = value
func get_move_from_input():
	if state == State.ATTACK:
		return ""
	for move in moves:
		if buffer.check_combo(move["input"]):
			return move["name"]

	return ""
func update_hitbox():
	if state != State.ATTACK:
		return

	var move = get_current_move_data()

	hit_active = (anim.frame >= move["active_frame"] and anim.frame <= move["end_frame"])
func take_hit(damage,push,stun):
	health -= damage
	velocity.x = push
	state = State.HITSTUN
	await get_tree().create_timer(stun).timeout
	if state == State.HITSTUN:
		state = State.IDLE
func updateside():
	if opponent == null : return
	if opponent.global_position.x - self.global_position.x >0 : look_right = true
	elif opponent.global_position.x - self.global_position.x <0 : look_right = false
func find_opponent():
	for f in get_tree().get_nodes_in_group("Fighters"):
		if f!= self:
			opponent = f
func check_hits():
	if not hit_active:
		return
	for area in $hitbox.get_overlapping_areas():
		
		if area.is_in_group("Hurtbox") and area.get_parent()!= self:
			var enemy = area.get_parent()

			if enemy in hit_targets:
				continue

			hit_targets.append(enemy)
			enemy.take_hit(5, 100, 0.5)
func get_current_move_data():
	for move in moves:
		if move["name"] == current_move:
			return move
	return null
