extends Spatial

var hays = []

func _ready():
	for c in get_children():
		if c is KinematicBody and c.is_in_group("hay"):
			hays.push_back(c)
