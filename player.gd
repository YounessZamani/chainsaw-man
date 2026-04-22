extends CharacterBody2D

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
var moves =[{
	"name" : "jab",
	"input" :["5","H"]
},
{
	"name": "test",
	"input" :["2","3","6","H"]
}
]

enum State {
	IDLE,
	RUN,
	JUMP,
	CROUCH_START,
	CROUCH_HOLD,
	CROUCH_END,
	ATTACK
}

var state = State.IDLE

func _physics_process(delta):

	if controller:
		controller.control(self)

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

	update_state()
	update_animation()

func update_state():

	if state == State.ATTACK:
		jumpable = false
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

		State.ATTACK:
			pass

func start_move(move_name):

	if state == State.ATTACK:
		return

	state = State.ATTACK
	current_move = move_name
	anim.play(move_name)

func _on_sprites_animation_finished():

	if state == State.ATTACK:
		state = State.IDLE
		current_move = ""
		jumpable = true

	elif anim.animation == "CrouchStart":
		state = State.CROUCH_HOLD

	elif anim.animation == "CrouchEnd":
		state = State.IDLE
func set_crouch(value):
	wants_crouch = value
func get_move_from_input():

	for move in moves:
		if buffer.check_combo(move["input"]):
			return move["name"]

	return ""
