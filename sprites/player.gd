extends CharacterBody2D

static func create(input: I.InputType, team: int):
	var me = preload("res://player.tscn").instantiate()
	me.input_type = input
	me.team = team
	return me

var input_type: I.InputType = I.InputType.Controller1
var team: int = 1
var ate_disc: bool = false
var last_look_direction: Vector2 = Vector2(1, 1)

var has_disc: bool = true
const BACKSWING_LENGTH: float = 2.5
enum State {
	Ready,
	Throwing,
	DashCharging,
	Dashing,
	DashBackswing,
}
var dash_direction: Vector2 = Vector2(0, 0)
var dash_frames: float = 0

var state: State = State.Ready

func _ready():
	$Sprite2D.frame = team
	$Arm.frame = team
	$Arm/disc.frame = team
	$aim_trail.default_color = TeamSettings.team_colours[team-1].lightened(0.7)
	$"arrowhead/part 1".default_color = TeamSettings.team_colours[team-1].darkened(0.5)
	$"arrowhead/part 2".default_color = TeamSettings.team_colours[team-1].darkened(0.5)
	ScoreTracker.GiveDisc.connect(maybe_give_disc)

func maybe_give_disc(t):
	if t == team:
		has_disc = true

func _physics_process(delta):
	var aim_direction = I.get_aim_direction(input_type)
	var move_direction = I.get_move_direction(input_type)
	if aim_direction.length():
		last_look_direction = aim_direction
	elif move_direction.length():
		last_look_direction = move_direction

	var aiming = I.get_aiming(input_type)
	var throwing = I.get_throwing(input_type)
	var dash_held = I.get_dash_held(input_type)

	self.look_at(self.position + last_look_direction)

	if state == State.Ready or state == State.Throwing:
		self.move_and_collide(move_direction.normalized() * 100 * delta)
	if state == State.DashCharging:
		pass # no movement
	if state == State.Dashing:
		var s = dash_direction.normalized() * 400 * delta
		for i in range(10):
			var col = self.move_and_collide(s)
			if !col:
				break
			s = col.get_remainder().slide(col.get_normal())

	if state == State.DashBackswing:
		self.move_and_collide(move_direction.normalized() * 20 * delta) # slow


	update_aim_trail(aiming and has_disc && check_throw_validity())
	if state == State.Ready:
		if has_disc and throwing:
			print("throwing")
			try_throw()

	if state == State.Ready and dash_held:
		state = State.DashCharging
		state = State.Dashing
		dash_direction = last_look_direction
		dash_frames = 8
	if state == State.DashCharging:
		dash_frames += 0.2
		if dash_frames > 8:
			dash_frames = 8
		if !dash_held:
			# dash
			state = State.Dashing
			dash_direction = last_look_direction
	if state == State.Dashing:
		dash_frames -= 1
		if dash_frames <= 0:
			if ate_disc:
				ate_disc = false
				state = State.Ready
			else:
				state = State.DashBackswing
				await get_tree().create_timer(1.0).timeout
				state = State.Ready

	update_dash_trail()
func update_dash_trail():
	if state != State.DashCharging:
		$dash_trail.visible = false
		$arrowhead.visible = false
		return
	var end_point := Vector2(1, 0) * 400 * dash_frames/60
	$dash_trail.points = [
		Vector2(0, 0),
		end_point
	]
	if dash_frames == 8:
		$dash_trail.default_color = TeamSettings.team_colours[team-1].darkened(0.7)
	else:
		$dash_trail.default_color = Color.WHITE
	$dash_trail.visible = true
	$arrowhead.position = end_point
	$arrowhead.visible = true
func update_aim_trail(aiming: bool):
	$aim_trail.visible = aiming
	if aiming:
		$aim_trail.points = Disc.get_trail(
			last_look_direction,
			position + last_look_direction.normalized() * 20,
			200,
		)
		for i in range(0, $aim_trail.points.size()):
			$aim_trail.points[i] -= self.position
			$aim_trail.points[i] = $aim_trail.points[i].rotated(-self.rotation)

func check_throw_validity() -> bool:
	print("Checking validity")
	print("overlapping " + str($ThrowArea.get_overlapping_bodies()))
	if $ThrowArea.has_overlapping_bodies():
		print("Can't throw")
		return false
	else:
		print("can throw")
		return true
	
func try_throw():
	if check_throw_validity() == false:
		return
	DiscManager.new_disc(team, last_look_direction, position + last_look_direction.normalized() * 20)
	state = State.Throwing
	has_disc = false
	$Arm/disc.visible = true
	$AnimationPlayer.play("throw")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.stop()
	$Arm/disc.visible = false
	print("stopped")
	state = State.Ready

func die(killing_team: int):
	print("dead")
	if killing_team != team:
		ScoreTracker.score(killing_team, team)
	ScoreTracker.on_kill()
	queue_free()


func on_ball_collide(disc: Disc, _col: KinematicCollision2D):
	if state == State.Dashing:
		if has_disc:
			disc.team = team
			return dash_direction
			return false #bounce
		else:
			ate_disc = true
			has_disc = true
			return true
	if disc.team == team:
		return false
	die(disc.team)
	ScoreTracker.GiveDisc.emit(disc.team)
	return true
