extends Control

const game_scene = preload("res://scenes/Game.tscn")

var globals

# updates score
func _ready():
	globals = get_node("/root/Autoload")
	$ScoreLabel.text = str(globals.score)

# restarts game
func _on_RestartButton_pressed():
	get_tree().change_scene_to(game_scene)

# quits game on 'quit' button press
func _on_QuitButton_pressed():
	get_tree().quit()
