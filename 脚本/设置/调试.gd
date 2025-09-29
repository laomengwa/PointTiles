extends ScrollContainer

func _process(_帧处理):
	#帧率显示
	if $'/root/根场景/根界面/主菜单'.visible == false && $'调试/其他/容器/帧率显示/勾选盒'.button_pressed || $'/root/根场景/根界面/设置'.visible == true && $'调试/其他/容器/帧率显示/勾选盒'.button_pressed:
		$"../../../调试信息/帧率文字".show()
		$"../../../调试信息/分隔1".show()
		$"../../../调试信息/帧率显示".show()
		$"../../../调试信息/分隔2".show()
		$'/root/根场景/根界面/调试信息/帧率显示'.text="%d" %Performance.get_monitor(Performance.TIME_FPS);
	else:
		$"../../../调试信息/帧率文字".hide()
		$"../../../调试信息/分隔1".hide()
		$"../../../调试信息/帧率显示".hide()
		$"../../../调试信息/分隔2".hide()
	#内存显示
	if $'/root/根场景/根界面/主菜单'.visible == false && $"调试/其他/容器/内存显示/勾选盒".button_pressed || $'/root/根场景/根界面/设置'.visible == true && $"调试/其他/容器/内存显示/勾选盒".button_pressed:
		var 内存大小=Performance.get_monitor(Performance.MEMORY_STATIC)
		$'/root/根场景/根界面/调试信息/内存显示'.text = 全局脚本.存储单位转换(内存大小)
		$"../../../调试信息/内存文字".show()
		$"../../../调试信息/分隔3".show()
		$"../../../调试信息/内存显示".show()
	else:
		$"../../../调试信息/内存文字".hide()
		$"../../../调试信息/分隔3".hide()
		$"../../../调试信息/内存显示".hide()
	pass
func _ready():
	for 按钮循环 in 127:
		var 钢琴键盘测试=Button.new()
		钢琴键盘测试.text=("%02X" % 按钮循环)
		钢琴键盘测试.custom_minimum_size=Vector2(0,200)
		钢琴键盘测试.focus_entered.connect(钢琴键盘按下.bind(按钮循环))
		钢琴键盘测试.mouse_entered.connect(钢琴键盘滑动.bind(钢琴键盘测试))
		钢琴键盘测试.focus_exited.connect(钢琴键盘松开.bind(按钮循环))
		$"调试/钢琴键盘测试/容器/键盘/容器".add_child(钢琴键盘测试)
	#test_java()
	pass # Replace with function body.
func 钢琴键盘滑动(按钮):
	按钮.grab_focus()
	pass
func 钢琴键盘按下(半音):
	#$"/root/根场景/外置波表输出".输出音符(MIDI_MESSAGE_NOTE_ON,乐器通道,乐器音色,半音,127,0,0,0)
	var 输入事件=InputEventMIDI.new()
	输入事件.channel=乐器通道
	输入事件.pitch=半音
	输入事件.velocity=127
	输入事件.instrument=乐器音色
	输入事件.message=MIDI_MESSAGE_NOTE_ON
	$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(输入事件)
	pass
	
func 钢琴键盘松开(半音):
	#$"/root/根场景/外置波表输出".输出音符(MIDI_MESSAGE_NOTE_OFF,乐器通道,乐器音色,半音,127,0,0,0)
	#print(instance_from_id(2647058814669).get_script().resource_path)
	var 输入事件=InputEventMIDI.new()
	输入事件.channel=乐器通道
	输入事件.pitch=半音
	输入事件.instrument=乐器音色
	输入事件.message=MIDI_MESSAGE_NOTE_OFF
	$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(输入事件)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
var 乐器音色=0
var 乐器通道=0
func 乐器音色测试(value):
	乐器音色=int(value)
	$调试/钢琴键盘测试/容器/音色/数值.text=var_to_str(int(value))
	pass # Replace with function body.

func 乐器通道测试(value):
	乐器通道=int(value)
	$调试/钢琴键盘测试/容器/通道/数值.text=var_to_str(int(value))
	pass # Replace with function body.

func 帧率显示选项():
	if $'调试/其他/容器/帧率显示/勾选盒'.button_pressed:
		$"../../../调试信息/帧率文字".hide()
		$"../../../调试信息/分隔1".hide()
		$"../../../调试信息/帧率显示".hide()
		$"../../../调试信息/分隔2".hide()
	else:
		$"../../../调试信息/帧率文字".show()
		$"../../../调试信息/分隔1".show()
		$"../../../调试信息/帧率显示".show()
		$"../../../调试信息/分隔2".show()
	pass


func 内存显示选项() -> void:
	if $"调试/其他/容器/内存显示/勾选盒".button_pressed:
		$"../../../调试信息/内存文字".hide()
		$"../../../调试信息/分隔3".hide()
		$"../../../调试信息/内存显示".hide()
	else:
		$"../../../调试信息/内存文字".show()
		$"../../../调试信息/分隔3".show()
		$"../../../调试信息/内存显示".show()
	pass # Replace with function body.

func 触摸位置显示() -> void:
	$"../../../".触摸显示=!$"调试/其他/容器/触摸位置显示/勾选盒".button_pressed
	pass
func 显示调试编号() -> void:
	全局脚本.物件轨道编号显示=!$"调试/其他/容器/显示物件与轨道编号/勾选盒".button_pressed
	pass

func 存储单位变更() -> void:
	全局脚本.存储单位判断=!$"调试/其他/容器/使用以十进位存储单位/勾选盒".button_pressed
	pass # Replace with function body.
	
func 外置输入测试() -> void:
	#if 执行后进程==-1:
		#执行后进程=(OS.create_process("fluidsynth", ["-a","alsa","-m","alsa_seq","-g","1.0","/home/mengwa/Documents/3/音乐/TimGM6mb.sf2"]))
	pass # Replace with function body.
