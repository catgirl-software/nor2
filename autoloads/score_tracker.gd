extends Node

class Player:
	var frame: int
	var input: I.InputType
	var team: int
	var kills: Array[int]
	func _init(f: int, t: int, i: I.InputType):
		frame = f
		team = t
		input = i

var players: Dictionary

var scores : Dictionary
#var scores_this_round : Array[Array]
var threshold : int
var winner : int = 0

signal game_over(winner: int)

func reset(threshold: int = 10):
	scores.clear()
	winner = 0
	self.threshold = threshold
	
func add_player(input: I.InputType, frame: int):
	players[frame] = Player.new(frame, frame, input) # todo

func score(killer: int, victim: int):
	players[killer].kills.append(victim)

	if len(players[killer].kills) >= threshold:
		winner = killer

func get_scores():
	return scores

func get_players():
	return players.values()
