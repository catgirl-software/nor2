extends CharacterBody2D
class_name Disc

const ACCELERATION : float = 2
const MAX_VEL : int = 100
const MAX_VEL_SQUARED : int = MAX_VEL * MAX_VEL

var vel: Vector2

func _ready():
	self.vel = Vector2(10, 10)

func _physics_process(delta):
	var movement = self.vel
	while true:
		var col = self.move_and_collide(movement * delta)
		if col:
			print("bounce! ", self.vel)
			self.vel = self.vel.bounce(col.get_normal()) * ACCELERATION
			self.vel = self.vel.normalized() * min(MAX_VEL, self.vel.length())
			movement = col.get_remainder().bounce(col.get_normal())
		else:
			break
