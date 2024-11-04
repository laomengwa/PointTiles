extends Control
# Called when the node enters the scene tree for the first time.
func _ready():
	$主菜单/版本号.text = $主菜单/版本号.text + " "+ OS.get_name()+" "+Engine.get_architecture_name();
	if OS.get_name()=="Linux":
		$设置/设置选项/关于/关于/关于/容器/游戏平台/标识.text=OS.get_distribution_name()+" "+OS.get_name()
	else:
		$设置/设置选项/关于/关于/关于/容器/游戏平台/标识.text=OS.get_name()
	#获取非安卓系统的处理器信息：
	if OS.get_name()!="Android":
		$设置/设置选项/关于/关于/关于/容器/处理器信息/标识.text=OS.get_processor_name()+" "+Engine.get_architecture_name()
	else:
		#针对安卓系统获取处理器信息
		var 脚本运行结果 = []
		OS.execute("cat", ["/proc/cpuinfo"], 脚本运行结果)
		var 处理器信息:String
		var 字符开始位置=脚本运行结果[0].find('\nHardware\t:')+11
		var 字符末尾位置=脚本运行结果[0].rfind('\n')
		处理器信息=脚本运行结果[0].substr(字符开始位置,字符末尾位置-字符开始位置)
		$设置/设置选项/关于/关于/关于/容器/处理器信息/标识.text=处理器信息+" "+Engine.get_architecture_name()
	$设置/设置选项/关于/关于/关于/容器/显示卡信息/标识.text=RenderingServer.get_video_adapter_vendor()+" "+RenderingServer.get_video_adapter_name()
	#print(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	#print(RenderingServer.get_video_adapter_api_version())
	#print(RenderingServer.get_video_adapter_type())
	#操作系统检测
	pass # Replace with function body.

func _notification(what):
	#当按下关闭窗口时
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().set_auto_accept_quit(false)
		if $'游戏界面'.visible == true:
			$'../视角节点/背景音乐播放节点'.set_stream_paused(true)
		退出按钮()
	#安卓端返回处理方法
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().set_auto_accept_quit(false)
		返回事件()
	#监听游戏过程中鼠标离开游戏画面
	if what == NOTIFICATION_WM_MOUSE_EXIT ||what == NOTIFICATION_APPLICATION_FOCUS_OUT ||what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		if $'游戏界面'.visible == true && $'结算画面'.visible == false && $'窗口/暂停窗口'.visible == false &&$'../视角节点/背景音乐播放节点'.is_playing()==true:
			$'游戏界面'.暂停函数()
	pass
func _process(delta):
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
func _input(event):
	#var 手柄控制鼠标指针向上=Input.get_action_strength("手柄右摇杆上")
	#var 手柄控制鼠标指针向下=Input.get_action_strength("手柄右摇杆下")
	#var 手柄控制鼠标指针向左=Input.get_action_stresngth("手柄右摇杆左")
	#var 手柄控制鼠标指针向右=Input.get_action_strength("手柄右摇杆右")
	#Input.warp_mouse(get_viewport().get_mouse_position()+Vector2(手柄控制鼠标指针向右-手柄控制鼠标指针向左,手柄控制鼠标指针向下-手柄控制鼠标指针向上)*5)
	#print(get_viewport().get_mouse_position()+Vector2(手柄控制鼠标指针向右-手柄控制鼠标指针向左,手柄控制鼠标指针向下-手柄控制鼠标指针向上)*5)
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				返回事件()
		pass
	pass
#弹出退出窗口
func 返回事件():
	if $'游戏界面'.visible == true&&$'结算画面'.visible == false&&$'设置'.visible == false:
		$'游戏界面'.暂停函数()
	elif $'窗口/游戏退出'.visible==true:
		退出窗口关闭()
	elif $'窗口/界面安全区偏移'.visible==true:
		$'设置'.安全区设置关闭()
	elif $设置.visible == true:
		$'设置'.设置返回()
	elif $结算画面.visible==true:
		$'游戏界面'.返回()
	elif $主菜单.visible==true:
		退出按钮()
	elif $'游戏菜单'.visible==true:
		$'游戏菜单'.菜单按钮按下()
	pass
func 退出按钮():
	$'界面动画'.play("退出游戏")
	pass
#func _input(event):
#	if event is InputEventScreenTouch:
#		if event.pressed == true:
#			$'粒子效果/粒子效果动画'.play("按下")
#			$'粒子效果'.position=event.get_position()
#		else:
#			$'粒子效果/粒子效果动画'.play("松开")
#			$'粒子效果'.position=event.get_position()
#		print(event.get_position())
#	pass
#游戏菜单界面
func 进入菜单():
	$'界面动画'.play("进入选歌列表")
	#print(get_node("/root").get_tree_string())
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
	if $游戏菜单/歌曲信息/歌曲信息/容器/使用倾斜轨道/选项勾选盒.button_pressed == true:
		get_node("/root/根场景/视角节点/三维动画节点").play("开始")
	else:
		get_node("/root/根场景/视角节点/三维动画节点").play("返回")
	pass # Replace with function body.

func 无轨道模式():
	if $游戏菜单/歌曲信息/歌曲信息/容器/无轨道模式/选项勾选盒.button_pressed == true:
		$/root/根场景/主场景/轨道.show()
		$/root/根场景/主场景/无轨.hide()
		$'游戏界面/历史成绩/标签/玩法'.text="有轨下落式"
		$'游戏界面/历史成绩/标签/键数'.show()
	else:
		$/root/根场景/主场景/轨道.hide()
		$/root/根场景/主场景/无轨.show()
		$'游戏界面/历史成绩/标签/玩法'.text="无轨"
		$'游戏界面/历史成绩/标签/键数'.hide()
	pass # Replace with function body.


func 内置歌曲列表():
	#在竖屏状态下如果处在详细页面中就执行返回操作
	if $游戏菜单.界面宽度检测==true&&$游戏菜单.竖屏界面布局检测==true:
		返回事件()
	if $游戏菜单/界面左列表/容器.visible==false:
		#清空搜索框的文字
		$/root/根场景/根界面/游戏菜单/界面左列表/自定义/搜索栏/输入框.text=""
		#恢复搜索状态
		#遍历恢复歌曲列表节点里的所有歌曲分类
		for 循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表'.get_child_count():
			#遍历歌曲列表
			for 子节点循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表'.get_child(循环).get_child(0).get_child_count():
				var 子节点 = $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表'.get_child(循环).get_child(0).get_child(子节点循环)
				子节点.visible=true
		#恢复被搜索的封面搜索项
		#遍历自定义谱面的分类项
		for 菜单循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/歌曲组表格/容器'.get_child_count():
			#遍历分类项内的封面
			for 菜单封面循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child_count():
				var 子节点 =$'/root/根场景/根界面/游戏菜单/界面左列表/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child(菜单封面循环)
				var 文字搜索 = 子节点.get_node("标签").text
				子节点.visible=true
		$"游戏菜单/界面左列表/界面动画列表".play("内置")
	pass # Replace with function body.


func 自定义歌曲列表():
	#在竖屏状态下如果处在详细页面中就执行返回操作
	if $游戏菜单.界面宽度检测==true&&$游戏菜单.竖屏界面布局检测==true:
		返回事件()
	if $游戏菜单/界面左列表/自定义.visible==false:
		#恢复搜索状态
		$'游戏菜单/界面左列表/容器/搜索栏/输入框'.text=""
		for 菜单循环 in $'游戏菜单/界面左列表/容器'.get_child_count()-1:
			var 菜单组建路径=$'游戏菜单/界面左列表/容器'.get_child(菜单循环+1).get_path()
			if $'游戏菜单/界面左列表/容器'.get_child(菜单循环+1).visible==true:
				for 子节点循环 in get_node(菜单组建路径).get_child(0).get_child_count():
					var 子节点 = get_node(菜单组建路径).get_child(0).get_child(子节点循环)
					子节点.visible=true
		$"游戏菜单/界面左列表/界面动画列表".play('自定义')
	pass # Replace with function body.

#物件下落玩法的选项
func 物件下落方向(选项):
	match 选项:
		0:
			$'/root/根场景/视角节点'.rotation_degrees=Vector3($'/root/根场景/视角节点'.rotation_degrees[0],$'/root/根场景/视角节点'.rotation_degrees[1],0)
		1:
			$'/root/根场景/视角节点'.rotation_degrees=Vector3($'/root/根场景/视角节点'.rotation_degrees[0],$'/root/根场景/视角节点'.rotation_degrees[1],180)
		2:
			$'/root/根场景/视角节点'.rotation_degrees=Vector3($'/root/根场景/视角节点'.rotation_degrees[0],$'/root/根场景/视角节点'.rotation_degrees[1],90)
		3:
			$'/root/根场景/视角节点'.rotation_degrees=Vector3($'/root/根场景/视角节点'.rotation_degrees[0],$'/root/根场景/视角节点'.rotation_degrees[1],270)
	pass # Replace with function body.
