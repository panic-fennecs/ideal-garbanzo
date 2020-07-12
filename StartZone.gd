extends Spatial

export(int) var sheep_count
onready var SheepScene = preload("res://Sheep.tscn")

func init_sheep(end_pos, entry):
	for _i in range(sheep_count):
		var s = SheepScene.instance()
		s.transform.origin = global_transform.origin + Vector3((randf()-0.5)*20.0, 5, (randf()-0.5)*20.0)
		$"/root/Main".add_child(s)
		s.init(end_pos, entry)
