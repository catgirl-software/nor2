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
					return

			self.vel = self.vel.bounce(col.get_normal()) * ACCELERATION
			self.vel = self.vel.normalized() * min(MAX_VEL, self.vel.length())
			movement = col.get_remainder().bounce(col.get_normal())
		else:
			break
