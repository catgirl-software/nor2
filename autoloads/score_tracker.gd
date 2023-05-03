extends Node

var scores : Dictionary
#var scores_this_round : Array[Array]
var threshold : int
var winner : int = 0

signal game_over(winner: int)

func initialise(teams: Array[int], threshold: int = 10):
	scores.clear()
	winner = 0
	#scores_this_round.clear()
	for team in teams:
		scores[team] = []
	self.threshold = threshold

func score(killer: int, victim: int):
	scores[killer].append(victim)
	if len(scores[killer]) >= threshold:
		winner = killer

func get_scores():
	return scores

func get_teams():
	return scores.keys()
