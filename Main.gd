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
	$Camera.transform.origin = get_node("Level/Spawn").global_transform.origin
	$Dog.transform.origin = get_node("Level/Spawn").global_transform.origin
	var end_pos = get_node("Level/EndZone").global_transform.origin
	var end_entry_pos = end_pos + get_node("Level/EndZone/Entry").transform.origin
	get_node("Level/StartZone").init_sheep(Vector2(end_pos.x, end_pos.z), Vector2(end_entry_pos.x, end_entry_pos.z))

func _physics_process(_delta):
		remove_dead_sheep()

func get_num_finished_sheep():
	var n = 0
	for s in sheep:
		if s.in_finish:
			n += 1
	return n

func remove_dead_sheep():
	var index = 0
	while index < len(sheep):
		if not sheep[index].alive:
			sheep.remove(index)
		else:
			index += 1
