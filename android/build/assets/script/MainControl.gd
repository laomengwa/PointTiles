extends Control
# Called when the node enters the scene tree for the first time.
func _ready():
	$主菜单/Label.text = $主菜单/Label.text + " "+ OS.get_name()+" "+Engine.get_architecture_name();
	if OS.get_name()=="Linux":
		$设置/设置选项/关于/关于/容器/游戏平台/标识.text=OS.get_distribution_name()+" "+OS.get_name()
	else:
		$设置/设置选项/关于/关于/容器/游戏平台/标识.text=OS.get_name()
	$设置/设置选项/关于/关于/容器/处理器信息/标识.text=OS.get_processor_name()+" "+Engine.get_architecture_name()
	print(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	#操作系统检测
	pass # Replace with function body.

func _notification(what):
	#当按下关闭窗口时
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().set_auto_accept_quit(false)
		if $'游戏界面'.visible == true:
			$'../视角节点/背景音乐播放节点'.set_stream_paused(true)
		ExitWindowFunc()
	#安卓端返回处理方法
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().set_auto_accept_quit(false)
		返回事件()
	#监听游戏过程中鼠标离开游戏画面
	if what == NOTIFICATION_WM_MOUSE_EXIT ||what == NOTIFICATION_APPLICATION_FOCUS_OUT ||what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		if $'游戏界面'.visible == true && $'结算画面'.visible == false && $'窗口/暂停窗口'.visible == false:
			$'游戏界面'.暂停函数()
	pass
func 返回事件():
	if $'游戏界面'.visible == true:
		$'游戏界面'.暂停函数()
	elif $'窗口/游戏退出'.visible==true:
		_on_continue_button_up()
	elif $'窗口/界面安全区偏移'.visible==true:
		$'设置'.安全区设置关闭()
	elif $设置.visible == true:
		$'设置'.设置返回()
	elif $结算画面.visible==true:
		$'游戏界面'._on_返回_button_down()
	elif $主菜单.visible==true:
		ExitWindowFunc()
	elif $'游戏菜单'.visible==true:
		$'游戏菜单'.菜单按钮按下()
	pass
func _process(delta):
	#if Input.joy_connection_changed():
	#	var 手柄控制鼠标指针向上=Input.get_action_strength("手柄右摇杆上")
	#	var 手柄控制鼠标指针向下=Input.get_action_strength("手柄右摇杆下")
	#	var 手柄控制鼠标指针向左=Input.get_action_strength("手柄右摇杆左")
	#	var 手柄控制鼠标指针向右=Input.get_action_strength("手柄右摇杆右")
	#	Input.warp_mouse(get_viewport().get_mouse_position()+Vector2(手柄控制鼠标指针向右-手柄控制鼠标指针向左,手柄控制鼠标指针向下-手柄控制鼠标指针向上)*5)
	#print(get_viewport().get_mouse_position()+Vector2(手柄控制鼠标指针向右-手柄控制鼠标指针向左,手柄控制鼠标指针向下-手柄控制鼠标指针向上)*5)
	pass
#键盘输入检测
func _input(event):
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				返回事件()
		pass
	pass
#弹出退出窗口
func ExitWindowFunc():
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
func _on_start_games_pressed():
	$'界面动画'.play("进入选歌列表")
	#print(get_node("/root").get_tree_string())
	get_node("/root/根场景/视角节点/三维动画节点").play("Start")
	pass # Replace with function body.


func _on_exit_button_button_up():
	ExitWindowFunc()
	pass # Replace with function body.


func _on_settings_button_button_down():
	$'设置/界面动画'.play('设置界面打开')
	pass # Replace with function body.

func _on_exit_button_up():#退出按钮
	get_tree().quit()#退出函数
	pass # Replace with function body.

func _on_continue_button_up():#对话框取消按钮
	if $'游戏界面'.visible == true:
		$'/root/根场景/根界面/窗口/游戏退出'.hide()
		$'/root/根场景/根界面/游戏界面/暂停窗口'.show()
	else:
		$'界面动画'.play("退出窗口关闭")
	pass # Replace with function body.


func _on_倾斜轨道_down():
	if $游戏菜单/歌曲信息/歌曲信息/容器/使用倾斜轨道/选项勾选盒.button_pressed == true:
		get_node("/root/根场景/视角节点/三维动画节点").play("Start")
	else:
		get_node("/root/根场景/视角节点/三维动画节点").play("Back")
	pass # Replace with function body.
