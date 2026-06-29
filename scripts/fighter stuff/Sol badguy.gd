extends Fighter


func load_moves():

	var file = FileAccess.open("res://JSON DATA/Sol.json", FileAccess.READ)

	if file == null:
		push_error("Failed to load moves.json")
		return

	var text = file.get_as_text()

	var json = JSON.new()

	var result = json.parse(text)

	if result != OK:
		push_error("JSON parse failed")
		return

	moves = json.data

# Get the gravity from the project settings to be synced with RigidBody nodes.

