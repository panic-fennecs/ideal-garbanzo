extends Area

var already_shown = false
onready var Achievement = preload("res://Achievement.tscn")

var entered_sheep = []

func _on_TipArea_body_entered(body):
	if body.is_in_group("dog") and not already_shown:
		var achievement = Achievement.instance()
		$"/root/Main".add_child(achievement)
		achievement.show_achievement("Here's a Tip", "close the fence to finish", Color(0.49, 0.82, 0.83, 1.0))
		queue_free()
		already_shown = true
