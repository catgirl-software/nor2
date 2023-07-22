extends Node
class_name TeamMarker

@export_range(1,4) var team : int

func _ready():
	if "self_modulate" in get_parent():
		print("setting to index: ", str(team - 1), ", colour: ", str(TeamSettings.team_colours[team-1]))
		get_parent().self_modulate = TeamSettings.team_colours[team-1]
