extends KinematicBody

var look_pos
var _move_time = 2
var target
var velocity

func _ready():
	$MoveAnimation.set_objects($"SheepModel", self)

func _physics_process(delta):
	if _move_time >= 2:
		_move_time = 0
		target = global_transform.origin + Vector3(randf() * 0.01, 0, randf() * 0.01)
		velocity = transform.origin.direction_to(target) * 0.1
	move_and_slide(velocity*delta)
	$MoveAnimation.move(velocity)
	_move_time += delta
