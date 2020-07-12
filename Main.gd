extends Spatial

onready var Level1 = preload("res://Level1.tscn")

var sheep = []

func _input(event):
	if event is InputEventKey and event.scancode == 65 and event.pressed:
		AudioPlayer.critical_level = min(AudioPlayer.critical_level + 1, 2)

func _ready():
	randomize()
	sheep.clear()
	add_child(Level1.instance())
	$Dog.transform.origin = get_node("Level/Spawn").global_transform.origin
	var end_pos = get_node("Level/EndZone").global_transform.origin
	var end_entry_pos = end_pos + get_node("Level/EndZone/Entry").transform.origin
	get_node("Level/StartZone").init_sheep(Vector2(end_pos.x, end_pos.z), Vector2(end_entry_pos.x, end_entry_pos.z))
