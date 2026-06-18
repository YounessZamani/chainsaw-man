extends AudioStreamPlayer

var pick = 0
var last_pick = 0
var wants_music = false
const pick1 = preload("res://SOUND/Music/米津玄師「IRIS OUT」(Instrumental).mp3")
const pick2 = preload("res://SOUND/Music/Slam Race - Deltaslam Chapter 2 (Quad City DJs vs. Toby Fox).mp3")
const pick3 = preload("res://SOUND/Music/Hazbin Hotel _ 8-Bit Vox Populi (Lucifers Part) by Sam Haft and Andrew Underberg.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !playing and wants_music:
		play()
func update_song():
	print("changing to song ", pick)
	if last_pick == pick:
		return
	last_pick = pick
	stop()
	match pick:
		0:
			stream = pick1
			wants_music= true
			volume_db = -39.807
		1:
			stream = pick2
			wants_music= true
			volume_db = -30.085
		2:
			stream = pick3
			wants_music= true
			volume_db = -30.085
		3:
			stop()
			wants_music= false
			
	play()
