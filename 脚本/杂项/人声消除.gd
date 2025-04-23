extends AudioStreamPlayer
@export var 人声消除:bool
var 音频流:AudioStreamGeneratorPlayback
var 音效:AudioEffect
func _ready():
	self.play()
	音频流 = self.get_stream_playback()
	pass
func _process(帧处理: float) -> void:
	AudioServer.set_bus_mute(17,人声消除)
	if 人声消除==true:
		var 样本=音效.get_buffer(4096)
		for 循环 in 样本.size():
			音频流.push_frame(Vector2.ONE * (样本[循环][0]-样本[循环][1]))
	pass
