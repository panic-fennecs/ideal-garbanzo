extends KinematicBody


const DOG_REACTION_DISTANCE = 7
const DOG_INFLUENCE = 2.0
const OTHER_SHEEP_INFLUENCE = 0.8

const MAX_VELOCITY = 10.0
const DRAG = 0.02
const EPSILON = 0.0001

var velocity = Vector2()
var main
var move_animation = null

func _ready():
	main = get_node("/root/Main")
	move_animation = $"MoveAnimation"
	move_animation.set_objects($"MeshInstance", self)

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

func _physics_process(delta):
	# flee dog
	var dog = get_dog()
	if dog.translation.distance_to(self.translation) < DOG_REACTION_DISTANCE:
		flee(Vector2(dog.translation.x, dog.translation.z), DOG_INFLUENCE)

	# follow other sheep
	var other_sheep = get_other_sheep()
	for os in other_sheep:
		var influence = OTHER_SHEEP_INFLUENCE / (os.translation.distance_squared_to(translation) + EPSILON)
		var steering = os.velocity - velocity
		velocity = velocity.linear_interpolate(velocity + steering, influence)

	velocity *= 1.0 - DRAG

	if velocity.length_squared() < 0.1:
		move_animation.idle()
	else:
		move_animation.move(Vector3(velocity.x, 0, velocity.y).normalized())
		move_and_collide(Vector3(velocity.x, -translation.y, velocity.y) * delta)

func flee(pos, influence):
	var diff = get_2d_position() - pos
	var desired_velocity = diff.normalized() / (diff.length()+EPSILON) * MAX_VELOCITY 
	var steering = desired_velocity - velocity
	velocity += steering * influence
