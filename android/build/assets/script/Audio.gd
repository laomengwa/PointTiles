extends AudioStreamPlayer3D
var 播放时间 = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing:
		播放时间 = get_playback_position()
	pass
