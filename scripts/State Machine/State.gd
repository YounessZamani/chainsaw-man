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
