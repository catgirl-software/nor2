extends CharacterBody2D
class_name Disc

const ACCELERATION : float = 2
const STARTING_SPEED : int = 20
const MAX_VEL : int = 100
const MAX_VEL_SQUARED : int = MAX_VEL * MAX_VEL

var vel: Vector2
var team: int = 1

func init(player_team: int, direction: Vector2, initial_position: Vector2):
	team = player_team
	$disc_sprite.frame = team
	vel = direction.normalized() * STARTING_SPEED
	position = initial_position
	Events.ball_speed_changed.emit(vel.length())

func _physics_process(delta):
	var movement = self.vel
	while true:
		var col = self.move_and_collide(movement * delta)
		if col:
			print("bounce! ", self.vel)

			var collider = col.get_collider()
			if collider.has_method("on_ball_collide"):
				var destroy = collider.on_ball_collide(self, col)
				if destroy:
					self.queue_free()
					Events.ball_speed_changed.emit(-vel.length())
					return
			var new_vel = self.vel.bounce(col.get_normal()) * ACCELERATION
			new_vel = new_vel.normalized() * min(MAX_VEL, new_vel.length())
			Events.ball_speed_changed.emit((new_vel - vel).length())
			self.vel = new_vel
			movement = col.get_remainder().bounce(col.get_normal())
		else:
			break
