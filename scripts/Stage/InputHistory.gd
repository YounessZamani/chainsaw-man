extends RichTextLabel

@export var fighter : Fighter

func _physics_process(_delta):

	if fighter == null:
		return

	text = ""

	for i in range(fighter.buffer.input_history.size() - 1, -1, -1):

		var entry = fighter.buffer.input_history[i]

		var dir = convert_input(entry["dir"])
		var btn = convert_input(entry["button"])

		text += dir

		if btn != "":
			text += "\t" + btn

		text += "\n"

func convert_input(i):

	match i:
		"1": return "↙"
		"2": return "↓"
		"3": return "↘"
		"4": return "←"
		"5": return "•"
		"6": return "→"
		"7": return "↖"
		"8": return "↑"
		"9": return "↗"
		"H": return "P"
		"L": return "K"

	return i
