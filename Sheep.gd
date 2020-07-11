extends KinematicBody


const DOG_REACTION_DISTANCE = 12
const MAX_DOG_FORCE = 0.9

const MAX_OTHER_SHEEP_FORCE = 0.5

const RANDOM_WALK_PROPABILITY = 0.08
const RANDOM_WALK_DURATION = 120
const RANDOM_WALK_TARGET_POINT_DISTANCE = 6.0
const RANDOM_WALK_FORCE = 0.3

const GROUP_PROPABILITY = 0.17
const GROUP_UP_DURATION = 50
const GROUP_FORCE = 0.07

const MAX_VELOCITY = 20
const DRAG = 0.05
const EPSILON = 0.0001

var main
var other_sheep = []
var move_animation = null
var target_point: Vector2 = Vector2()
var target_entry_point: Vector2 = Vector2()
var velocity = Vector2()
var random_walk_frame_counter = 0
var group_up_frame_counter = 0
# var panic = 0

func _ready():
	main = get_node("/root/Main")
	move_animation = $"MoveAnimation"
	move_animation.set_objects($"SheepModel", self)
	$ActionTimer.wait_time = randf()*2.0
	$ActionTimer.connect("timeout", self, "_on_action")

func init(target_position, entry_position):
	target_point = target_position
	target_entry_point = entry_position

func _on_action():
	if randf() < RANDOM_WALK_PROPABILITY:
		random_walk_frame_counter = RANDOM_WALK_DURATION

	var distance = get_sheep_center().distance_to(get_2d_position())
	var group_probability = GROUP_PROPABILITY * distance / 10.0
	if randf() < group_probability:
		group_up_frame_counter = GROUP_UP_DURATION

func get_2d_position():
	return Vector2(self.translation.x, self.translation.z)

func get_other_sheep():
	if other_sheep:
		return other_sheep
	for s in main.sheep:
		if not s == self:
			other_sheep.append(s)
	return other_sheep

func get_sheep_center():
	var pos_sum = Vector2()
	for s in get_other_sheep():
		pos_sum += Vector2(s.translation.x, s.translation.z)
	return pos_sum / len(get_other_sheep())

func get_dog():
	return main.get_node("Dog")

func flee_dog():
	var dog = get_dog()
	if dog.translation.distance_to(self.translation) < DOG_REACTION_DISTANCE:
		var pos = Vector2(dog.translation.x, dog.translation.z)
		var diff = get_2d_position() - pos
		var influence = clamp(-1.0/DOG_REACTION_DISTANCE*diff.length() + 1, 0, 1)
		var desired_velocity = diff * 100 / (diff.length() + 0.3)
		var steering = desired_velocity - velocity
		steering = steering.clamped(MAX_DOG_FORCE*influence)
		velocity = (velocity + steering).clamped(MAX_VELOCITY)

func follow_other_sheep():
	var other_sheep = get_other_sheep()

	var sum_steering = Vector2()
	var num_steerings = 0
	for os in other_sheep:
		var diff = os.translation - translation
		var desired_velocity = os.velocity.normalized() * MAX_VELOCITY
		var steering = desired_velocity - velocity
		var influence = 2.0 / (diff.length() + 1.0)
		steering = steering.clamped(MAX_OTHER_SHEEP_FORCE) * influence
		sum_steering += steering
		num_steerings += 1
	velocity = (velocity + sum_steering / num_steerings).clamped(MAX_VELOCITY)

func random_walk():
	if random_walk_frame_counter > 0:
		random_walk_frame_counter -= 1
		var target_point = velocity.normalized() * RANDOM_WALK_TARGET_POINT_DISTANCE
		target_point += Vector2(randf()-0.5, randf()-0.5)
		var steering = target_point - velocity
		steering = steering.clamped(RANDOM_WALK_FORCE)
		velocity = (velocity + steering).clamped(MAX_VELOCITY)

func group_up():
	if group_up_frame_counter > 0:
		group_up_frame_counter -= 1
		var center = get_sheep_center()
		var desired_velocity = (center - get_2d_position()).normalized() * MAX_VELOCITY
		var steering = desired_velocity - velocity
		steering = steering.clamped(GROUP_FORCE)

		velocity = (velocity + steering).clamped(MAX_VELOCITY)

func _physics_process(delta):
	flee_dog()

	follow_other_sheep()

	random_walk()

	group_up()

	velocity *= 1.0 - DRAG

	if velocity.length_squared() < 0.8:
		move_animation.idle()
	else:
		move_animation.move(Vector3(velocity.x, 0, velocity.y).normalized())
		move_and_collide(Vector3(velocity.x, -translation.y, velocity.y) * delta)
