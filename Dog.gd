extends KinematicBody

var target_pos = null
var speed = 16
var move_animation = null
var PUSH_FORCE = 30

func _ready():
	move_animation = $"MoveAnimation"
	move_animation.set_objects($"DogModel", self)
	move_animation.force = move_animation.force * 2
	move_animation.gravitation = move_animation.gravitation * 4

func move(delta):
	var pos = transform.origin
	var vec = target_pos - pos
	var dir = vec.normalized()
	var horizontal_vec = Vector3(vec.x, 0, vec.z)
	var horizontal_dir = horizontal_vec.normalized()
	var horizontal_vel = horizontal_dir * speed
	move_animation.move(horizontal_dir)
	#transform.origin = Vector3(new_pos.x, pos.y, new_pos.z)
	#move_and_slide(Vector3(0, -pos.y - 10, 0))
	move_animation.move(horizontal_dir)
	var _s = move_and_slide(Vector3(horizontal_vel.x, 0, horizontal_vel.z), Vector3(0, 1, 0))
	for i in range(get_slide_count()):
		var col = get_slide_collision(i)
		if col and col.collider.is_in_group("sheep"):
			col.collider.push_away(Vector2(col.normal.x, col.normal.z) * -PUSH_FORCE)
	var new_pos = transform.origin
	vec = new_pos - pos
	var l = vec.length()
	l = max(0, horizontal_vel.length() * delta - l)
	dir = vec.normalized()
	var vel = dir * speed * l
	_s = move_and_slide(vel, Vector3(0, 1, 0))
	_s = move_and_collide(Vector3(0, -100, 0))
	return horizontal_vec.length() < 1

func _physics_process(delta):
	if target_pos:
		if move(delta):
			target_pos = null
	else:
		move_animation.idle()

func _on_Ground_clicked(pos):
	target_pos = pos
