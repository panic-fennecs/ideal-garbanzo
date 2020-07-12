extends Spatial

var start_time = null

func _ready():
	start_time = OS.get_unix_time()

func elapsed_time():
	return OS.get_unix_time() - start_time

func _process(delta):
	var seconds = elapsed_time()
	var minutes = floor(seconds / 60)
	seconds = seconds % 60
	if minutes > 0:
		$ElapsedTimeLabel.text = String(minutes) + " minutes   " + String(seconds) + " seconds"
	else:
		$ElapsedTimeLabel.text = String(seconds) + " seconds"
	$FpsLabel.text = String(Performance.get_monitor(Performance.TIME_FPS)) + " fps"
