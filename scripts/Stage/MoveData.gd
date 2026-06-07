extends GridContainer

@onready var Damage = $"Damage value"
@onready var Combo_Damage = $"Combo damage value"
@onready var Max_Damage = $"Max combo damage value"
@onready var Startup = $"Attack Startup value"
@onready var Advantage = $"Frame advantage value"
@onready var total_action = $"total action value"
@export var fighter : Fighter

var opp : Fighter
var counting := false
var dmg := 0
var combo := 0
var max_combo := 0
var startup := 0
var advantage := 0
var action := 0
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
	update_action()
	update_labels()


func update_labels():

	Damage.text = str(dmg)
	Combo_Damage.text = str(combo)
	Max_Damage.text = str(max_combo)
	Startup.text = str(startup)
	total_action.text = str(action)

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
	startup = fighter.startup_frame

func update_action():

	action = fighter.action_frame
func update_advantage():

	# Whiff
	if !fighter.attack_connected and !fighter.attack_blocked:
		advantage = -fighter.action_frame
		counting = false
		return

	var fighter_can_act = fighter.can_act
	var opp_can_act = opp.can_act

	# Both still unable to act
	if !fighter_can_act and !opp_can_act:
		advantage = 0
		counting = false
		return

	# Fighter recovered first
	if fighter_can_act and !opp_can_act:

		if !counting:
			advantage = 1
			counting = true
		else:
			advantage += 1

		return

	# Opponent recovered first
	if !fighter_can_act and opp_can_act:

		if !counting:
			advantage = -1
			counting = true
		else:
			advantage -= 1

		return

	# Both can act -> freeze the final value
	counting = false
	


			
