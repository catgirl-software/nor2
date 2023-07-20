extends Node

class Player:
	var frame: int
	var input: Enums.InputType
	var team: int
	var kills: Array[int]
	func _init(f: int, t: int):
		frame = f
		team = t

var players: Dictionary

var scores : Dictionary
#var scores_this_round : Array[Array]
var threshold : int
var winner : int = 0

signal game_over(winner: int)

func initialise(p: Array[int], threshold: int = 10):
	scores.clear()
	winner = 0
	#scores_this_round.clear()
	for frame in p:
		players[frame] = Player.new(frame, frame) # todo

	self.threshold = threshold

func score(killer: int, victim: int):
	players[killer].kills.append(victim)

	if len(scores[killer]) >= threshold:
		winner = killer

func get_scores():
	return scores

func get_players():
	return players.values()
