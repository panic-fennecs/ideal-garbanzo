extends Spatial

onready var Level1 = preload("res://Level1.tscn")
onready var Level2 = preload("res://Level2.tscn")

var sheep = []
var level = 0
var scene_transition = false

func _input(event):
	if event is InputEventKey and event.scancode == 65 and event.pressed:
		AudioPlayer.critical_level = min(AudioPlayer.critical_level + 1, 2)

func _ready():
	randomize()
	next_level()

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

func next_level():
	sheep.clear()
	if has_node("Level"):
		get_node("Level").queue_free()
	$LevelChangeTimer.start()


func _on_LevelChangeTimer_timeout():
	var new_level
	match level:
		0:
			new_level = Level1.instance()
		1:
			new_level = Level2.instance()
			AudioPlayer.critical_level = 2
	
	add_child(new_level)
	var end_pos = get_node("Level/EndZone").global_transform.origin
	var end_entry_pos = get_node("Level/EndZone/Entry").global_transform.origin
	get_node("Level/StartZone").init_sheep(Vector2(end_pos.x, end_pos.z), Vector2(end_entry_pos.x, end_entry_pos.z), get_node("Level/StartZone").global_transform.origin, get_node("Level/SheepContainer"))
	$Dog.global_transform.origin = get_node("Level/Spawn").global_transform.origin
	$Camera.global_transform.origin = $Dog.global_transform.origin
	
	level += 1
