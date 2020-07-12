extends Spatial

func _process(_delta):
	$"Label3D/CanvasLayer/Label".text = String(len($"/root/Main".sheep)) + " Sheep"
