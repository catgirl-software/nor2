extends Node

func new_disc(team: int, direction: Vector2, position: Vector2):
	var disc = preload("res://disc.tscn").instantiate()
	disc.init(team, direction, position)
	print("create disc")
	add_child(disc)

func new_uninitialised():
	var disc = preload("res://disc.tscn").instantiate()
	add_child(disc)
	return disc
