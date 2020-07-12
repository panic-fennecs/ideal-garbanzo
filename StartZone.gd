extends Spatial

export(int) var sheep_count
onready var SheepScene = preload("res://Sheep.tscn")

func init_sheep(end_pos, entry, position, parent):
	for _i in range(sheep_count):
		var s = SheepScene.instance()
		s.transform.origin = position + Vector3((randf()-0.5)*20.0, 5, (randf()-0.5)*20.0)
		parent.add_child(s)
		$"/root/Main".sheep.append(s)
		s.init(end_pos, entry)
