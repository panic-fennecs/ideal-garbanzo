extends StaticBody

var pressing = false

func _on_Ground_input_event(_camera, event, click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				pressing = true
				$"/root/Main/Dog".position_changed(click_position)
				$"/root/Main/Cursor".set_cursor(click_position)
	if pressing and event is InputEventMouseMotion:
		$"/root/Main/Dog".position_changed(click_position)
		$"/root/Main/Cursor".set_cursor(click_position)

func _input(event):
	if event is InputEventMouseButton and not event.pressed:
		pressing = false
