extends PanelContainer
class_name Int_ScoreBox

@export var scoring_sprite : Texture2D

var score_disc_scene : PackedScene = preload("res://scenes/component_scenes/ScoreDisc.tscn")

func init(player_name : String, scores : Array):
	
	# Let's be colourful
	var theme_name : String = "PanelContainer"
	match player_name:
		"Player 1": theme_name += "Green"
		"Player 2": theme_name += "Orange"
		"Player 3": theme_name += "Blue"
		"Player 4": theme_name += "Purple"
		_:
			print("Unexpected player_name: ", player_name)
	
	print("Setting theme variation to " + theme_name)
	set_theme_type_variation(theme_name)
	
	$HBoxContainer/CenterContainer/NameLabel.text = player_name
	$HBoxContainer/CenterContainer/KillsLabel.text = "Kills: " + str(len(scores))
	print("Init scorebox for player ", player_name, " scores:", scores)
	for score in scores:
		print("loop!")
		var new_node = score_disc_scene.instantiate()
		new_node.init(score)
		$HBoxContainer/ScoreContainer.add_child(new_node)
