extends Sprite3D

var globals
var creator = null
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	globals = get_node("/root/Autoload")

# Set the color and power of the light from the laser
func set_color(color, light_energy = 1.0):
	$OmniLight.light_color = color
	$OmniLight.light_energy = light_energy
	modulate = color

func set_group(group_name):
	self.add_to_group(group_name)
	$Area.add_to_group(group_name)

# this function gets called when the bullet hits an enemy
func hit_enemy():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if creator == null:
		queue_free()
	else:
		if (is_in_group("player")):
			translate(Vector3(0.0, 0.0, 0.5))
		if (is_in_group("enemy")):
			translate(Vector3(0.0, 0.0, -0.18))
	
		if (transform.origin.z > globals.top_bound):
			queue_free()
		if (transform.origin.z < globals.bot_bound):
			queue_free()

# when game is reset, active bullets should vanish
func reset():
	queue_free()
