extends Control

func _ready():
	rect_position = Vector2(rect_position.x, get_viewport_rect().size.y - 600)

func show_achievement(title: String, text: String, color: Color) -> void:
	$ColorRect/Label2.text = title	
	$ColorRect/Label.text = text
	if color != null:
		$ColorRect.color = color
	$AnimationPlayer.play("Show")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
