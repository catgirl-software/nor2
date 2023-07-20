extends Node

func _ready():
	var spawns = get_tree().get_nodes_in_group("player_spawn")
	var players = ScoreTracker.get_players()

	print(str(spawns))
	print(str(players))
	print(str(len(spawns)) + " spawns, " + str(len(players)) + " players")
	if len(players) > len(spawns):
		printerr("too many players!!")

	spawns.shuffle()

	for i in range(len(players)):
		var player = preload("res://sprites/player.gd").create(players[i].input, players[i].frame)	
		player.position = spawns[i].position
		add_child(player)
