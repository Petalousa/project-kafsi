extends MeshInstance


var globals

# Called when the node enters the scene tree for the first time.
func _ready():
	globals = get_node("/root/Autoload")
	


func _process(delta):
	transform.origin.z -= globals.scroll_speed

	# loop to top of screen once past player
	if (transform.origin.z < globals.bot_bound):
		var new_pos = transform.origin
		new_pos.z = globals.top_bound
		transform.origin = new_pos

