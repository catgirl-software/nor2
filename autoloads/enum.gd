extends Node

enum InputType {
	Controller1,
	Controller2,
	Controller3,
	Controller4,
}

func get_aim_direction(input_type: InputType):
	match input_type:
		InputType.Controller1:
			return Input.get_vector("joystick_aim_1_nx", "joystick_aim_1_px", "joystick_aim_1_ny", "joystick_aim_1_py")
		InputType.Controller2:
			return Input.get_vector("joystick_aim_2_nx", "joystick_aim_2_px", "joystick_aim_2_ny", "joystick_aim_2_py")
		InputType.Controller3:
			return Input.get_vector("joystick_aim_3_nx", "joystick_aim_3_px", "joystick_aim_3_ny", "joystick_aim_3_py")
		InputType.Controller4:
			return Input.get_vector("joystick_aim_4_nx", "joystick_aim_4_px", "joystick_aim_4_ny", "joystick_aim_4_py")
		_:
			print("BAD INPUT TYPE: ", self.input_type)
			return Vector2(0, 0)

func get_move_direction(input_type: InputType):
	match input_type:
		InputType.Controller1:
			return Input.get_vector("joystick_move_1_nx", "joystick_move_1_px", "joystick_move_1_ny", "joystick_move_1_py")
		InputType.Controller2:
			return Input.get_vector("joystick_move_2_nx", "joystick_move_2_px", "joystick_move_2_ny", "joystick_move_2_py")
		InputType.Controller3:
			return Input.get_vector("joystick_move_3_nx", "joystick_move_3_px", "joystick_move_3_ny", "joystick_move_3_py")
		InputType.Controller4:
			return Input.get_vector("joystick_move_4_nx", "joystick_move_4_px", "joystick_move_4_ny", "joystick_move_4_py")
		_:
			print("BAD INPUT TYPE: ", self.input_type)
			return Vector2(0, 0)

func get_aiming(input_type: InputType):
	match input_type:
		InputType.Controller1:
			return Input.is_action_pressed("joystick_1_throw")
		InputType.Controller2:
			return Input.is_action_pressed("joystick_2_throw")
		InputType.Controller3:
			return Input.is_action_pressed("joystick_3_throw")
		InputType.Controller4:
			return Input.is_action_pressed("joystick_4_throw")
		_:
			print("BAD INPUT TYPE: ", self.input_type)
			return false

func get_throwing(input_type: InputType):
	match input_type:
		InputType.Controller1:
			return Input.is_action_just_released("joystick_1_throw")
		InputType.Controller2:
			return Input.is_action_just_released("joystick_2_throw")
		InputType.Controller3:
			return Input.is_action_just_released("joystick_3_throw")
		InputType.Controller4:
			return Input.is_action_just_released("joystick_4_throw")
		_:
			print("BAD INPUT TYPE: ", self.input_type)
			return false

func get_confirm(input_type: InputType):
	return get_throwing(input_type)

func get_leave(input_type: InputType):
	match input_type:
		InputType.Controller1:
			return Input.is_action_pressed("joystick_1_back")
		InputType.Controller2:
			return Input.is_action_pressed("joystick_2_back")
		InputType.Controller3:
			return Input.is_action_pressed("joystick_3_back")
		InputType.Controller4:
			return Input.is_action_pressed("joystick_4_back")
		_:
			print("BAD INPUT TYPE: ", self.input_type)
			return false
