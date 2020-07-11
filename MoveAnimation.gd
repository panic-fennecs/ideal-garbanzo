extends Node2D

var translated_object = null
var rotated_object = null

var moving = false
var jumping = false
var target_dir = null
var initial_height = 0
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

	translated_object.transform.origin.y = initial_height + height
	if target_dir:
		var dir = -rotated_object.global_transform.basis.z
		dir = dir.linear_interpolate(target_dir, .02)
		rotated_object.transform = rotated_object.transform.looking_at(rotated_object.transform.origin + dir, Vector3(0, 1, 0))

func idle():
	moving = false

func move(dir):
	moving = true
	target_dir = dir

func set_objects(translated, rotated):
	translated_object = translated
	rotated_object = rotated
	initial_height = translated_object.transform.origin.y
