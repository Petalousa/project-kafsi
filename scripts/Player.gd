extends MeshInstance

const bullet = preload("res://scenes/Bullet.tscn")
const explosion_template = preload("res://scenes/Explosion.tscn")
const player_explosion = preload("res://scenes/ExplosionPlayer.tscn")

var globals
var health
var shoot_timer
var is_dead

# how much the ship tilts when moving left/right
var bank_degrees = 20.0

var active_powerups = {
	"spotlight" : 0.0,
	"tri_shot" : 0.0,
	"multi_bullets" : 0.0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	globals = get_node("/root/Autoload")
	$SpotLight.visible = false
	
	is_dead = false
	shoot_timer = 0
	health = 100
	get_tree().call_group("ui", "update_hp", health)

func add_score(var score_to_add):
	globals.score += score_to_add
	get_tree().call_group("ui", "update_score", globals.score)
	
func take_damage(var damage):
	health -= damage
	get_tree().call_group("ui", "update_hp", health)

func gain_hp(var hp):
	health += hp
	if health > 100:
		health = 100
	get_tree().call_group("ui", "update_hp", health)

func _physics_process(delta):
	if is_dead:
		return
	
	if health <= 0:
		is_dead = true
		_explode()
		return
	
	rotation_degrees.z = 0.0
	
	var dir = Vector3()
	
	if Input.is_action_pressed("Up"):
		dir.z = 1
	elif Input.is_action_pressed("Down"):
		dir.z = -1
	if Input.is_action_pressed("Left"):
		dir.x = 1
		rotation_degrees.z = -bank_degrees
	elif Input.is_action_pressed("Right"):
		dir.x = -1
		rotation_degrees.z = bank_degrees

	if Input.is_action_just_pressed("Fire"):
		_fire()
			
	if Input.is_action_pressed("Fire"):
		if shoot_timer <= 0.0:
			_fire()
	
	shoot_timer -= delta

	dir = dir.normalized()
	
	translate(dir * 0.3)
	transform.origin.y = 5.0
	
	_check_powerups(delta)
	_force_bounds()

# checks if powerups are active and applies effects
func _check_powerups(delta):
	if active_powerups["spotlight"] > 0.0:
		$SpotLight.visible = true
		active_powerups["spotlight"] -= delta
	else:
		$SpotLight.visible = false
		
	if active_powerups["tri_shot"] > 0.0:
		active_powerups["tri_shot"] -= delta
	if active_powerups["multi_bullets"] > 0.0:
		active_powerups["multi_bullets"] -= delta


func _explode():
	var effect = player_explosion.instance()
	effect.transform.origin = transform.origin
	scale = Vector3(0.0, 0.0, 0.0)
	get_tree().get_root().call_deferred("add_child", effect)
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://scenes/Death.tscn")

func _force_bounds():
	var left_bound = 14.0
	var right_bound = -14.0
	var bot_bound = -1.0
	var top_bound = 10.0
	
	var new_pos = transform.origin
	if transform.origin.x > left_bound:
		new_pos.x = left_bound
	if transform.origin.x < right_bound:
		new_pos.x = right_bound
	if transform.origin.z < bot_bound:
		new_pos.z = bot_bound
	if transform.origin.z > top_bound:
		new_pos.z = top_bound
		
	transform.origin = new_pos
	
func _create_bullet_at(var rel_position, rot=0.0):
	var bullet_instance = bullet.instance()
	bullet_instance.transform.origin = transform.origin + rel_position
	bullet_instance.creator = self
	bullet_instance.set_group("player")
	bullet_instance.rotate_y(rot)
	
	get_tree().get_root().call_deferred("add_child", bullet_instance)


func _fire():
	var has_powerup = false
	if active_powerups["tri_shot"] > 0.0:
		_create_bullet_at(Vector3(0.0, 0.0, 0.0), -0.3)
		_create_bullet_at(Vector3(0.0, 0.0, 0.0))
		_create_bullet_at(Vector3(0.0, 0.0, 0.0), 0.3)
		has_powerup = true
	
	if active_powerups["multi_bullets"] > 0.0:
		_create_bullet_at(Vector3(-0.5, 0.0, 0.0))
		_create_bullet_at(Vector3(0.5, 0.0, 0.0))
		has_powerup = true
		
		
	shoot_timer = globals.shot_speed - globals.time_elapsed * 0.0005
	if (!has_powerup):
		_create_bullet_at(Vector3(0.0, 0.0, 0.0))
	else:
		shoot_timer *= 0.7
	
	get_tree().call_group("audio", "play_random_shot")


func _apply_powerup(powerup_type):
	match powerup_type:
		globals.Powerups.HP:
			gain_hp(5)
		globals.Powerups.LIGHT:
			active_powerups["spotlight"] += 10.0
		globals.Powerups.MULTI_SHOT:
			active_powerups["multi_bullets"] += 5.0
		globals.Powerups.TRI_SHOT:
			active_powerups["tri_shot"] += 4.0

func _on_Area_area_entered(area):
	if (area.is_in_group("enemy")):
		if (area.is_in_group("bullet")):
			take_damage(area.get_parent().damage)
			area.get_parent().hit_enemy()
	if (area.is_in_group("powerup")):
		_apply_powerup(area.get_parent().powerup_type)
		area.get_parent().die()
		
