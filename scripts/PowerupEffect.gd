extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	$Particles.emitting = true
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
