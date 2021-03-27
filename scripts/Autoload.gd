extends Node


# positions of boundary. all interactable entities should be within this section
const left_bound = 14.0
const right_bound = -14.0
const top_bound = 40.0
const bot_bound = -10.0

# spawn bounds for enemies
const left_spawn_bound = 13.5
const right_spawn_bound = -13.5

# when th
const player_health_alert = 10

# how fast the player can shoot
var shot_speed = 0.18

# how fast bg objects scroll
var scroll_speed = 0.05

var score

var num_powerups = 4
enum Powerups {HP, TRI_SHOT, MULTI_SHOT, LIGHT}

var time_elapsed

# Called when the node enters the scene tree for the first time.
func _ready():
	time_elapsed = 0
	score = 0
	print("Global Variables Loaded")
