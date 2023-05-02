extends VBoxContainer
class_name Int_ScoreContainer

var scorebox = preload("res://scenes/component_scenes/Int_ScoreBox.tscn")

func _ready():
	var scores = ScoreTracker.get_scores()
	
	for score_set in scores:
		var node = scorebox.instantiate()
		print("Spawning scorebox for player ", score_set, " scores:", scores[score_set])
		(node as Int_ScoreBox).init("Player " + str(score_set), scores[score_set])
		add_child(node)
