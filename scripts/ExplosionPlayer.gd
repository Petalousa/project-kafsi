extends Spatial



func _ready():
	$Smoke.emitting = true
	$Bits.emitting = true
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
