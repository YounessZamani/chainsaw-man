extends Area2D
class_name Hurtbox
@onready var fighter : Fighter = get_parent()

var vulnerable := true
var invincible := false

func can_be_hit():

	if !vulnerable:
		return false

	if invincible:
		return false

	return true
