@tool
extends EditorScript

const OUTPUT_PATH = "res://all_scripts_pretty.txt"
const ROOT = "res://"

var file_list := []

func _run():
	file_list.clear()
	
	var file = FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open output file")
		return
	
	# Step 1: collect files
	_collect_files(ROOT)
	file_list.sort()
	
	# Step 2: write header + index
	file.store_line("GODOT PROJECT SCRIPT EXPORT")
	file.store_line("Generated: " + Time.get_datetime_string_from_system())
	file.store_line("Total scripts: " + str(file_list.size()))
	file.store_line("")
	file.store_line("==== FILE INDEX ====")
	
	for path in file_list:
		file.store_line(path)
	
	file.store_line("\n==== BEGIN FILES ====\n")
	
	# Step 3: write contents
	for path in file_list:
		_write_script(file, path)
	
	file.close()
	print("Pretty export complete → ", OUTPUT_PATH)


func _collect_files(path):
	var dir = DirAccess.open(path)
	if dir == null:
		return
	
	dir.list_dir_begin()
	var name = dir.get_next()
	
	while name != "":
		if dir.current_is_dir():
			if name != "." and name != "..":
				_collect_files(path + "/" + name)
		else:
			if name.ends_with(".gd"):
				file_list.append(path + "/" + name)
		
		name = dir.get_next()
	
	dir.list_dir_end()


func _write_script(file, path):
	var script_file = FileAccess.open(path, FileAccess.READ)
	if script_file == null:
		return
	
	var content = script_file.get_as_text()
	script_file.close()
	
	# Clean up formatting
	content = content.strip_edges()
	
	file.store_line("========================================")
	file.store_line("FILE: " + path.replace(ROOT, ""))
	file.store_line("LINES: " + str(content.split("\n").size()))
	file.store_line("========================================\n")
	
	file.store_line(content)
	file.store_line("\n\n")
