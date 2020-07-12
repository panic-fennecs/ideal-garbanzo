extends Node2D

var translated_object = null
var rotated_object = null

var moving = false
var jumping = false
var target_dir = null
var tilt_axis = Vector3.UP
var tilt_angle = 0
var tilt_speed = 0
var power = 0
var power_influence = 1
var initial_height = 0
var height = 0
var velocity = 0
var force = 10
var gravitation = -50
var rotation_speed = 10

func mix(a, b, t):
	return a + (b - a) * t

func _process(delta):
	if jumping:
		velocity += gravitation * delta
		height += velocity * delta
		var p = mix(0, power, power_influence)
		tilt_angle = sin((velocity + force) / force / 2 * PI) * tilt_speed * p * delta
		if height < 0:
			height = 0
			jumping = false
	elif moving:
		jumping = true
		power = randf() + 1
		var p = mix(1, power, power_influence)
		velocity = force * p
		tilt_axis = -rotated_object.global_transform.basis.z
		tilt_angle = 0
		tilt_speed = (randf() * 10) * sign(randf() - .5)

	translated_object.transform.origin.y = initial_height + height
	if target_dir:
		var dir = -rotated_object.global_transform.basis.z
		dir = dir.linear_interpolate(target_dir, max(10 * delta, 0))
		var up = Vector3.UP.rotated(tilt_axis.normalized(), tilt_angle)
		rotated_object.look_at(rotated_object.global_transform.origin + dir, up)

func idle():
	moving = false

func move(dir):
	moving = true
	target_dir = dir

func set_objects(translated, rotated):
	translated_object = translated
	rotated_object = rotated
	initial_height = translated_object.transform.origin.y
