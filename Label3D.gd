extends Spatial

func _process(_delta):
	var pos = global_transform.origin
	var camera = $"/root/Main/Camera"
	var offset_label =  $"CanvasLayer/Label".get_size() / 2
	$"CanvasLayer/Label".set_position(camera.unproject_position(pos) + Vector2(0, 20) - offset_label)
	$CanvasLayer/Sprite.set_position(camera.unproject_position(pos))
	var dist = $"/root/Main/Dog".transform.origin.distance_to(global_transform.origin)
	var alpha = 0.1
	if dist / 200.0 < 1:
		alpha = max(0.1, 1 - (dist / 200.0))
	$"CanvasLayer/Label".modulate = Color(1, 1, 1, alpha)
