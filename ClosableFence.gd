extends KinematicBody


var rot_vel: float = 0.0
const MAX_VEL: float = 5.0
var next_level_triggered = false

func manage_fence_collision(col_direction: Vector3):
	if col_direction.dot(-transform.basis.z) < 0:
		rot_vel += 1
	else:
		rot_vel -= 1

func _physics_process(delta):
	if rot_vel < 0 and rotation.y < -PI/2.0:
		rotate(Vector3.UP, rot_vel * delta)
		rot_vel = max(min(0, rot_vel + 0.1), -MAX_VEL)
	elif rot_vel > 0 and rotation.y < -PI/1.9:
		rotate(Vector3.UP, rot_vel * delta)
		rot_vel = min(max(0, rot_vel - 0.1), MAX_VEL)
	
	if abs(rotation.y) > PI - 0.2 and not next_level_triggered:
		$"/root/Main".next_level()
		next_level_triggered = true
	
