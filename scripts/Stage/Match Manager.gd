extends Node

@onready var p1 =$"../player 1"
@onready var p2 =$"../Sol Badguy"
@onready var win = $"../Ui layers/WIN text"
@onready var butt =$"../Ui layers/restart button"
@onready var audio = $"../AudioStreamPlayer"
@onready var pause = $"../Pause"
const  COUNTER =preload("res://SOUND/SFX/counter.mp3")
const  START = preload("res://SOUND/SFX/fight start.mp3")
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
	play_sound(START)

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
	update_counter()
	update_pause()
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
func play_sound(audio_stream: AudioStream):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = audio_stream
	player.play()
	
	# Clean up the node when the sound finishes playing
	await player.finished
	player.queue_free()
func update_counter():
	if p1.countered or p2.countered :
		play_sound(COUNTER)
		p1.countered= false
		p2.countered= false
func update_pause():
	if Input.is_action_pressed("pause"):
		get_tree().paused = true
		pause.visible = true
