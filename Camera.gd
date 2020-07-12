extends Camera

var height_offset = 25
var angle_offset: float = 15.0
var camera_move_speed: float = 3.0

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		# zoom in
		if event.button_index == BUTTON_WHEEL_UP:
			height_offset = max(10, height_offset - 1)
		# zoom out
		if event.button_index == BUTTON_WHEEL_DOWN:
			height_offset = min(40, height_offset + 1)

func _physics_process(delta: float) -> void:
	var dog_pos = $"/root/Main/Dog".transform.origin
	var target_pos = Vector3(dog_pos.x, dog_pos.y + height_offset, dog_pos.z + angle_offset)
	transform.origin = transform.origin + (target_pos - transform.origin) * delta * camera_move_speed
