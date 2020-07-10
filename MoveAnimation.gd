extends Node2D

var object = null
var moving = false
var initial_height = 0

var jumping = false
var height = 0
var velocity = 0
var force = 10
var gravitation = -50

func _process(delta):
	if jumping:
		velocity += gravitation * delta
		height += velocity * delta
		if height < 0:
			height = 0
			jumping = false
	elif moving:
		jumping = true
		velocity = force
	object.transform.origin.y = initial_height + height

func idle():
	moving = false

func move():
	moving = true

func set_object(o):
	object = o
	initial_height = object.transform.origin.y
