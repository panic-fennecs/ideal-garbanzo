extends Spatial

onready var SheepScene = preload("res://Sheep.tscn")

var sheep = []

func init_sheep():
	for i in range(10):
		var s = SheepScene.instance()
		s.translate(Vector3(randf()*10.0, 1, randf()*10))
		add_child(s)
		sheep.append(s)

func _ready():
	init_sheep()
