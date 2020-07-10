extends Spatial


const DOG_REACTION_DISTANCE = 5


var speed = Vector3()
var main

func _ready():
	main = get_node("/root/Main")

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
		print('near')
	#var other_sheep = get_other_sheep()
