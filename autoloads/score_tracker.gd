extends Node


var scores : Dictionary
var threshold : int

signal game_over(winner: int)

func initialise(teams: Array[int], threshold: int = 10):
	scores.clear()
	for team in teams:
		scores[team] = []
	self.threshold = threshold

func score(killer: int, victim: int):
	scores[killer].append(victim)
	if scores[killer].length() >= threshold:
		game_over.emit(killer)
