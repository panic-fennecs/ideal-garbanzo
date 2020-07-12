extends KinematicBody

var dir = null
var speed = 30
var time = 0
var damp = 1

func _ready():
	add_to_group("hay")

func mix(a, b, t):
	return a + (b - a) * t

func _process(delta):
	if dir:
		look_at(transform.origin + dir, Vector3.UP)
		var vel = dir * mix(speed, 0, min(1, time))
		var _c = move_and_slide(vel, Vector3.UP)
		time = time + delta * damp
	var _c = move_and_collide(Vector3.UP * -100)

func push(dir2):
	dir = Vector3(dir2.x, 0, dir2.y)
	time = 0
