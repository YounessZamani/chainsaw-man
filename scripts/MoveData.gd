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
var last_combo_hits =0
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
	if !opp.is_in_state("Hitstun"):

		opp.combo_hits = 0
		last_combo_hits = 0
		combo = 0

func update_startup():

	if fighter.current_move_data == null:
		return

	var move_data = fighter.current_move_data

	if move_data.has("startup"):
		startup = move_data["startup"]

func update_advantage():

	if fighter.current_move_data == null:
		return

	var move_data = fighter.current_move_data

	if !move_data.has("recovery"):
		return

	var recovery = move_data["recovery"]

	# assuming hitstun_time/blockstun_time are stored in FRAMES

	if opp.is_in_state("Hitstun"):

		advantage = opp.hitstun_time/60 - recovery

	elif opp.is_in_state("Block"):

		advantage = opp.blockstun_time/60 - recovery

	else:

		advantage = 0
