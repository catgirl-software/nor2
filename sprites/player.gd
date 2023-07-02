extends CharacterBody2D

enum InputType {
	Mouse,
	Controller1,
	Controller2,
}

@export var input_type: InputType
@export_range(1,4) var team: int = 1

var last_look_direction: Vector2 = Vector2(1, 1)

var has_disc: bool = true
const BACKSWING_LENGTH: float = 1
enum State {
	Ready,
	Throwing,
	Catching,
	CatchingBackswing,
}

var state: State = State.Ready

func get_aim_direction():
	match input_type:
		InputType.Mouse:
			return (get_viewport().get_mouse_position() - self.get_global_transform_with_canvas().origin).normalized()
		InputType.Controller1:
			return Input.get_vector("joystick_aim_1_nx", "joystick_aim_1_px", "joystick_aim_1_ny", "joystick_aim_1_py")
		InputType.Controller2:
			return Input.get_vector("joystick_aim_2_nx", "joystick_aim_2_px", "joystick_aim_2_ny", "joystick_aim_2_py")
		_:
			print("BAD INPUT TYPE: ", self.input_type)
			return Vector2(0, 0)

func get_move_direction():
	match input_type:
		InputType.Mouse:
			return Input.get_vector("keyboard_left", "keyboard_right", "keyboard_up", "keyboard_down")
		InputType.Controller1:
			return Input.get_vector("joystick_move_1_nx", "joystick_move_1_px", "joystick_move_1_ny", "joystick_move_1_py")
		InputType.Controller2:
			return Input.get_vector("joystick_move_2_nx", "joystick_move_2_px", "joystick_move_2_ny", "joystick_move_2_py")
		_:
			print("BAD INPUT TYPE: ", self.input_type)
			return Vector2(0, 0)

func get_throwing():
	match input_type:
		InputType.Mouse:
			return Input.is_action_just_pressed("keyboard_throw")
		InputType.Controller1:
			return Input.is_action_just_pressed("joystick_1_throw")
		InputType.Controller2:
			return Input.is_action_just_pressed("joystick_2_throw")
		_:
			print("BAD INPUT TYPE: ", self.input_type)
			return false

func _ready():
	# oh boy i hope keys() is stable ordered
	team = ScoreTracker.get_teams()[team - 1]
	$Sprite2D.frame = team
	$Arm.frame = team
	$Arm/disc.frame = team

func _physics_process(delta):
	var aim_direction = get_aim_direction()
	var move_direction = get_move_direction()
	if aim_direction.length():
		last_look_direction = aim_direction
	elif move_direction.length():
		last_look_direction = move_direction

	var throwing = get_throwing()

	self.look_at(self.position + last_look_direction)
	self.move_and_collide(move_direction.normalized() * 100 * delta)

	if throwing and state == State.Ready:
		if has_disc:
			print("throwing")
			try_throw()
		else:
			print("catching")
			try_catch()

func try_throw():
	DiscManager.new_disc(team, last_look_direction, position + last_look_direction.normalized() * 20)
	state = State.Throwing
	has_disc = false
	$Arm/disc.visible = true
	$AnimationPlayer.play("throw")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.stop()
	$Arm/disc.visible = false
	print("stopped")
	state = State.Ready

func try_catch():
	state = State.Catching
	$AnimationPlayer.play("throw")
	print("catching, ", $Arm/disc.visible)
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.stop()
	if state == State.Catching:
		state = State.CatchingBackswing
		await get_tree().create_timer(BACKSWING_LENGTH).timeout
		state = State.Ready

func die(killing_team: int):
	print("dead")
	if killing_team != team:
		ScoreTracker.score(killing_team, team)
	RoundHandler.go_to_intermission()
	queue_free()
	
func on_ball_collide(disc: Disc, _col: KinematicCollision2D) -> bool:
	if state == State.Catching:
		state = State.Ready
		has_disc = true
		return true
	die(disc.team)
	return false
