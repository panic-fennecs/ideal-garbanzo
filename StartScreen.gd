extends Spatial

var main_scene = preload("res://Main.tscn")

func _process(_delta):
	if $Control/Button.is_hovered():
		$Control/Button.modulate = Color(0.2, 0.49, 0.6, 1.0)
	else:
		$Control/Button.modulate = Color.white

func _on_Button_pressed():
	var ok = get_tree().change_scene_to(main_scene)
