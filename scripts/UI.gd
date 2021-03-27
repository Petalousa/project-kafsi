extends Control

var playerHP = 0
var globals

var hp_timer = 0.0
var hp_effect_time = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	globals = get_node("/root/Autoload")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if hp_timer > 0.0:
		hp_timer -= delta
		low_hp_warn()
	else:
		hp_timer = 0.0
		if $PlayerHealth.value < globals.player_health_alert:
			$LowHPWarn.material.set_shader_param("input_color", Vector3(1.0, 0.0, 0.0))
			low_hp_warn()
		else:
			$LowHPWarn.visible = false

func update_hp(new_hp):
	
	# if player loses health or gains hp, briefly flash screen
	if new_hp < $PlayerHealth.value:
		# vignette is red
		$LowHPWarn.material.set_shader_param("input_color", Vector3(1.0, 0.0, 0.0))
		hp_timer = hp_effect_time
	else:
		# green
		$LowHPWarn.material.set_shader_param("input_color", Vector3(0.0, 1.0, 0.0))
		hp_timer = hp_effect_time
	
	$PlayerHealth.value = new_hp
	var color_full = Color.green
	var color_low = Color.red
	var color = lerp(color_low, color_full, new_hp/100.0)
	var fg_style = $PlayerHealth.get_stylebox("fg")
	fg_style.bg_color = color

# update text of score	
func update_score(new_score):
	$TextCentre/Score.text = "Score: " + str(new_score)

	
# modulate opacity of red overlay to show low hp
func low_hp_warn():
	$LowHPWarn.visible = true
	var alpha = (sin(OS.get_ticks_msec() * 0.002) + 2) * 0.5
	$LowHPWarn.material.set_shader_param("alpha", alpha)
