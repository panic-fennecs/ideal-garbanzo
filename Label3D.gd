extends Spatial

func _process(delta):
	var pos = global_transform.origin
	var label = $"CanvasLayer/Label"
	var camera = $"/root/Main/Camera"
	var offset = label.get_size() / 2
	label.set_position(camera.unproject_position(pos) - offset)
