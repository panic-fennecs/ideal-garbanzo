extends Control

func show_achievement(text: String) -> void:
	$ColorRect/Label2.text = text
	$AnimationPlayer.play("Show")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
