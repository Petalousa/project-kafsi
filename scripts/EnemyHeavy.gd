extends "res://scripts/Enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	hp_max = 5
	hp = hp_max
	score = 200
	speed = 0.9 + globals.time_elapsed * 0.005
	desired_scale = 1.0
	fire_min = 3.0
	fire_max = 7.0
	powerup_chance = 0.12
