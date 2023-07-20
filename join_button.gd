extends Control

@export var input: I.InputType
@export_node_path var root_node

@export var starting_team : int

var pressed: bool = false

var joined: bool = false
var team : int
var confirmed: bool = false

var input_enabled = true

func disable_input():
	input_enabled = false
	print("disabled input")

func _ready():
	root_node = get_node(root_node)
	$Panel.visible = false
	team = starting_team
	$Panel/HBoxContainer/CenterContainer/disc.frame = team

func _process(delta):
	if !input_enabled:
		return

	var aim = I.get_move_direction(input)
	var confirm = I.get_confirm(input)
	var leave = I.get_leave(input)

	var pressing = aim.length() > 0.3 || confirm || leave

	if pressed:
		pressed = pressing
		return
	pressed = pressing
		
	if !joined:
		if pressing:
			return join()
	else:
		if leave:
			if confirmed:
				return unconfirm()
			else:
				return leave()
		if confirm:
			return confirm()
		if aim.x < -0.3:
			return down()
		if aim.x > 0.3:
			return up()

func join():
	joined = true
	$Panel.visible = true
	$Button.visible = false
	root_node.join()

func leave():
	joined = false
	$Panel.visible = false
	$Button.visible = true
	root_node.leave()

func up():
	if confirmed:
		return
	team = root_node.next_colour(team, 1)
	$Panel/HBoxContainer/CenterContainer/disc.frame = team

func down():
	if confirmed:
		return
	team = root_node.next_colour(team, -1)
	$Panel/HBoxContainer/CenterContainer/disc.frame = team

func confirm():
	if root_node.try_lock_in(team):
		$Panel/HBoxContainer/CenterContainer/ColorRect.color = Color.BLACK
		confirmed = true
	root_node.on_lock_in()

func unconfirm():
	$Panel/HBoxContainer/CenterContainer/ColorRect.color = Color.WHITE
	confirmed = false
	root_node.lock_out(team)
