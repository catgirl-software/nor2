extends TextureRect

var total_speed: float = 0

func _ready():
	Events.ball_speed_changed.connect(ball_speed_changed)

func ball_speed_changed(delta):
	total_speed += delta
	self.material.set_shader_parameter("amount", total_speed / 80)
