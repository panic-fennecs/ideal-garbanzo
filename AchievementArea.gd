extends Area

onready var Achievement = preload("res://Achievement.tscn")

var entered_sheep = []

func _on_AchievementArea_body_entered(body):
	if body.is_in_group("sheep"):
		if entered_sheep.find(body) == -1:
			entered_sheep.append(body)
			if entered_sheep.size() > 10:
				var achievement = Achievement.instance()
				$"/root/Main".add_child(achievement)
				achievement.show_achievement("achievement unlocked", "cross the river")
				queue_free()
	
