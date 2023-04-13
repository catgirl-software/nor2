extends RigidBody2D
class_name Disc

const ACCELERATION : float = 0.4 * 60
const MAX_VEL : int = 20
const MAX_VEL_SQUARED : int = MAX_VEL * MAX_VEL

func _ready():
	apply_central_force(Vector2(0,600))
	
func accelerate_slightly(_body):
	apply_central_force(linear_velocity * ACCELERATION)
	print("Collision! vel: " + str(linear_velocity.length()))

func _integrate_forces(state):
	if state.linear_velocity.length_squared() > MAX_VEL_SQUARED:
		print("Too fast? length squared: " + str(state.linear_velocity.length_squared()))
		state.linear_velocity = state.linear_velocity.normalized() * MAX_VEL
		print("Dropped speed! vel: " + str(linear_velocity) + ", len: " + str(linear_velocity.length()) )
