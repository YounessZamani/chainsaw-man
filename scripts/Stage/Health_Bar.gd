extends ProgressBar

@export var fighter : Fighter
var maxhealth
# Called when the node enters the scene tree for the first time.
func _ready():
	maxhealth= fighter.health
	max_value = maxhealth # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	value = fighter.health
