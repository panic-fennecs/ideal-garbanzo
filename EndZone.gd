extends Spatial

func _ready():
	pass

func sheep_count():
	var sheeps = $"/root/Main".sheep
	var count = 0
	for sheep in sheeps:
		if sheep.in_finish:
			count = count + 1
	return count

func _process(_delta):
	$"Label3D/CanvasLayer/Label".text = String(sheep_count()) + " Sheep"
