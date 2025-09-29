extends Control
var 触摸纹理=preload("res://纹理/界面/触屏显示.svg")
var 触摸显示:bool=false
var 音效播放状态:bool=false
func _ready():
	$设置/设置选项/关于/关于/鸣谢/容器/正文/游戏引擎标识.text="该游戏使用 Godot 游戏引擎制作。\n引擎版本：%s"%Engine.get_version_info().string
	#限制游戏窗口大小
	get_viewport().min_size=Vector2(400,300)
	$设置/设置选项/关于/关于/关于/容器/游戏版本.text="游戏版本：%s"% $主菜单/版本号.text + "_"+ ProjectSettings.get_setting('application/config/version')+ "_"+ OS.get_name()+"_"+Engine.get_architecture_name();
	$主菜单/版本号.text = $主菜单/版本号.text + "_"+ ProjectSettings.get_setting('application/config/version')+ "_"+ OS.get_name()+"_"+Engine.get_architecture_name();
	if OS.get_name()=="Linux":
		$设置/设置选项/关于/关于/关于/容器/游戏平台/标识.text=OS.get_distribution_name().replace(" Linux","")+" "+OS.get_name()
	else:
		$设置/设置选项/关于/关于/关于/容器/游戏平台/标识.text=OS.get_name()
	if OS.get_processor_name()!="":
		$设置/设置选项/关于/关于/关于/容器/处理器信息/标识.text=OS.get_processor_name()+" "+Engine.get_architecture_name()
	else:
		#获取安卓系统的处理器信息：
		if OS.get_name()=="Android":
			#var 脚本运行结果 = []
			#OS.execute("cat", ["/proc/cpuinfo"], 脚本运行结果)
			#var 处理器信息:String
			#var 字符开始位置=脚本运行结果[0].find('\nHardware\t:')+11
			#var 字符末尾位置=脚本运行结果[0].rfind('\n')
			#处理器信息=脚本运行结果[0].substr(字符开始位置,字符末尾位置-字符开始位置)
			#$设置/设置选项/关于/关于/关于/容器/处理器信息/标识.text=处理器信息+" "+Engine.get_architecture_name()
			var 安卓交互接口 = JavaClassWrapper.wrap("android.os.Build")
			var 处理器信息 = 安卓交互接口.HARDWARE
			$设置/设置选项/关于/关于/关于/容器/处理器信息/标识.text=处理器信息+" "+Engine.get_architecture_name()
		#获取 FreeBSD, NetBSD, OpenBSD 系统的处理器信息
		elif OS.get_name().find("BSD"):
			var 脚本运行结果 = []
			OS.execute("sysctl", ["hw.model"], 脚本运行结果)
			var 处理器信息:String
			var 字符开始位置=脚本运行结果[0].find('hw.model=')+9
			var 字符末尾位置=脚本运行结果[0].rfind('\n')
			处理器信息=脚本运行结果[0].substr(字符开始位置,字符末尾位置-字符开始位置)
			$设置/设置选项/关于/关于/关于/容器/处理器信息/标识.text=处理器信息+" "+Engine.get_architecture_name()
			pass
			
	$设置/设置选项/关于/关于/关于/容器/显示卡信息/标识.text=RenderingServer.get_video_adapter_vendor()+" "+RenderingServer.get_video_adapter_name()
	match RenderingServer.get_current_rendering_driver_name():
		"opengl3","opengl3_es","opengl3_angle":
			$设置/设置选项/视频/视频/画质/容器/体积雾.hide()
			$设置/设置选项/视频/视频/画质/容器/多重采样抗锯齿.hide()
			$设置/设置选项/视频/视频/画质/容器/快速近似抗锯齿.hide()
			$设置/设置选项/视频/视频/画质/容器/屏幕空间反射.hide()
			$设置/设置选项/视频/视频/画质/容器/屏幕空间间接照明.hide()
			if RenderingServer.get_video_adapter_api_version().count("OpenGL"):
				$设置/设置选项/关于/关于/关于/容器/图形渲染器信息/标识.text=RenderingServer.get_video_adapter_api_version()
			else:
				$设置/设置选项/关于/关于/关于/容器/图形渲染器信息/标识.text="OpenGL"+" "+RenderingServer.get_video_adapter_api_version()
		"vulkan":
			$设置/设置选项/关于/关于/关于/容器/图形渲染器信息/标识.text="Vulkan"+" "+RenderingServer.get_video_adapter_api_version()
		"d3d12":
			#Windows 系统专属
			$设置/设置选项/关于/关于/关于/容器/图形渲染器信息/标识.text="DirectX 12"+" "+RenderingServer.get_video_adapter_api_version()
		"metal":
			#MacOS X 系统专属
			$设置/设置选项/关于/关于/关于/容器/图形渲染器信息/标识.text="Metal"+" "+RenderingServer.get_video_adapter_api_version()
	pass # Replace with function body.

func _notification(通知):
	#当按下关闭窗口时
	if 通知 == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().set_auto_accept_quit(false)
		if $'游戏界面'.visible == true:
			$'../视角节点/背景音乐播放节点'.set_stream_paused(true)
		退出按钮()
	#安卓端返回处理方法
	if 通知 == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().set_auto_accept_quit(false)
		返回事件()
	#监听游戏过程中鼠标离开游戏画面
	if 通知 == NOTIFICATION_WM_MOUSE_EXIT ||通知 == NOTIFICATION_APPLICATION_FOCUS_OUT ||通知 == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		if $触摸显示.get_child_count()!=0:
			for 循环 in $触摸显示.get_child_count():
				$触摸显示.get_child(循环).queue_free()
		#if $'游戏界面'.visible == true && $'结算画面'.visible == false && $'窗口/暂停窗口'.visible == false &&$'../视角节点/背景音乐播放节点'.is_playing()==true:
			#$'游戏界面'.暂停函数()
	pass
func _process(_帧处理):
	#3D画面随窗口大小自适应
	if $/root/根场景/视角节点/摄像机.projection==1:
		#如果摄像机视角是正交状态
		if float(get_window().get_size()[1])/float(get_window().get_size()[0])>1.4:
			$/root/根场景/视角节点/摄像机.size=(float(get_window().get_size()[1])/float(get_window().get_size()[0]))*get_node("/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/轨道数量/滑块").value*2
			#print(float(get_window().get_size()[1])/float(get_window().get_size()[0]))
			if $/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/无轨道模式/选项勾选盒.button_pressed==false:
				$/root/根场景/视角节点.position=Vector3(get_node("/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/轨道数量/滑块").value-4,4*(float(get_window().get_size()[1])/float(get_window().get_size()[0]))-(11.5-get_node("/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/轨道数量/滑块").value),-5.0)
			else:
				$/root/根场景/视角节点.position=Vector3(0,4*(float(get_window().get_size()[1])/float(get_window().get_size()[0]))-(11.5-get_node("/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/轨道数量/滑块").value),-5.0)
		else:
			$/root/根场景/视角节点/摄像机.size=16
			if $/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/无轨道模式/选项勾选盒.button_pressed==false:
				$/root/根场景/视角节点.position=Vector3(get_node("/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/轨道数量/滑块").value-4,0,-5)
			else:
				$/root/根场景/视角节点.position=Vector3(0,0,-5)
	pass
#键盘输入检测
func _input(事件):
	#给按钮添加音效
	if get_viewport().gui_get_focus_owner():
		var 节点:Control=get_viewport().gui_get_focus_owner()
		if 节点.has_signal("pressed"):
			if 节点.pressed.is_connected(按钮音效)==false:
				节点.pressed.connect(按钮音效)
		if 节点.has_signal("focus_entered"):
			if 节点.focus_entered.is_connected(按钮音效)==false:
				节点.focus_entered.connect(按钮音效)
		#if 节点.has_signal("drag_ended"):
			#if 节点.drag_ended.is_connected(按钮音效)==false:
				#节点.drag_ended.connect(按钮音效)
		if 节点.has_signal("drag_started"):
			if 节点.drag_started.is_connected(按钮音效)==false:
				节点.drag_started.connect(按钮音效)
	#var 手柄控制鼠标指针向上=Input.get_action_strength("手柄右摇杆上")
	#var 手柄控制鼠标指针向下=Input.get_action_strength("手柄右摇杆下")
	#var 手柄控制鼠标指针向左=Input.get_action_stresngth("手柄右摇杆左")
	#var 手柄控制鼠标指针向右=Input.get_action_strength("手柄右摇杆右")
	#Input.warp_mouse(get_viewport().get_mouse_position()+Vector2(手柄控制鼠标指针向右-手柄控制鼠标指针向左,手柄控制鼠标指针向下-手柄控制鼠标指针向上)*5)
	#print(get_viewport().get_mouse_position()+Vector2(手柄控制鼠标指针向右-手柄控制鼠标指针向左,手柄控制鼠标指针向下-手柄控制鼠标指针向上)*5)
	if 事件 is InputEventKey:
		match 事件.keycode:
			KEY_ESCAPE:
				返回事件()
		pass
	#触摸手指测试
	if 触摸显示==true:
		if 事件 is InputEventScreenTouch:
			if 事件.pressed==true:
				var 触摸节点=Sprite2D.new()
				触摸节点.name=var_to_str(事件.index)
				触摸节点.set_texture(触摸纹理)
				触摸节点.position=事件.get_position()
				$触摸显示.add_child(触摸节点)
			else:
				if $触摸显示.has_node(var_to_str(事件.index)):
					get_node("触摸显示/"+var_to_str(事件.index)).queue_free()
		if 事件 is InputEventScreenDrag:
			if !$触摸显示.has_node(var_to_str(事件.index)):
				var 触摸节点=Sprite2D.new()
				触摸节点.name=var_to_str(事件.index)
				触摸节点.set_texture(触摸纹理)
				触摸节点.position=事件.get_position()
				$触摸显示.add_child(触摸节点)
			get_node("触摸显示/"+var_to_str(事件.index)).position=事件.get_position()
	else:
		if $触摸显示.get_child_count()!=0:
			for 循环 in $触摸显示.get_child_count():
				$触摸显示.get_child(循环).queue_free()
	pass
func 按钮音效()->void:
	if 音效播放状态==false:
		var 半音=randi_range(48, 96)
		var 通道=0
		var 输入事件=InputEventMIDI.new()
		输入事件.channel=通道
		输入事件.pitch=半音
		输入事件.velocity=127
		输入事件.instrument=$'/root/根场景/视角节点/MidiPlayer'.channel_status[通道].program
		输入事件.message=MIDI_MESSAGE_NOTE_ON
		音效播放状态=true
		$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(输入事件)
		await get_tree().create_timer(0.2).timeout
		输入事件.message=MIDI_MESSAGE_NOTE_OFF
		$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(输入事件)
		音效播放状态=false
	pass
#弹出退出窗口
func 返回事件():
	#游戏暂停
	if $'游戏界面'.visible == true&&$'结算画面'.visible == false&&$'设置'.visible == false&&$'游戏界面/界面动画'.is_playing()==false&&$'界面动画'.is_playing()==false&&全局脚本.游戏开始状态==true:
		if $窗口/暂停窗口.visible == false:
			$'游戏界面'.暂停()
		elif $窗口/暂停窗口.visible == true:
			$'游戏界面'.继续()
	#游戏退出窗口
	elif $'窗口/游戏退出'.visible==true&&$'界面动画'.is_playing()==false:
		退出窗口关闭()
	elif $'窗口/界面安全区偏移'.visible==true:
		$'设置'.安全区设置关闭()
	elif $设置.visible == true:
		$'设置'.设置返回()
	elif $结算画面.visible==true&&$'游戏界面/界面动画'.is_playing()==false&&$'游戏界面'.visible == false:
		#结算界面关闭
		$'游戏界面'.返回()
	elif $主菜单.visible==true&&$'界面动画'.is_playing()==false:
		#游戏退出窗口
		退出按钮()
	elif $'游戏菜单'.visible==true&&$'界面动画'.is_playing()==false:
		#游戏选歌界面退出
		$'游戏菜单'.菜单按钮按下()
	pass
func 退出按钮():
	$'界面动画'.play("退出游戏")
	pass
#游戏菜单界面
func 进入菜单():
	$'界面动画'.play("进入选歌列表")
	$"主菜单/图标/画布/图标".hide()
	get_node("/root/根场景/视角节点/三维动画节点").play("开始")
	pass # Replace with function body.

func 设置按钮():
	$'设置/界面动画'.play('设置界面打开')
	pass # Replace with function body.

func 游戏退出函数():#退出按钮
	get_tree().quit()#退出函数
	pass # Replace with function body.

func 退出窗口关闭():#对话框取消按钮
	$'界面动画'.play("退出窗口关闭")
	pass # Replace with function body.


func 倾斜轨道():
	$"/root/根场景/视角节点".恢复摄像机状态()
	pass # Replace with function body.

func 无轨道模式():
	if $游戏菜单/歌曲信息/歌曲信息/容器/无轨道模式/选项勾选盒.button_pressed == true:
		$/root/根场景/主场景/轨道.show()
		$/root/根场景/主场景/无轨.hide()
		$'游戏界面/历史成绩/标签/玩法'.text="有轨下落式"
		$'游戏界面/历史成绩/标签/键数'.show()
		$"游戏菜单/歌曲信息/歌曲信息/容器/轨道数量".show()
	else:
		$/root/根场景/主场景/轨道.hide()
		$/root/根场景/主场景/无轨.show()
		$'游戏界面/历史成绩/标签/玩法'.text="无轨"
		$'游戏界面/历史成绩/标签/键数'.hide()
		$"游戏菜单/歌曲信息/歌曲信息/容器/轨道数量".hide()
	pass # Replace with function body.


func 内置歌曲列表():
	#在竖屏状态下如果处在详细页面中就执行返回操作
	if $游戏菜单.界面宽度检测==true&&$游戏菜单.竖屏界面布局检测==true:
		返回事件()
	if $游戏菜单/界面左列表/表格/容器.visible==false:
		$"游戏菜单/界面左列表/界面动画列表".play("内置")
		if $"游戏菜单/歌曲信息/文本".visible==false&&$"游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称".text!="歌曲选项测试":
			$"游戏菜单/歌曲信息/界面动画".play("文字提示关闭")
	pass # Replace with function body.


func 自定义歌曲列表():
	#在竖屏状态下如果处在详细页面中就执行返回操作
	if $游戏菜单.界面宽度检测==true&&$游戏菜单.竖屏界面布局检测==true:
		返回事件()
	if $游戏菜单/界面左列表/表格/自定义.visible==false:
		$"游戏菜单/界面左列表/界面动画列表".play('自定义')
		if $"游戏菜单/歌曲信息/文本".visible==false&&$"游戏菜单/歌曲信息/自定义谱师信息/表格/封面信息/信息/表格/标题".text!="合集名称测试":
			$"游戏菜单/歌曲信息/界面动画".play("歌曲合集详介")
	pass # Replace with function body.

#物件下落玩法的选项
func 物件下落方向(选项):
	match 选项:
		0:
			$'/root/根场景/视角节点'.rotation_degrees=Vector3($'/root/根场景/视角节点'.rotation_degrees[0],$'/root/根场景/视角节点'.rotation_degrees[1],0)
		1:
			$'/root/根场景/视角节点'.rotation_degrees=Vector3($'/root/根场景/视角节点'.rotation_degrees[0],$'/root/根场景/视角节点'.rotation_degrees[1],180)
	pass # Replace with function body.
