extends Spatial

var target_pos = null
var speed = 8
var move_animation = null

func _ready():
	move_animation = $"MoveAnimation"
	move_animation.set_objects($"MeshInstance", self)

func _process(delta):
	if target_pos:
		var pos = transform.origin
		var vec = target_pos - pos
		var dir = vec.normalized()
		var l = vec.length()
		pos = pos + dir * speed * delta
		transform.origin = pos
		move_animation.move(dir)
		if l < 1:
			target_pos = null
	else:
		move_animation.idle()

func _on_Ground_clicked(pos):
	target_pos = pos
