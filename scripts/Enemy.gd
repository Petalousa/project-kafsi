extends MeshInstance
const explosion_template = preload("res://scenes/Explosion.tscn")
const bullet = preload("res://scenes/Bullet.tscn")
const powerup = preload("res://scenes/Powerup.tscn")

var globals

enum e_state {SPAWNING, ALIVE, DYING, DEAD}
var state

var bullet_timer = 0.0
# mix, max times before enemy will fire a bullet
var fire_min = -1.0
var fire_max = 7.0

var desired_scale = 0.7

var hp_max = 1
var hp
var score = 25
var speed
var powerup_chance = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	globals = get_node("/root/Autoload")
	state = e_state.SPAWNING
	scale =  Vector3(0.1, 0.1, 0.1)
	_reset_bullet_timer()
	transform.origin = get_rand_spawn()
	hp = hp_max
	speed = 1.3 + globals.time_elapsed * 0.01

func _reset_bullet_timer():
	bullet_timer = randf() * (fire_max - fire_min) + fire_min

# called while in the SPAWNING state
func _while_spawning(delta):
	scale += delta * Vector3(1.0, 1.0, 1.0)
	if scale.x > desired_scale: # enemy has grown and finished spawning
		scale = Vector3(desired_scale, desired_scale, desired_scale)
		state = e_state.ALIVE

# called while in the ALIVE state
func _while_alive(delta):
	transform.origin -= Vector3(0.0, 0.0, 0.1 * speed) # move
		
	$OmniLight.light_energy = 1.0 * (1.0 - (float(hp)/float(hp_max)))
	
	if fire_min > 0:
		bullet_timer -= delta # fire bullet on timer
		if bullet_timer <= 0.0:
			_reset_bullet_timer()
			_fire()

# called while in the DYING state
func _while_dying(delta):
	scale -= 3.0 * delta * Vector3(1.0, 1.0, 1.0)
	if scale.x < 0.0:
		scale = Vector3(0.0, 0.0, 0.0)

# loop to top of screen once past player
func _past_player(delta):
	transform.origin = get_rand_spawn()

# main process loop
func _process(delta):
	if state == e_state.SPAWNING:
		_while_spawning(delta)
	elif state == e_state.ALIVE:
		_while_alive(delta)
	elif state == e_state.DYING:
		_while_dying(delta)

	if (transform.origin.z < globals.bot_bound):
		_past_player(delta)


func get_rand_spawn():
	var lbound = globals.left_spawn_bound
	var rbound = globals.right_spawn_bound
	
	# pick random x between left and right bounds
	var rand_x = ((lbound - rbound) * randf()) + rbound
	return Vector3(rand_x, 5.0, globals.top_bound)

func _fire():
	var bullet_instance = bullet.instance()
	bullet_instance.transform.origin = transform.origin #+ Vector3(0.1, 0.0, 0.4)
	bullet_instance.creator = self
	bullet_instance.set_group("enemy")
	bullet_instance.set_color(Color(1.0, 0.0, 0.0), 0.2)
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	get_tree().call_group("audio", "play_random_shot")

func _take_damage(dmg):
	hp -= dmg
	if hp <= 0:
		explode()
		get_tree().call_group("player", "add_score", score)
		if (randf() < powerup_chance):
			_drop_powerup()

func _on_Area_area_entered(area):
	if state == e_state.ALIVE:
		if (area.is_in_group("player")):
			if (area.is_in_group("bullet")):
				area.get_parent().hit_enemy()
				_take_damage(area.get_parent().damage)
			else:
				get_tree().call_group("player", "take_damage", hp)
				explode()

func _drop_powerup():
	var p = powerup.instance()
	p.transform.origin = transform.origin
	get_tree().get_root().call_deferred("add_child", p)

func _die():
	queue_free()

func explode():
	get_tree().call_group("audio", "play_random_hit")
	state = e_state.DYING
	var explosion = explosion_template.instance()
	explosion.transform = self.transform
	get_tree().get_root().call_deferred("add_child", explosion)
	yield(get_tree().create_timer(0.5), "timeout")
	_die()

# when game is reset, active enemies should vanish
func reset():
	queue_free()
