extends MeshInstance

var cursor_time = 1

func _process(delta):
	cursor_time = cursor_time + delta
	get_surface_material(0).albedo_color.a = cos(clamp(cursor_time, 0, 1) * PI * .5)

func set_cursor(pos):
	cursor_time = 0
	global_transform.origin = pos
