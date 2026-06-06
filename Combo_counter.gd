extends Label

@export var fighter: Fighter
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = str(fighter.combo_hits)
	visible = fighter.combo_hits> 0
