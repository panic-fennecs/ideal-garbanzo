extends Spatial

var start_time = null

func _ready():
	start_time = OS.get_unix_time()

func elapsed_time():
	return OS.get_unix_time() - start_time

func _process(delta):
	$ElapsedTimeLabel.text = String(elapsed_time()) + " seconds"
	$FpsLabel.text = String(Performance.get_monitor(Performance.TIME_FPS)) + " fps"
