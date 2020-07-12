extends Spatial

onready var Achievement = preload("res://Achievement.tscn")

var hays = []

func _ready():
	var achievement = Achievement.instance()
	$"/root/Main".add_child(achievement)
	achievement.show_achievement("instructions", "lead all sheep into their new paddock", Color(105.0/255.0, 147.0/255.0, 202.0/255.0, 1.0))
	
	for c in get_children():
		if c is KinematicBody and c.is_in_group("hay"):
			hays.push_back(c)
			
	
