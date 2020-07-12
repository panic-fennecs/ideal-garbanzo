extends Spatial

func _physics_process(_delta):
	$"Label3D/CanvasLayer/Label".text = str($"/root/Main".get_num_finished_sheep()) + "/" + String(len($"/root/Main".sheep)) + " sheep"
