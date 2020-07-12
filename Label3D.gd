extends Spatial

func _process(_delta):
	var pos = global_transform.origin
	var camera = $"/root/Main/Camera"
	var offset_label =  $"CanvasLayer/Label".get_size() / 2
	$"CanvasLayer/Label".set_position(camera.unproject_position(pos) - offset_label)
	$CanvasLayer/Sprite.set_position(camera.unproject_position(pos))
