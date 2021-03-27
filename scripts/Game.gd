extends Spatial

const basic_enemy = preload("res://scenes/EnemyDefault.tscn")
const big_enemy = preload("res://scenes/EnemyHeavy.tscn")
const kamikaze_enemy = preload("res://scenes/EnemyKamikaze.tscn")

var globals
var default_enemy_timer
var enemy_delay
var kamikaze_enemy_timer
var kamikaze_delay
var heavy_chance
var max_heavy_chance

# Called when the game starts
func _ready():
	globals = get_node("/root/Autoload")
	globals.score = 0
	globals.time_elapsed = 0
	randomize()
	
	default_enemy_timer = 0.0
	enemy_delay = 0.5
	kamikaze_enemy_timer = 0.0
	kamikaze_delay = 4
	heavy_chance = 0.0
	max_heavy_chance = 0.2
	
	# remove active enemies and powerups (cleanup if game has been restarted)
	get_tree().call_group("enemy", "reset")
	get_tree().call_group("powerup", "reset")
	get_tree().call_group("effect", "reset")

func _play_music():
	$MusicPlayer.play()

func _loop_music():
	if ! $MusicPlayer.playing:
		$MusicPlayer.play(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	globals.time_elapsed += delta
	default_enemy_timer -= delta
	kamikaze_enemy_timer -= delta
	
	# spawn enemy every 0.5-1.5 seconds
	# slowly decays to every 0-0.5 seconds 
	if (default_enemy_timer <= 0):
		_spawn_basic_enemy()
		default_enemy_timer = enemy_delay + randf()
		enemy_delay -= 0.01
		if enemy_delay < -0.5:
			enemy_delay = -0.5

	# spawn kamikaze every 4-6 seconds
	# drops down to 1-3 seconds
	if globals.time_elapsed > 20:
		if (kamikaze_enemy_timer <= 0):
			_spawn_kamikaze()
			kamikaze_enemy_timer = kamikaze_delay + 2.0 * randf()
			kamikaze_delay -= 0.2
			if kamikaze_delay < 1.0:
				kamikaze_delay = 1.0

	_loop_music()

# 10% chance to be a heavy enemy
# increases over time to 30%
func _spawn_basic_enemy():
	var enemy
	
	if (randf() > heavy_chance):
		enemy = basic_enemy.instance()
	else:
		enemy = big_enemy.instance()

	heavy_chance += 0.005
	if heavy_chance > max_heavy_chance:
		heavy_chance = max_heavy_chance

	get_tree().get_root().call_deferred("add_child", enemy)
	
func _spawn_kamikaze():
	var enemy = kamikaze_enemy.instance()
	
	var lbound = globals.left_spawn_bound
	var rbound = globals.right_spawn_bound
	
	# pick random x between left and right bounds
	var rand_x = ((lbound - rbound) * randf()) + rbound

	enemy.transform.origin = Vector3(rand_x, 5.0, globals.top_bound)
	get_tree().get_root().call_deferred("add_child", enemy)
	
func _spawn_blocker():
	pass
