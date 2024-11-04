extends AudioStreamPlayer3D
var 播放时间:float = 0.0
var 自动位置偏差:float=0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $'/root/根场景/根界面/游戏界面'.自动演奏拖拽状态==false:
		$'/root/根场景/根界面/游戏界面/自动演奏时间轴'.value=播放时间
	if is_playing()==true:
		播放时间 = get_playback_position()
		if self.stream.to_string().find('MP3')>=0||self.stream.to_string().find('WAV')>=0||self.stream.to_string().find('Ogg')>=0:
			播放时间 = get_playback_position()+1.5+GlobalScript.音频延迟
		else:
			播放时间 = get_playback_position()+自动位置偏差+GlobalScript.音频延迟
	pass


func 背景音乐计时器():
	if is_playing()==false&&self.stream.to_string().find('MP3')>=0||self.stream.to_string().find('WAV')>=0||self.stream.to_string().find('Ogg')>=0:
			if 播放时间>=1.5+GlobalScript.音频延迟:
				播放时间 = get_playback_position()+1.5+GlobalScript.音频延迟
				play()
				$'/root/根场景/主场景/开始按键/背景音乐计时器'.stop()
			else:
				播放时间=播放时间+0.05
	pass # Replace with function body.
