extends Spatial

signal clicked(pos)
var pressing = false

func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				pressing = true
				emit_signal("clicked", click_position)
			else:
				print("release")
				pressing = false
	if pressing and event is InputEventMouseMotion:
		emit_signal("clicked", click_position)
