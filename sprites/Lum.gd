extends TextureRect

var total_speed: float = 0

func _ready():
	Events.ball_speed_changed.connect(ball_speed_changed)
	Events.ball_speed_reset.connect(reset)
	total_speed = 0
	ball_speed_changed(0)

func reset():
	ball_speed_changed(-total_speed)

func ball_speed_changed(delta):
	total_speed += delta
	self.material.set_shader_parameter("amount", total_speed / 700)
	self.material.set_shader_parameter("amount", 1.50)
