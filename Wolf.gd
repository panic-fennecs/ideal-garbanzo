extends KinematicBody

const MAX_VELOCITY = 20
const MAX_PULL_VELOCITY = 5
const DRAG = 0.03

const REACTION_DISTANCE = 50
const RUN_TO_TARGET_FORCE = 0.8
const DOG_REACTION_DISTANCE = 20
const PULL_SHEEP_FORCE = 0.3
const SHEEP_PULL_DISTANCE = 1.5

var move_animation = null
var dog = null
var state = "IDLE"
var velocity: Vector2 = Vector2()
var home_position: Vector2
var target_sheep = null
var max_velocity

func _ready():
	home_position = get_2d_position()
	move_animation = $"MoveAnimation"
	move_animation.set_objects($"WolfModel", self)
	max_velocity = MAX_VELOCITY
	dog = $"/root/Main".get_node("Dog")

func get_2d_position():
	return Vector2(translation.x, translation.z)

func check_for_sheep():
	for s in $"/root/Main".sheep:
		var sheep_pos = Vector2(s.translation.x, s.translation.z)
		if sheep_pos.distance_squared_to(home_position) < REACTION_DISTANCE*REACTION_DISTANCE:
			target_sheep = s
			state = "RUN"
			break

func run_to_target():
	var target_pos = Vector2(target_sheep.translation.x, target_sheep.translation.z)
	var desired_velocity = (target_pos - get_2d_position()).normalized() * max_velocity
	var steering = (desired_velocity - velocity).clamped(RUN_TO_TARGET_FORCE)
	velocity = (velocity + steering).clamped(max_velocity)

	var dog_position = Vector2(dog.translation.x, dog.translation.z)
	var pos = get_2d_position()
	if dog_position.distance_squared_to(pos) < DOG_REACTION_DISTANCE*DOG_REACTION_DISTANCE:
		target_sheep = null
		state = "BACK"
		max_velocity = MAX_VELOCITY

func handle_sheep_collision(sheep):
	if state == "RUN":
		target_sheep = sheep
		state = "PULL_SHEEP"
		target_sheep.state = "PULLED"
		$AttackLabel/CanvasLayer/Sprite.visible = true
		max_velocity = MAX_PULL_VELOCITY

		var pos = get_2d_position() - velocity.normalized()*4
		target_sheep.wolf_hold_pos = pos

func pull_sheep():
	var pos = get_2d_position()

	var desired_velocity = (home_position - pos).clamped(max_velocity)
	var steering = (desired_velocity - velocity).clamped(PULL_SHEEP_FORCE)
	velocity = (velocity + steering).clamped(max_velocity)

	var hold_pos = get_2d_position() - velocity.normalized()*SHEEP_PULL_DISTANCE
	target_sheep.wolf_hold_pos = hold_pos

	var dog_position = Vector2(dog.translation.x, dog.translation.z)
	if dog_position.distance_squared_to(pos) < DOG_REACTION_DISTANCE*DOG_REACTION_DISTANCE:
		state = "BACK"
		target_sheep.state = "NORMAL"
		target_sheep = null
		$AttackLabel/CanvasLayer/Sprite.visible = false
		max_velocity = MAX_VELOCITY

	if home_position.distance_squared_to(pos) < 100:
		target_sheep.die()
		$AttackLabel/CanvasLayer/Sprite.visible = false
		target_sheep = null
		state = "IDLE"
		max_velocity = MAX_VELOCITY

func run_back():
	var pos = get_2d_position()
	var desired_velocity = (home_position - pos).normalized() * max_velocity
	var steering = (desired_velocity - velocity).clamped(RUN_TO_TARGET_FORCE)
	velocity = (velocity + steering).clamped(max_velocity)

	if home_position.distance_squared_to(pos) < 100:
		state = "IDLE"

func _physics_process(_delta):
	if state == "IDLE":
		check_for_sheep()
	elif state == "RUN":
		run_to_target()
	elif state == "PULL_SHEEP":
		pull_sheep()
	elif state == "BACK":
		run_back()

	velocity *= 1.0 - DRAG
	if velocity.length_squared() < 0.1:
		move_animation.idle()
	else:
		var vel = Vector3(velocity.x, 0, velocity.y).normalized()
		if state == "PULL_SHEEP":
			vel = -vel
		move_animation.move(vel)

	var _s = move_and_slide(Vector3(velocity.x, -1, velocity.y), Vector3(0, 1, 0))
	for i in range(get_slide_count()):
		var col = get_slide_collision(i)
		if col and col.collider.is_in_group("sheep"):
			handle_sheep_collision(col.collider)
