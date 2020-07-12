extends KinematicBody


var rot_vel: float = 0.0
const MAX_VEL: float = 5.0

func manage_fence_collision(col_direction: Vector3):
	if col_direction.dot(-transform.basis.z) < 0:
		rot_vel += 1
	else:
		rot_vel -= 1

func _physics_process(delta):
	if rot_vel < 0 and rotation.y < -PI/2.0:
		rotate(Vector3.UP, rot_vel * delta)
	elif rot_vel > 0 and rotation.y < -PI/1.9:
		rotate(Vector3.UP, rot_vel * delta)
	rot_vel = min(max(0, rot_vel - 0.2), MAX_VEL)
