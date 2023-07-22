extends Node

signal GiveDisc(team: int)

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
var kills_this_round = 0
var scores : Dictionary
#var scores_this_round : Array[Array]
var threshold : int
var winner : int = 0

signal game_over(winner: int)

func reset(threshold: int = 5):
	players = {}
	scores.clear()
	kills_this_round = 0
	winner = 0
	self.threshold = threshold
	
func add_player(input: I.InputType, frame: int):
	players[frame] = Player.new(frame, frame, input) # todo

func score(killer: int, victim: int):

	players[killer].kills.append(victim)

	if len(players[killer].kills) >= threshold:
		winner = killer

func on_kill():
	kills_this_round += 1	
	print(str(kills_this_round) + " kills out of " + str(len(players.keys()) - 1))
	if kills_this_round == len(players.keys()) - 1:
		RoundHandler.go_to_intermission()

func next_round():
	kills_this_round = 0

func get_scores():
	return scores

func get_players():
	return players.values()
