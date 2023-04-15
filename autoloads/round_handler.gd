extends Node

@onready var intermission = preload("res://scenes/game_scenes/intermission.tscn")
@onready var level = preload("res://scenes/game_scenes/map1.tscn")

var round : int

func start():
	round = 0
	go_to_intermission()

func get_round_number():
	return round

func go_to_intermission():
	round += 1
	get_tree().change_scene_to_packed(intermission)

func go_to_level():
	get_tree().change_scene_to_packed(intermission)
