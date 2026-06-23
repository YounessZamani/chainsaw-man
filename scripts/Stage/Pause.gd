extends Control

@onready var pages = $"Panel/MarginContainer/HBoxContainer/option pages"
@onready var audio = $"../AudioStreamPlayer"
@onready var music_option = $"Panel/MarginContainer/HBoxContainer/option pages/Music/option 1"
# Called when the node enters the scene tree for the first time.
func _ready():
	clear_pages()# Replace with function body.
	music_option.item_selected.connect(_on_option_1_item_selected)

	print("connected")

# Called every frdadadadame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		


func _on_music_pressed():
	show_page("Music") # Replace with function body.


func _on_sound_pressed():
	show_page("Sound") # Replace with function body.


func _on_display_pressed():
	show_page("Display") # Replace with function body.

func show_page(page):
	clear_pages()
	for i in pages.get_children():
		if page == i.name:
			i.visible = true
	
func clear_pages():
	for i in pages.get_children():
		i.visible = false


func _on_option_1_item_selected(index):
	audio.pick = index 
	audio.update_song()
	print("you picke did :", index)# Replace with function body.


func _on_resume_pressed():
	get_tree().paused = false
	visible = false # Replace with function body.
