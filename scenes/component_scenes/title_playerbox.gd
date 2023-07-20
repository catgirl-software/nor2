extends PanelContainer

@export var starting_team : int
var team : int

func _ready():
	team = starting_team
	$HBoxContainer/CenterContainer/disc.frame = team
	
func up():
	team += 1
	if team > 4:
		team = 1
	$HBoxContainer/CenterContainer/disc.frame = team

func down():
	team -= 1
	if team < 1:
		team = 4
	$HBoxContainer/CenterContainer/disc.frame = team
