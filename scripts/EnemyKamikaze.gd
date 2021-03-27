extends "res://scripts/Enemy.gd"

var spawn_z = 20.0

export var charge_colour = Color.red
export var attack_colour = Color.red

var player_pos = Vector3(0.0, 0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	hp_max = 7
	hp = hp_max
	score = 500
	speed = 9.0
	desired_scale = 1.0
	powerup_chance = 0.22

func _while_alive(delta):
	if transform.origin.z > spawn_z:
		# increase size depending on hp
		var new_scale = 1.0 + (1.0 - float(hp)/float(hp_max))
		new_scale = new_scale * desired_scale * 0.75
		
		scale = Vector3(new_scale, new_scale, new_scale)
		
		# reset spin
		var new_rotation = rotation_degrees
		new_rotation.z = 0
		rotation_degrees = new_rotation
		
		var pre_attack_speed = 0.02 * (transform.origin.z - spawn_z)
		pre_attack_speed *= globals.time_elapsed * 0.05
		# move to position
		transform.origin -= Vector3(0.0, 0.0, 0.01 + pre_attack_speed)

		# set light power to 5.0 * 1/x
		var d = (transform.origin.z - spawn_z)
		if d == 0:
			d = 0.0001
		# charging light enegry 
		$ChargeLight.light_energy = 5.0 * (1.0/d)
		$ChargeLight.light_color = charge_colour
		
		# attack lights are off
		$AttackLight1.light_energy = 0
		$AttackLight2.light_energy = 0
	else:
		var attack_light_energy = 5.0
		
		# turn attack lights on, set colour to attack colour
		$ChargeLight.light_energy = attack_light_energy
		$AttackLight1.light_energy = attack_light_energy
		$AttackLight2.light_energy = attack_light_energy
		
		$ChargeLight.light_color = attack_colour
		$AttackLight1.light_color = attack_colour
		$AttackLight2.light_color = attack_colour
		
		
		transform.origin -= Vector3(0.0, 0.0, 0.1 * speed)
		
		# spin
		var new_rotation = rotation_degrees
		new_rotation.z += delta * 1024.0
		rotation_degrees = new_rotation

# hide ship
func _while_dying(delta):
	scale = Vector3(0.01, 0.01, 0.01)

# turn off lights when past player
func _past_player(delta):
	
	$ChargeLight.light_energy = 0
	$AttackLight1.light_energy = 0
	$AttackLight2.light_energy = 0
	
	._past_player(delta)
