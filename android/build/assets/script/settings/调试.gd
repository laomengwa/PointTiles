extends ScrollContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	for 按钮循环 in 127:
		var 钢琴键盘测试=Button.new()
		钢琴键盘测试.text=("%02X" % 按钮循环)
		钢琴键盘测试.custom_minimum_size=Vector2(0,200)
		钢琴键盘测试.focus_entered.connect(钢琴键盘按下.bind(按钮循环))
		钢琴键盘测试.mouse_entered.connect(钢琴键盘滑动.bind(钢琴键盘测试))
		钢琴键盘测试.focus_exited.connect(钢琴键盘松开.bind(按钮循环))
		$"调试/钢琴键盘测试/容器/键盘/容器".add_child(钢琴键盘测试)
	pass # Replace with function body.
func 钢琴键盘滑动(按钮):
	按钮.grab_focus()
	pass
func 钢琴键盘按下(半音):
	var 输入事件=InputEventMIDI.new()
	输入事件.channel=0
	输入事件.pitch=半音
	输入事件.velocity=127
	输入事件.instrument=乐器音色
	输入事件.message=MIDI_MESSAGE_NOTE_ON
	$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(输入事件)
	pass
	
func 钢琴键盘松开(半音):
	var 输入事件=InputEventMIDI.new()
	输入事件.channel=0
	输入事件.pitch=半音
	输入事件.instrument=乐器音色
	输入事件.message=MIDI_MESSAGE_NOTE_OFF
	$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(输入事件)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
var 乐器音色=0
func 乐器音色测试(value):
	乐器音色=int(value)
	$调试/钢琴键盘测试/容器/音色/数值.text=var_to_str(int(value))
	pass # Replace with function body.
