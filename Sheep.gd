extends KinematicBody


const DOG_REACTION_DISTANCE = 8
const MAX_DOG_FORCE = 0.5

const MAX_OTHER_SHEEP_FORCE = 0.5

const MAX_VELOCITY = 8
const DRAG = 0.05
const EPSILON = 0.0001

var main
var move_animation = null
var velocity = Vector2()
# var panic = 0

func _ready():
	main = get_node("/root/Main")
	move_animation = $"MoveAnimation"
	move_animation.set_objects($"SheepModel", self)

func get_2d_position():
	return Vector2(self.translation.x, self.translation.z)

func get_other_sheep():
	var other_sheep = []
	for s in main.sheep:
		if not s == self:
			other_sheep.append(s)
	return other_sheep

func get_dog():
	return main.get_node("Dog")

func flee_dog():
	var dog = get_dog()
	if dog.translation.distance_to(self.translation) < DOG_REACTION_DISTANCE:
		var pos = Vector2(dog.translation.x, dog.translation.z)
		var diff = get_2d_position() - pos
		var desired_velocity = diff * 100 / (diff.length() + 0.3)
		var steering = desired_velocity - velocity
		steering = steering.clamped(MAX_DOG_FORCE)
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

func _physics_process(delta):
	flee_dog()

	follow_other_sheep()

	velocity *= 1.0 - DRAG

	if velocity.length_squared() < 0.1:
		move_animation.idle()
	else:
		move_animation.move(Vector3(velocity.x, 0, velocity.y).normalized())
		move_and_collide(Vector3(velocity.x, -translation.y, velocity.y) * delta)
