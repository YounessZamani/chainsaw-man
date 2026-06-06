extends GridContainer

@onready var Damage = $"Damage value"
@onready var Combo_Damage = $"Combo damage value"
@onready var Max_Damage = $"Max combo damage value"
@onready var Startup = $"Attack Startup value"
@onready var Advantage = $"Frame advantage value"

@export var fighter : Fighter

var opp : Fighter

var dmg := 0
var combo := 0
var max_combo := 0
var startup := 0
var advantage := 0

var last_combo_hits := 0
var last_health := 100


func _ready():

	if fighter == null:
		push_error("No fighter assigned to MoveDataDisplay")
		return

	fighter.find_opponent()
	opp = fighter.opponent

	if opp:
		last_health = opp.health


func _process(_delta):

	if fighter == null or opp == null:
		return

	update_damage()
	update_combo()
	update_startup()
	update_advantage()
	update_labels()


func update_labels():

	Damage.text = str(dmg)
	Combo_Damage.text = str(combo)
	Max_Damage.text = str(max_combo)
	Startup.text = str(startup)

	if advantage > 0:
		Advantage.text = "+" + str(advantage)
	else:
		Advantage.text = str(advantage)


func update_damage():

	var current_health = opp.health

	if current_health < last_health:
		dmg = last_health - current_health

	last_health = current_health


func update_combo():

	if opp.combo_hits > last_combo_hits:

		combo += dmg

		last_combo_hits = opp.combo_hits

		if combo > max_combo:
			max_combo = combo

	# combo ended
	if opp.combo_hits == 0 and last_combo_hits > 0:

		combo = 0
		last_combo_hits = 0


func update_startup():

	if fighter.current_move_data.is_empty():
		startup = 0
		return

	startup = fighter.startup_frame


func update_advantage():

	if fighter.current_move_data.is_empty():
		advantage = 0
		return

	var move = fighter.current_move_data

	if !move.has("stun"):
		advantage = 0
		return

	var recovery_frames = move["recovery"] - move["active"]
	var active_frames = move["active"] -move["startup"]
	var active_left = active_frames - fighter.hit_frame
	var total_recovery = recovery_frames + active_left
	if fighter.attack_connected:

		advantage = move["stun"] - total_recovery

	elif fighter.attack_blocked:

		advantage = int(move["stun"] / 2) - total_recovery

	else:

		advantage = -1* total_recovery
