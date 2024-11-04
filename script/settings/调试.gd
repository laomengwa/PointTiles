extends ScrollContainer

var 帧率显示=true
var 内存显示=true
func _process(delta):
	#帧率显示
	if $'/root/根场景/根界面/主菜单'.visible == false && 帧率显示 == true || $'/root/根场景/根界面/设置'.visible == true && 帧率显示 == true:
		$'/root/根场景/根界面/调试信息/帧率文字'.show()
		$'/root/根场景/根界面/调试信息/分隔1'.show()
		$'/root/根场景/根界面/调试信息/帧率显示'.show()
		$'/root/根场景/根界面/调试信息/帧率显示'.text=var_to_str(Performance.get_monitor(Performance.TIME_FPS));
	else:
		$'/root/根场景/根界面/调试信息/帧率文字'.hide()
		$'/root/根场景/根界面/调试信息/分隔1'.hide()
		$'/root/根场景/根界面/调试信息/帧率显示'.hide()
	#内存显示
	if $'/root/根场景/根界面/主菜单'.visible == false && 帧率显示 == true || $'/root/根场景/根界面/设置'.visible == true && 帧率显示 == true:
		$'/root/根场景/根界面/调试信息/内存文字'.show()
		$'/root/根场景/根界面/调试信息/分隔3'.show()
		$'/root/根场景/根界面/调试信息/内存显示'.show()
		var 内存大小=Performance.get_monitor(Performance.MEMORY_STATIC)
		if 内存大小/1024 > pow(1024,3):
			$'/root/根场景/根界面/调试信息/内存显示'.text = ("%.2f" %(float(内存大小)/pow(1024,3)))+"TiB"
		elif 内存大小/1024 > pow(1024,2):
			$'/root/根场景/根界面/调试信息/内存显示'.text = ("%.2f" %(float(内存大小)/pow(1024,3)))+"GiB"
		elif 内存大小/1024 > pow(1024,1):
			$'/root/根场景/根界面/调试信息/内存显示'.text = ("%.2f" %(float(内存大小)/pow(1024,2)))+"MiB"
		elif 内存大小/1024 > pow(1024,0):
			$'/root/根场景/根界面/调试信息/内存显示'.text = ("%.2f" %(float(内存大小)/1024.0))+"KiB"
		else:
			$'/root/根场景/根界面/调试信息/内存显示'.text = var_to_str(内存大小)+"B"
	else:
		$'/root/根场景/根界面/调试信息/内存文字'.hide()
		$'/root/根场景/根界面/调试信息/分隔3'.hide()
		$'/root/根场景/根界面/调试信息/内存显示'.hide()
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
	var 输入事件=InputEventMIDI.new()
	输入事件.channel=乐器通道
	输入事件.pitch=半音
	输入事件.velocity=127
	输入事件.instrument=乐器音色
	输入事件.message=MIDI_MESSAGE_NOTE_ON
	$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(输入事件)
	pass
	
func 钢琴键盘松开(半音):
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
	if 帧率显示==false:
		$'../设置/设置选项/视频/视频/界面调整/容器/帧率/勾选盒'.button_pressed = false
		帧率显示=true
	else:
		$'../设置/设置选项/视频/视频/界面调整/容器/帧率/勾选盒'.button_pressed = true
		帧率显示=false
	pass


#func _on_测试_button_down():
	#var 测试=JavaClass.new()
	#pass # Replace with function body.
#
#
#
#var singleton = null
#var rixnet = null;
#
#
#func test_java_singleton():
	#var c_java = JavaClassWrapper.wrap("com/godot/game/testJava");
	#print("c_java==", c_java)
	#var c_test  = c_java.initialize();
	#print("c_test=", c_test);
	#print("c_test kk^=", c_test.myFunction("in GD"))
	#
#func test_singleton():
	#rixnet = Engine.get_singleton("RixNet")
	#print("rixnet=", rixnet);
	#rixnet.connect("test.net", 5000, 1);
	#var test_packet = rixnet.getPacket();
	#print("test_packet= ", test_packet)
	#print("test_packet cmd=", test_packet.getCmd());
	#print("test_packet buf", test_packet.getBuf());
	#singleton = Engine.get_singleton("MySingleton")
	#print(singleton.myFunction("Hello"))
	#singleton.getInstanceId(get_instance_id())
	#
#func test_java():
	#test_singleton()
	#var java_c = JavaClassWrapper.wrap("com/godot/game/testJava2")
	#var java_packet = JavaClassWrapper.wrap("com/rix/lib/socket/Packet")
	#print("java_c = ", java_c)
	#var new_java = java_c.new()
	#print("new_java=", new_java)
	#print("new_java myFunction=", new_java.myFunction("GDTEST"))
	#print("new_java testString=", new_java.testString())
	#print("new_java testStringWithArgs=", new_java.testStringWithArgs("fff", 123))
	#var p = java_packet.new(10, 2, PackedByteArray([0xF,0xE,0xD,0xC,0xB,0xA,9,8,7,6,5,4,3,2,1,0]), 2)
	#print("packet=",p)
	#print("new_java testPacket", new_java.testPacket(3, p))
	#print("new_java testPacket 2", new_java.testPacket(2, p))
	#print("packet2=",p)
	#print("rix_net send=", rixnet.sendmessage(p))
