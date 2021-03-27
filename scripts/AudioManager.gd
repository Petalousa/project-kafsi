extends Node

# audio manager

const hit_sounds = [
	preload("res://audio/hit1.wav"),
	preload("res://audio/hit2.wav"),
	preload("res://audio/hit3.wav"),
	preload("res://audio/hit4.wav")
]
const fire_sounds = [
	preload("res://audio/laser1.wav"),
	preload("res://audio/laser2.wav"),
	preload("res://audio/laser3.wav"),
	preload("res://audio/laser4.wav")
]

const sfx_player = preload("res://scenes/SFXPlayer.tscn")

export var max_audio_players = 64
var audio_players = []

func _ready():
	for _i in range(max_audio_players):
		var p = sfx_player.instance()
		add_child(p);
		audio_players.append(p)		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _play_sfx(sfx):
	for audio_player in audio_players:
		if !audio_player.playing:
			audio_player.stream = sfx
			audio_player.play(0)
			return
	print("unable to play audio")
	return

func play_random_hit():
	var sfx = hit_sounds[randi() % 4]
	_play_sfx(sfx)

func play_random_shot():
	var sfx = fire_sounds[randi() % 4]
	_play_sfx(sfx)
	
