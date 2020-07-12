extends Spatial

func _process(_delta):
	$"Label3D/CanvasLayer/Label".text = $"/root/Main".get_num_finished_sheep() + "/" + String(len($"/root/Main".sheep)) + " sheep"
