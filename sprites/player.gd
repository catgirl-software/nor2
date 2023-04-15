extends CharacterBody2D

enum InputType {
	Mouse,
	Controller1,
	Controller2,
}

@export var input_type: InputType

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

func _physics_process(delta):
	var aim_direction = get_aim_direction()
	var move_direction = get_move_direction()

	self.look_at(self.position + aim_direction)
	self.move_and_collide(move_direction.normalized() * 50 * delta)
