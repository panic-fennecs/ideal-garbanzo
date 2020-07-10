extends Spatial

var target_pos = null
var speed = 8
var move_animation = null

func _ready():
	move_animation = $"MoveAnimation"
	move_animation.set_object($"MeshInstance")

func _process(delta):
	if target_pos:
		var pos = transform.origin
		var vec = target_pos - pos
		var dir = vec.normalized()
		var l = vec.length()
		pos = pos + dir * speed * delta
		transform.origin = pos
		transform = transform.looking_at(target_pos, Vector3(0, 1, 0))
		move_animation.move()
		if l < 1:
			target_pos = null
	else:
		move_animation.idle()

func move_to(pos):
	pass

func _on_Ground_clicked(pos):
	target_pos = pos
