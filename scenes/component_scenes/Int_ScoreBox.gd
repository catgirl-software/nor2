extends PanelContainer
class_name Int_ScoreBox

#@export var scoring_sprites : Array[Texture2D]

var score_disc_scene : PackedScene = preload("res://scenes/component_scenes/ScoreDisc.tscn")

func init(player_name : String, scores : Array):
	
	var index: int
	# Let's be colourful
	var theme_name : String = "PanelContainer"
	match player_name:
		"Player 1": 
			theme_name += "Green"
			index = 0
		"Player 2": 
			theme_name += "Orange"
			index = 1
		"Player 3": 
			theme_name += "Blue"
			index = 2
		"Player 4": 
			theme_name += "Purple"
			index = 3
		_:
			print("Unexpected player_name: ", player_name)
	
	print("Setting theme variation to " + theme_name)
	set_theme_type_variation(theme_name)
	
	$HBoxContainer/PanelContainer.self_modulate = TeamSettings.team_colours[index]
	
	$HBoxContainer/CenterContainer/NameLabel.text = player_name
	$HBoxContainer/CenterContainer/KillsLabel.text = "Kills: " + str(len(scores))
	print("Init scorebox for player ", player_name, " scores:", scores)
	for score in scores:
		print("loop!")
		var new_node = score_disc_scene.instantiate()
		new_node.init(score)
		$HBoxContainer/PanelContainer/ScoreContainer.add_child(new_node)
