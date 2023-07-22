extends CharacterBody2D

static func create(input: I.InputType, team: int):
	var me = preload("res://player.tscn").instantiate()
	me.input_type = input
	me.team = team
	return me

var input_type: I.InputType
var team: int = 1

var last_look_direction: Vector2 = Vector2(1, 1)

var has_disc: bool = true
const BACKSWING_LENGTH: float = 2.5
enum State {
	Ready,
	Throwing,
	Catching,
	CatchingBackswing,
}

var state: State = State.Ready

func _ready():
	$Sprite2D.frame = team
	$Arm.frame = team
	$Arm/disc.frame = team
	$aim_trail.default_color = TeamSettings.team_colours[team-1].lightened(0.7)
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

	self.look_at(self.position + last_look_direction)
	self.move_and_collide(move_direction.normalized() * 100 * delta)

	update_aim_trail(aiming and has_disc && check_throw_validity())
	if state == State.Ready:
		if has_disc and throwing:
			print("throwing")
			try_throw()
		elif !has_disc and aiming:
			print("catching")
			try_catch()

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

func try_catch():
	state = State.Catching
	$AnimationPlayer.play("throw")
	print("catching, ", $Arm/disc.visible)
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.stop()
	if state == State.Catching:
		state = State.CatchingBackswing
		await get_tree().create_timer(BACKSWING_LENGTH).timeout
		state = State.Ready

func die(killing_team: int):
	print("dead")
	if killing_team != team:
		ScoreTracker.score(killing_team, team)
	ScoreTracker.on_kill()
	queue_free()

func on_ball_collide(disc: Disc, _col: KinematicCollision2D) -> bool:

	if state == State.Catching:
		state = State.Ready
		has_disc = true
		return true
	if disc.team == team:
		return false
	die(disc.team)
	ScoreTracker.GiveDisc.emit(disc.team)
	return true
