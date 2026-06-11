extends Node

var fighter
var current_state : State

func start(body):
	fighter = body

	for child in get_children():
		if child is State:
			child.fighter = fighter
			child.machine = self

	change_state("Idle")

func physics_update(delta):
	if current_state:
		current_state.physics_update(delta)

func change_state(Name):
	var old_state = "None"
	if current_state:
		old_state = current_state.name
		current_state.exit()
	print(fighter.name, ": ", old_state, " -> ", Name)
	current_state = get_node(Name)
	current_state.enter()
	
