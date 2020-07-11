extends Camera

const HEIGHT_OFFSET = 15
var angle_offset: float = 15.0
var camera_move_speed: float = 3.0

func _physics_process(delta: float) -> void:
	var dog_pos = $"/root/Main/Dog".transform.origin
	var target_pos = Vector3(dog_pos.x, dog_pos.y + HEIGHT_OFFSET, dog_pos.z + angle_offset)
	transform.origin = transform.origin + (target_pos - transform.origin) * delta * camera_move_speed
