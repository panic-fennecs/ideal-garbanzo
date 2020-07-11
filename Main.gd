extends Spatial

onready var SheepScene = preload("res://Sheep.tscn")

var sheep = []

func init_sheep():
	for i in range(20):
		var s = SheepScene.instance()
		s.translate(Vector3((randf()-0.5)*20.0, 1, (randf()-0.5)*20.0))
		add_child(s)
		var end_pos = $"EndZone".global_transform.origin
		end_pos = Vector2(end_pos.x, end_pos.z)
		print(end_pos)
		s.init(end_pos, end_pos + Vector2(0, 11))
		sheep.append(s)

func _ready():
	init_sheep()
