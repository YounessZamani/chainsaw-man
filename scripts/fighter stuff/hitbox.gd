extends Area2D

signal hit_landed(target, move_data)

var fighter : Fighter
var hit 
func _ready():
	fighter = get_parent()
	disable_all_boxes()
	hit = false
func _physics_process(_delta):
	check_hits()

func check_hits():
	for c in get_children():
	
		if c.disabled:
			continue

		for area in get_overlapping_areas():

			if not area is Hurtbox:
				continue

			var hurtbox : Hurtbox = area

			if !hurtbox.can_be_hit():
				continue

			var enemy = hurtbox.fighter

			# IMPORTANT
			if enemy == fighter:
				continue

			if enemy in fighter.hit_targets:
				continue

			fighter.hit_targets.append(enemy)
			hit = true
			emit_signal(
				"hit_landed",
				enemy,
				fighter.current_move_data
			)
func enable_box(box_name):
	disable_all_boxes()
	get_node(box_name).disabled = false
	get_node(box_name).visible = true
func disable_all_boxes():
	for c in get_children():
		c.disabled = true
		c.visible = false
