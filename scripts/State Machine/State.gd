extends Node
class_name State

var fighter
var machine

func enter():
	pass

func exit():
	pass

func physics_update(_delta):
	pass

func try_attack():

	var move_name = fighter.get_move_from_input()

	if move_name != "":
		fighter.current_move = move_name

		var move_data = fighter.get_move_data_by_name(move_name)
		fighter.current_move_data = move_data

		if move_data["attack_type"] == "throw":
			machine.change_state("Throw_Startup")
		else:
			machine.change_state("Attack_Startup")

		return true

	return false
func can_cancel_into(next_move):

	var cancel_data = fighter.current_move_data.get("cancel", {})
	var allowed = cancel_data.get("cancel_into", [])

	return next_move["type"] in allowed
func try_cancel():

	var move = fighter.get_move_from_input()

	if move == "":
		return false

	var next_move = fighter.get_move_data_by_name(move)

	if next_move == null:
		return false
	var cancel = fighter.current_move_data.get("cancel", {})
	var allowed_by_state = false

	if fighter.attack_connected and cancel["on_hit"]:
		allowed_by_state = true
	elif fighter.attack_blocked and cancel["on_block"]:
		allowed_by_state = true
	elif !fighter.attack_connected and !fighter.attack_blocked and cancel["on_whiff"]:
		allowed_by_state = true

	if !allowed_by_state:
		return false
	if !can_cancel_into(next_move):
		return false

	fighter.current_move = move
	fighter.current_move_data = next_move
	print("attack has been canceled")
	print("hit:", fighter.attack_connected,
	  "block:", fighter.attack_blocked)
	machine.change_state("Attack_Startup")

	return true
