extends Spatial

func _process(_delta):
	var pos = global_transform.origin
	var camera = $"/root/Main/Camera"
	$CanvasLayer/Sprite.set_position(camera.unproject_position(pos))
