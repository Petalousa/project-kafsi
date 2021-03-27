extends OmniLight


export var start_color = Color()
export var end_color = Color()
export var max_time = 0.5
export var explosion_size = 10.0


var current_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Particles.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_time += delta
	
	if current_time > max_time:
		current_time = max_time
		queue_free()
	
	light_energy = lerp(1.0, explosion_size, current_time/max_time)
	light_color = lerp(start_color, end_color, current_time/max_time)

# when game is reset, active effects should vanish
func reset():
	queue_free()
