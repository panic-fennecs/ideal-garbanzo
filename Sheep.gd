extends KinematicBody


const DOG_REACTION_DISTANCE = 15
const MAX_DOG_FORCE = 1.9
const PUSH_FORCE = 20

const MAX_OTHER_SHEEP_FORCE = 0.5

const RANDOM_WALK_PROPABILITY = 0.08
const RANDOM_WALK_DURATION = 120
const RANDOM_WALK_TARGET_POINT_DISTANCE = 6.0
const RANDOM_WALK_FORCE = 0.3

const GROUP_PROPABILITY = 0.17
const GROUP_UP_DURATION = 50
const GROUP_FORCE = 0.07

const ENTRY_REACTION_DISTANCE = 20
const ENTRY_FINISHED_DISTANCE = 4.0
const ENTRY_FORCE = 0.3
const DEFAULT_MAX_VELOCITY: float = 20.0

const AVOIDANCE_LOOK_AHEADS = [2.0, 4.0, 8.0]
const AVOIDANCE_FORCE = 0.2

const WOLF_HOLD_FORCE = 2.0

var max_velocity = DEFAULT_MAX_VELOCITY
const DRAG = 0.05
const EPSILON = 0.0001

var main
var state = "NORMAL"
var other_sheep = []
var move_animation = null
var target_point: Vector2 = Vector2()
var target_entry_point: Vector2 = Vector2()
var velocity = Vector2()
var random_walk_frame_counter = 0
var group_up_frame_counter = 0
var in_finish = false
var wolf_hold_pos = null
var alive = true
var remove_counter = 10
# var panic = 0

func _ready():
	randomize()
	var r = randf() * .8 + .7
	$"SheepModel".transform = $"SheepModel".transform.translated(Vector3(0, (1 - r) * -.7 -.7, 0))
	$"SheepModel".transform = $"SheepModel".transform.scaled(Vector3(r, r, r))
	
	add_to_group("sheep")
	main = get_node("/root/Main")
	move_animation = $"MoveAnimation"
	move_animation.set_objects($"SheepModel", self)
	$ActionTimer.wait_time = randf()*2.0
	var _c = $ActionTimer.connect("timeout", self, "_on_action")

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

func die():
	alive = false

func get_2d_position():
	return Vector2(self.translation.x, self.translation.z)

func remove_dead_sheep():
	var index = 0
	while index < len(other_sheep):
		if not other_sheep[index].alive:
			other_sheep.remove(index)
		else:
			index += 1

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

func flee(maybe_dog, limit=1000):
	var dog = maybe_dog
	if dog.translation.distance_to(self.translation) < DOG_REACTION_DISTANCE:
		var pos = Vector2(dog.translation.x, dog.translation.z)
		var diff = get_2d_position() - pos
		var influence = clamp(-1.0/DOG_REACTION_DISTANCE*diff.length() + 1, 0, 1)
		var desired_velocity = diff * 100 / (diff.length() + 0.3)
		var steering = desired_velocity - velocity
		steering = steering.clamped(MAX_DOG_FORCE*influence)
		steering = steering.clamped(limit)
		velocity = (velocity + steering).clamped(min(max_velocity, limit))

func chaise(dog):
	if dog.global_transform.origin.distance_to(self.translation) < DOG_REACTION_DISTANCE:
		var pos = Vector2(dog.global_transform.origin.x, dog.global_transform.origin.z)
		var diff = pos - Vector2(global_transform.origin.x, global_transform.origin.z)
		var influence = clamp(1.0/DOG_REACTION_DISTANCE*diff.length() - .5, 0, 1)
		var desired_velocity = diff * 100 / (diff.length() + 0.3)
		var steering = desired_velocity - velocity
		steering = steering.clamped(MAX_DOG_FORCE*influence)
		velocity = (velocity + steering).clamped(max_velocity)
		return true
	return false

func follow_other_sheep():
	var o_sheep = get_other_sheep()

	if not o_sheep:
		return

	var sum_steering = Vector2()
	var num_steerings = 0
	for os in o_sheep:
		var diff = os.translation - translation
		var desired_velocity = os.velocity.normalized() * max_velocity
		var steering = desired_velocity - velocity
		var influence = 2.0 / (diff.length() + 1.0)
		steering = steering.clamped(MAX_OTHER_SHEEP_FORCE) * influence
		sum_steering += steering
		num_steerings += 1
	velocity = (velocity + sum_steering / num_steerings).clamped(max_velocity)

func random_walk():
	if random_walk_frame_counter > 0:
		random_walk_frame_counter -= 1
		var target = velocity.normalized() * RANDOM_WALK_TARGET_POINT_DISTANCE
		target += Vector2(randf()-0.5, randf()-0.5)
		var steering = target - velocity
		steering = steering.clamped(RANDOM_WALK_FORCE)
		velocity = (velocity + steering).clamped(max_velocity)

func group_up():
	if group_up_frame_counter > 0:
		group_up_frame_counter -= 1
		var center = get_sheep_center()
		var desired_velocity = (center - get_2d_position()).normalized() * max_velocity
		var steering = desired_velocity - velocity
		steering = steering.clamped(GROUP_FORCE)

		velocity = (velocity + steering).clamped(max_velocity)

func do_enter():
	var t_point = null
	var force = 0
	var position = get_2d_position()
	var entry_distance = position.distance_to(target_entry_point)

	if in_finish:
		t_point = target_point
		force = 1.0
	else:
		if entry_distance < ENTRY_REACTION_DISTANCE:
			if entry_distance < ENTRY_FINISHED_DISTANCE:
				in_finish = true
			else:
				t_point = target_entry_point
				force = ENTRY_REACTION_DISTANCE / (entry_distance + 0.3)

	if t_point != null:
		var desired_velocity = (t_point - get_2d_position()).normalized() * max_velocity
		var steering = desired_velocity - velocity
		steering = steering.clamped(ENTRY_FORCE * force)
		velocity = (velocity + steering).clamped(max_velocity)

func push_away(force: Vector2):
	velocity += force
	max_velocity = 25

func avoid_obstacles():
	var most_threatening = [null, null]
	for obstacle in get_tree().get_nodes_in_group("obstacle"):
		var col_index = collides_with_obstacle(obstacle)
		if col_index != null:
			if most_threatening[1] == null || most_threatening[1] > col_index:
				most_threatening = [obstacle, col_index]

	if most_threatening[0] != null:
		avoid_obstacle(most_threatening[0])

func collides_with_obstacle(obstacle):
	var position = get_2d_position()
	var obstacle_position = Vector2(obstacle.global_transform.origin.x, obstacle.global_transform.origin.z)
	var radius = obstacle.get_radius()
	var aheads = []
	for r in AVOIDANCE_LOOK_AHEADS:
		aheads.append(position + velocity.normalized() * r)
	var index = 0
	var nearest_index = 100
	for ahead in aheads:
		if ahead.distance_squared_to(obstacle_position) < radius*radius:
			nearest_index = min(nearest_index, index)
		index += 1

	if nearest_index == 100:
		nearest_index = null
	return nearest_index

func avoid_obstacle(obstacle):
	var obstacle_position = Vector2(obstacle.global_transform.origin.x, obstacle.global_transform.origin.z)
	var radius = obstacle.get_radius()
	var position = get_2d_position()
	var aheads = []
	for r in AVOIDANCE_LOOK_AHEADS:
		aheads.append(position + velocity.normalized() * r)
	for ahead in aheads:
		if ahead.distance_squared_to(obstacle_position) < radius*radius:
			var avoidance_force = (ahead - obstacle_position).normalized() * AVOIDANCE_FORCE
			velocity = (velocity + avoidance_force).clamped(max_velocity)
			break

func hold_by_wolf():
	var desired_velocity = (wolf_hold_pos - get_2d_position()).clamped(max_velocity)
	var steering = (desired_velocity - velocity).clamped(WOLF_HOLD_FORCE)
	velocity = (velocity + steering).clamped(max_velocity)

func _physics_process(delta):
	remove_dead_sheep()

	if state == "NORMAL":
		flee(get_dog())
		var eating_hay = false
		var hays = $"/root/Main/Level".hays
		if hays and hays is Array:
			for hay in hays:
				if not eating_hay:
					eating_hay = chaise(hay)
		if not eating_hay:
			follow_other_sheep()
			random_walk()
			group_up()
			# avoid_obstacles()
		for wolf in get_tree().get_nodes_in_group("wolf"):
			flee(wolf, 14)
		do_enter()
	elif state == "PULLED":
		hold_by_wolf()

	velocity *= 1.0 - DRAG
	max_velocity = max(DEFAULT_MAX_VELOCITY, max_velocity - delta*200)

	if velocity.length_squared() < 0.8:
		move_animation.idle()
	else:
		if state == "PULLED":
			move_animation.idle()
		else:
			move_animation.move(Vector3(velocity.x, 0, velocity.y).normalized())
		var _s = move_and_slide(Vector3(velocity.x, -1, velocity.y), Vector3(0, 1, 0))
		for i in range(get_slide_count()):
			var col = get_slide_collision(i)
			if col and col.collider.is_in_group("sheep") and max_velocity > 20:
				col.collider.push_away(Vector2(col.normal.x, col.normal.z) * -PUSH_FORCE)
	var _s = move_and_collide(Vector3(0, -100, 0))

	if not alive:
		remove_counter -= 1
		if remove_counter == 0:
			queue_free()
