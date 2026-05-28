extends Node

@onready var p1 =$"../player"
@onready var p2 =$"../fighter"
@onready var win = $"../Ui layers/WIN text"
@onready var butt =$"../Ui layers/restart button"
var p1_initial_health 
var p2_initial_health 
var p1_initial_position
var p2_initial_position 
var game_over = false 
# Called when the node enters the scene tree for the first time.
func _ready():
	p1_initial_health = p1.health
	p2_initial_health = p2.health
	p1_initial_position = p1.position
	p2_initial_position = p2.position
	butt.visible = false 
	butt.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_over == true:
		return
	if p1.health <= 0:
		win.text = "Player 2 wins"
		show_butt()
		game_over = true
	if p2.health <= 0:
		win.text = "Player 1 wins"
		show_butt()
		game_over = true
func reset_health():
	p1.health = p1_initial_health
	p2.health = p2_initial_health
func reset_position():
	p1.position = p1_initial_position
	p2.position = p2_initial_position
func _on_restart_button_pressed():
	print("RESET CLICKED")
	print("Before reset p1:", p1.health, "p2:", p2.health)

	reset_health()
	reset_position()

	print("After reset p1:", p1.health, "p2:", p2.health)

	hide_butt()
	win.text = ""
	game_over = false
func show_butt():
	butt.visible = true
	butt.disabled = false
func hide_butt():
	butt.disabled = true
	butt.visible = false
