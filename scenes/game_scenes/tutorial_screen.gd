extends Control

func _ready():
	ScoreTracker.get_players()

var ready_players = {}

func _process(delta):
	var players = ScoreTracker.get_players()
	for p in players:
		if I.get_confirm(p.input):
			ready_players[p.input] = true
			if len(ready_players.keys()) == len(players):
				RoundHandler.start()
