extends HBoxContainer
class_name Int_ScoreBox

@export var scoring_sprite : Texture2D

func init(player_name : String, scores : Array):
	$CenterContainer/NameLabel.text = player_name
	print("Init scorebox for player ", player_name, " scores:", scores)
	for score in scores:
		print("loop!")
		var new_node = Sprite2D.new()
		new_node.texture = scoring_sprite
		new_node.vframes = 5
		new_node.frame = score
		new_node.scale = Vector2(2,2)
		var int_child = Control.new()
		int_child.add_child(new_node)
		add_child(int_child)
