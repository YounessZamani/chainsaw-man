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

	var move = fighter.get_move_from_input()

	if move != "":
		fighter.current_move = move
		fighter.current_move_data = fighter.get_move_data_by_name(move)
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

	if !can_cancel_into(next_move):
		return false

	fighter.current_move = move
	fighter.current_move_data = next_move
	print("attack has been canceled")
	machine.change_state("Attack_Startup")

	return true
