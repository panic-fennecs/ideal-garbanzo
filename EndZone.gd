extends Spatial

func _ready():
	pass

func sheep_count():
	var sheeps = $"/root/Main".sheep
	var area = $"Area"
	var count = 0
	for sheep in sheeps:
		if area.overlaps_body(sheep):
			count = count + 1
	return count

func _process(delta):
	$"Label3D/CanvasLayer/Label".text = String(sheep_count()) + " Sheep"
