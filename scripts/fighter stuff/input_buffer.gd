extends Node

# =========================
# INPUT ACTION NAMES
# =========================

@export var left_action  = "p1_left"
@export var right_action = "p1_right"
@export var up_action    = "p1_up"
@export var down_action  = "p1_down"
@export var dash_action = "p1_dash"
@export var punch_action = "p1_H"
@export var kick_action  = "p1_L"

# =========================
# SETTINGS
# =========================

@export var buffer_time := 0.7
@export var deadzone := 0.2
@export var enabled := true
var body

# =========================
# STORAGE
# =========================

var input_buffer = []
var time_buffer = []
var input_history = []
var history_limit = 25
var last_dir = "5"
var prev_dir = "5"
# =========================
# MAIN LOOP
# =========================

func _physics_process(_delta):
	if not enabled:
		return
	var dir = get_direction()

	prev_dir = last_dir
	last_dir = dir

	if dir != prev_dir:
		add_input(dir)
		add_history(dir)
	

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
		add_button_to_last_input("H")

	if Input.is_action_just_pressed(kick_action):
		add_input("L")
		add_button_to_last_input("L")

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

	var p = 0
	for i in recent:
		if i == pattern[p]:
			p += 1
			if p >= pattern.size():
				return true

	return false
func consume_combo():
	clear_buffer()
	last_dir = "5"
func clear_buffer():
	input_buffer.clear()
	time_buffer.clear()
func parse_move():

	# highest priority first

	# Dragon Punch Punch
	if check_combo(["6","2","3","H"]) \
	or check_combo(["6","3","H"]):
		return "dp_h"

	# Fireball Punch
	if check_combo(["2","3","6","H"]) \
	or check_combo(["2","6","H"]) \
	or check_combo(["3","6","H"]):
		return "qcf_h"

	# Fireball Kick
	if check_combo(["2","3","6","L"]) \
	or check_combo(["2","6","L"]):
		return "qcf_l"

	# normals
	if check_combo(["H"]):
		return "normal_h"

	if check_combo(["L"]):
		return "normal_l"

	return ""
func has_move():

	return parse_move() != ""
func add_history(dir, btn = ""):

	input_history.append({
		"dir": dir,
		"button": btn
	})

	if input_history.size() > history_limit:
		input_history.pop_front()
func add_button_to_last_input(btn):

	if input_history.is_empty():
		add_history("5", btn)
		return

	input_history[-1]["button"] = btn
