extends Node

# =========================
# INPUT ACTION NAMES
# =========================

@export var left_action  = "p1_left"
@export var right_action = "p1_right"
@export var up_action    = "p1_up"
@export var down_action  = "p1_down"

@export var punch_action = "p1_H"
@export var kick_action  = "p1_L"

# =========================
# SETTINGS
# =========================

@export var buffer_time := 1.0
@export var deadzone := 0.2
@export var enabled := true
var body

# =========================
# STORAGE
# =========================

var input_buffer = []
var time_buffer = []

var last_dir = "5"

# =========================
# MAIN LOOP
# =========================

func _process(_delta):
	if not enabled:
		return
	var dir = get_direction()

	if dir != last_dir :
		add_input(dir)
		last_dir = dir

	check_buttons()
	clean_buffer()

# =========================
# DIRECTION INPUT
# =========================

func get_direction():

	var x = Input.get_axis(left_action, right_action)
	var y = Input.get_axis(up_action, down_action)

	if abs(x) < deadzone:
		x = 0

	if abs(y) < deadzone:
		y = 0

	x = sign(x)
	y = sign(y)

	if body and not body.look_right:
		x *= -1

	if x == 0 and y == 0: return "5"
	if x == 0 and y > 0: return "2"
	if x == 0 and y < 0: return "8"
	if x > 0 and y == 0: return "6"
	if x < 0 and y == 0: return "4"
	if x > 0 and y > 0: return "3"
	if x < 0 and y > 0: return "1"
	if x > 0 and y < 0: return "9"
	if x < 0 and y < 0: return "7"

	return "5"

# =========================
# BUTTONS
# =========================

func check_buttons():

	if Input.is_action_just_pressed(punch_action):
		add_input(get_direction())
		add_input("H")

	if Input.is_action_just_pressed(kick_action):
		add_input("L")

# =========================
# BUFFER LOGIC
# =========================

func add_input(value):

	var t = Time.get_ticks_msec() / 1000.0

	input_buffer.append(value)
	time_buffer.append(t)

func clean_buffer():

	var now = Time.get_ticks_msec() / 1000.0

	while time_buffer.size() > 0 and now - time_buffer[0] > buffer_time:
		time_buffer.pop_front()
		input_buffer.pop_front()

func simplify_buffer():

	var result = []

	for i in input_buffer:
		if result.is_empty() or result[-1] != i:
			result.append(i)

	return result

func check_combo(pattern):

	var recent = simplify_buffer()

	if recent.size() < pattern.size():
		return false

	var last_inputs = recent.slice(recent.size() - pattern.size(), recent.size())

	if last_inputs == pattern:
		clear_buffer()
		last_dir = "5"
		return true

	return false

func clear_buffer():
	input_buffer.clear()
	time_buffer.clear()
