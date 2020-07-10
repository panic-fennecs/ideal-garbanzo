extends KinematicBody


const DOG_REACTION_DISTANCE = 7
const MAX_VELOCITY = 10.0
const DRAG = 0.05

var velocity = Vector2()
var main

func _ready():
	main = get_node("/root/Main")

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
	var dog = get_dog()
	if dog.translation.distance_to(self.translation) < DOG_REACTION_DISTANCE:
		flee(Vector2(dog.translation.x, dog.translation.z))
	#var other_sheep = get_other_sheep()
	
	velocity *= 1.0 - DRAG

	move_and_collide(Vector3(velocity.x, 0, velocity.y) * delta)

func flee(pos):
	var diff = get_2d_position() - pos
	var desired_velocity = diff.normalized() / (diff.length()+0.001) * MAX_VELOCITY 
	var steering = desired_velocity - velocity
	velocity += steering
