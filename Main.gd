extends Spatial

onready var SheepScene = preload("res://Sheep.tscn")

var sheep = []

func init_sheep():
	for i in range(1):
		var s = SheepScene.instance()
		s.translate(Vector3(randf()*10.0, randf()*10.0, randf()*10.0))
		# s.position = 
		add_child(s)

func _ready():
	init_sheep()
