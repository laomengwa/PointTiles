extends PanelContainer
var 通知音符音效:Array=[{
		"音色":0,
		"时间":0,
		"半音":74
	},{
		"音色":0,
		"时间":0.2,
		"半音":81
	},{
		"音色":0,
		"时间":0.3,
		"半音":78
	}]
func _ready():
	$"界面动画".play("推送通知")
	#发送Toast通知
	if OS.get_name()=="Android":
		var 安卓运行时=Engine.get_singleton("AndroidRuntime")
		if 安卓运行时:
			#获取游戏的当前Activity
			var 页面上下文=安卓运行时.getActivity()
			var 通知标题=$"控件/标题".text
			var 简短消息提示=func():
				var 通知组件=JavaClassWrapper.wrap("android.widget.Toast")
				通知组件.makeText(页面上下文,通知标题,通知组件.LENGTH_SHORT).show()
			页面上下文.runOnUiThread(安卓运行时.createRunnableFromGodotCallable(简短消息提示))
	#通知音效
	for 循环 in 通知音符音效.size():
		var 按下=InputEventMIDI.new()
		按下.channel=0
		按下.pitch=通知音符音效[循环].半音
		按下.velocity=127
		按下.instrument=通知音符音效[循环].音色
		按下.message=MIDI_MESSAGE_NOTE_ON
		$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(按下)
		if 循环>0:
			var 音符松开=InputEventMIDI.new()
			音符松开.channel=0
			音符松开.pitch=通知音符音效[循环-1].半音
			音符松开.velocity=127
			音符松开.instrument=通知音符音效[循环-1].音色
			音符松开.message=MIDI_MESSAGE_NOTE_OFF
			$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(音符松开)
		await get_tree().create_timer(通知音符音效[循环].时间).timeout
	var 松开=InputEventMIDI.new()
	松开.channel=0
	松开.pitch=通知音符音效[通知音符音效.size()-1].半音
	松开.velocity=127
	松开.instrument=通知音符音效[通知音符音效.size()-1].音色
	松开.message=MIDI_MESSAGE_NOTE_OFF
	$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(松开)
	pass

func 关闭通知():
	$"界面动画".play("推送通知关闭")	#通知音效
	for 循环 in 通知音符音效.size():
		var 按下=InputEventMIDI.new()
		按下.channel=0
		按下.pitch=通知音符音效[通知音符音效.size()-循环-1].半音
		按下.velocity=127
		按下.instrument=通知音符音效[通知音符音效.size()-循环-1].音色
		按下.message=MIDI_MESSAGE_NOTE_ON
		$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(按下)
		if 循环>0:
			var 音符松开=InputEventMIDI.new()
			音符松开.channel=0
			音符松开.pitch=通知音符音效[通知音符音效.size()-循环].半音
			音符松开.velocity=127
			音符松开.instrument=通知音符音效[通知音符音效.size()-循环].音色
			音符松开.message=MIDI_MESSAGE_NOTE_OFF
			$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(音符松开)
		await get_tree().create_timer(通知音符音效[通知音符音效.size()-1].时间-通知音符音效[通知音符音效.size()-循环-1].时间).timeout
	var 松开=InputEventMIDI.new()
	松开.channel=0
	松开.pitch=通知音符音效[0].半音
	松开.velocity=127
	松开.instrument=通知音符音效[0].音色
	松开.message=MIDI_MESSAGE_NOTE_OFF
	$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(松开)
	pass

func 删除通知(动画名):
	if 动画名=="推送通知关闭":
		self.queue_free()
	pass
