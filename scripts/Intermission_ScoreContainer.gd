extends VBoxContainer
class_name Int_ScoreContainer

var scorebox = preload("res://scenes/component_scenes/Int_ScoreBox.tscn")

func _ready():
	var players = ScoreTracker.get_players()
	
	for player in players:
		var node = scorebox.instantiate()
		#print("Spawning scorebox for player ", score_set, " scores:", scores[score_set])
		(node as Int_ScoreBox).init(get_parent().colour_from_num[player.frame], player.kills)
		add_child(node)
