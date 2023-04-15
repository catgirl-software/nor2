extends CharacterBody2D

enum InputType {
	Mouse,
	Controller1,
	Controller2,
}

@export var input_type: InputType

var has_disk: bool = true

const CATCHING_LENGTH = 1
const BACKSWING_LENGTH = 1

class State extends Node:
	enum S {
		Normal,
		Catching,
		Backswing,
	}
	var state: S = S.Normal
	var has_disc: bool = true

	enum ThrowResult {
		Thrown,
		Catching,
		Failed,
	}

	func try_throw() -> ThrowResult:
		match state:
			S.Normal:
				if has_disc:
					has_disc = false
					return ThrowResult.Thrown
				else:
					state = S.Catching
					start_catch_timer()
					return ThrowResult.Catching
			_:
				print("can't throw! in state ", state)
				return ThrowResult.Failed

	func start_catch_timer():
		await get_tree().create_timer(CATCHING_LENGTH).timeout
		if state == S.Catching:
			state = S.Backswing
			print("backswing!")
			start_backswing_timer()
		else:
			print("weird state! catching timer expired but we're in ", state)

	func start_backswing_timer():
		await get_tree().create_timer(BACKSWING_LENGTH).timeout
		if state == S.Backswing:
			state = S.Normal
			print("normal!")
		else:
			print("weird state! backswing timer expired but we're in ", state)

	enum CollideResult {
		Caught,
		Dead,
	}
	func try_collide() -> CollideResult:
		match state:
			S.Catching:
				state = S.Normal
				has_disc = true
				return CollideResult.Caught
			_:
				return CollideResult.Dead

var state: State

func get_aim_direction():
	match input_type:
		InputType.Mouse:
			return get_viewport().get_mouse_position() - self.position
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
	var s = State.new()
	add_child(s)
	state = s

func _physics_process(delta):
	var aim_direction = get_aim_direction()
	var move_direction = get_move_direction()
	var throwing = get_throwing()

	self.look_at(self.position + aim_direction)
	self.move_and_collide(move_direction.normalized() * 50 * delta)

	if throwing:
		match state.try_throw():
			State.ThrowResult.Thrown:
				DiscManager.new_disc(1, aim_direction, self.position + aim_direction.normalized() * 20)
			_:
				print("didn't throw")

func on_ball_collide(disc: Node2D, _col: KinematicCollision2D) -> bool:
	match state.try_collide():
		State.CollideResult.Caught:
			print("caught disc!")
			return true
		State.CollideResult.Dead:
			return false
		_:
			print("bad collide state!")
			return false
