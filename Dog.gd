extends Spatial

var target_pos = null
var speed = 8

func _ready():
	pass

func _process(delta):
	if target_pos:
		var pos = transform.origin
		var vec = target_pos - pos
		var dir = vec.normalized()
		var l = vec.length()
		pos = pos + dir * speed * delta
		transform.origin = pos
		transform = transform.looking_at(target_pos, Vector3(0, 1, 0))
		if l < 1:
			target_pos = null

func move_to(pos):
	pass


func _on_Ground_clicked(pos):
	target_pos = pos
