extends KinematicBody

var target_pos = null
var speed = 16
var move_animation = null
var PUSH_FORCE = 30
var pushed_hay_before = false
onready var Achievement = preload("res://Achievement.tscn")

func _ready():
	move_animation = $"MoveAnimation"
	move_animation.set_objects($"DogModel", self)
	move_animation.force = move_animation.force * 2
	move_animation.gravitation = move_animation.gravitation * 4
	move_animation.power_influence = .3

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
	var _s = move_and_slide(Vector3(horizontal_vel.x, 0, horizontal_vel.z), Vector3.UP)
	for i in range(get_slide_count()):
		var col = get_slide_collision(i)
		if col:
			if col.collider.is_in_group("sheep"):
				col.collider.push_away(Vector2(col.normal.x, col.normal.z) * -PUSH_FORCE)
			elif col.collider.is_in_group("hay"):
				col.collider.push(Vector2(-col.normal.x, -col.normal.z).normalized())
				if not pushed_hay_before:
					pushed_hay_before = true
					var achievement = Achievement.instance()
					$"/root/Main".add_child(achievement)
					achievement.show_achievement("hay hay hay", "sheeps best friend", Color(0.49, 0.82, 0.83, 1.0))
	var new_pos = transform.origin
	vec = new_pos - pos
	var l = vec.length()
	l = max(0, horizontal_vel.length() * delta - l)
	dir = vec.normalized()
	var vel = dir * speed * l
	_s = move_and_slide(vel, Vector3.UP)
	_s = move_and_collide(Vector3(0, -100, 0))
	return horizontal_vec.length() < 1

func _physics_process(delta):
	if target_pos:
		if move(delta):
			target_pos = null
	else:
		move_animation.idle()

func position_changed(pos):
	target_pos = pos
