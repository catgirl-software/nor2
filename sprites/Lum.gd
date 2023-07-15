extends TextureRect

var total_speed: float = 0
var shader_min: float = 0.2
var shader_cap: float = 1.8

func _ready():
	Events.ball_speed_changed.connect(ball_speed_changed)
	Events.ball_speed_reset.connect(reset)
	total_speed = 0
	ball_speed_changed(0)

func reset():
	ball_speed_changed(-total_speed)

func ball_speed_changed(delta):
	total_speed += delta
	self.material.set_shader_parameter("amount", clamp(total_speed / 700, shader_min, shader_cap))
	#self.material.set_shader_parameter("amount", 1.50)
