extends Sprite3D

const sprites = [
	preload("res://sprites/powerup_double.png"),
	preload("res://sprites/powerup_triple.png"),
	preload("res://sprites/powerup_health.png"),
	preload("res://sprites/powerup_light.png")
]

const powerup_get = preload("res://scenes/PowerupEffect.tscn")

var globals
var powerup_type

# Called when the node enters the scene tree for the first time.
func _ready():
	globals = get_node("/root/Autoload")
		
	# pick a random powerup
	powerup_type = globals.Powerups.values()[randi() % globals.num_powerups] 
	# set sprite to correct powerup
	match powerup_type:
		globals.Powerups.HP:
			texture = sprites[2]
		globals.Powerups.LIGHT:
			texture = sprites[3]
		globals.Powerups.MULTI_SHOT:
			texture = sprites[0]
		globals.Powerups.TRI_SHOT:
			texture = sprites[1]

func die():
	var effect = powerup_get.instance()
	effect.transform.origin = transform.origin
	get_tree().get_root().call_deferred("add_child", effect)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector3(0.0, 0.0, 0.08))
	
	if (transform.origin.z < globals.bot_bound):
		queue_free()

# when game is reset, active effects should vanish
func reset():
	queue_free()
