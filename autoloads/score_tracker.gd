extends Node

var scores : Dictionary
#var scores_this_round : Array[Array]
var threshold : int

signal game_over(winner: int)

func initialise(teams: Array[int], threshold: int = 10):
	scores.clear()
	#scores_this_round.clear()
	for team in teams:
		scores[team] = []
	self.threshold = threshold

func score(killer: int, victim: int):
	scores[killer].append(victim)

func get_scores():
	return scores

func get_teams():
	return scores.keys()
