extends CharacterBody2D
class_name Disc

const ACCELERATION : float = 1.2
const STARTING_SPEED : int = 100
const MAX_VEL : int = 400
const MAX_VEL_SQUARED : int = MAX_VEL * MAX_VEL

const LIGHT_BASE: float = 0
const LIGHT_MAX: float = 3

var vel: Vector2
var team: int = 1

func init(player_team: int, direction: Vector2, initial_position: Vector2):
	vel = direction.normalized() * STARTING_SPEED
	position = initial_position
	team = player_team
	$disc_sprite.frame = team
	$glow.color = TeamSettings.team_colours[team-1]
	update_glow()
	Events.ball_speed_changed.emit(vel.length())

static func get_trail(direction: Vector2, initial_position: Vector2, dist: float) -> PackedVector2Array:
	var res: Array[Vector2] = [initial_position]

	var disc = DiscManager.new_uninitialised()
	disc.position = initial_position

	var movement = direction.normalized() * dist
	while true:
		var col = disc.move_and_collide(movement)
		if col:
			res.append(col.get_position())
			movement = movement.bounce(col.get_normal()).normalized() * col.get_remainder().length()
		else:
			res.append(disc.position)
			break

	disc.queue_free()
	return PackedVector2Array(res)

func _physics_process(delta):
	var movement = self.vel
	while true:
		var col = self.move_and_collide(movement * delta)
		if col:
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
			update_glow()
			movement = col.get_remainder().bounce(col.get_normal())
		else:
			break

func update_glow():
	var vel_scalar = vel.length()
	var scale_point = (vel_scalar - STARTING_SPEED) / (MAX_VEL - STARTING_SPEED)
	$glow.energy = (LIGHT_MAX - LIGHT_BASE) * scale_point + LIGHT_BASE
