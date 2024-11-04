extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for 循环 in 2:
		for 键位设置界面循环 in 10:
			var 键位设置界面=PanelContainer.new()
			键位设置界面.add_theme_stylebox_override("panel",preload("res://scene/主题/键位设置界面样式.tres"))
			键位设置界面.set_name(var_to_str(键位设置界面循环+1)+"轨道模式")
			var 键位设置界面标签=Label.new()
			键位设置界面标签.set_name("标签")
			键位设置界面标签.text=var_to_str(键位设置界面循环+1)+"轨道模式"
			键位设置界面标签.mouse_filter=Control.MOUSE_FILTER_IGNORE
			键位设置界面标签.add_theme_stylebox_override("normal",load("res://scene/主题/键位设置界面样式标签.tres"))
			var 控件容器=VBoxContainer.new()
			控件容器.set_name("控件容器")
			控件容器.add_child(键位设置界面标签)
			for 键位循环 in 键位设置界面循环+1:
				var 控件键位容器=HBoxContainer.new()
				控件键位容器.set_name(var_to_str(键位循环+1)+"键位")
				var 标签=Label.new()
				标签.set_name("标签")
				标签.size_flags_horizontal=Control.SIZE_EXPAND_FILL
				标签.text=var_to_str(键位循环+1)+"键位"
				标签.mouse_filter=Control.MOUSE_FILTER_IGNORE
				var 撤销按钮=Button.new()
				撤销按钮.set_name("撤销按钮")
				撤销按钮.text="撤销"
				撤销按钮.custom_minimum_size[0]=80
				撤销按钮.add_theme_stylebox_override("normal",load("res://scene/主题/退出按钮样式.tres"))
				var 确定按钮=Button.new()
				确定按钮.set_name("确定按钮")
				确定按钮.text="确定"
				确定按钮.custom_minimum_size[0]=80
				var 按键监听=LineEdit.new()
				按键监听.set_name("按键监听")
				控件键位容器.add_child(标签)
				控件键位容器.add_child(撤销按钮)
				控件键位容器.add_child(确定按钮)
				控件键位容器.add_child(按键监听)
				控件容器.add_child(控件键位容器)
			var 重置按钮=Button.new()
			重置按钮.set_name("重置")
			重置按钮.text="重置默认布局"
			控件容器.add_child(重置按钮)
			键位设置界面.add_child(控件容器)
			键位设置界面.mouse_filter=Control.MOUSE_FILTER_IGNORE
			match 循环:
				0:
					$'控制/键盘鼠标/容器/按键布局'.add_child(键位设置界面)
				1:
					$'控制/手柄/容器/按键布局'.add_child(键位设置界面)
	InputMap.add_action(var_to_str(KEY_D)+"按键")
	InputMap.add_action(var_to_str(KEY_F)+"按键")
	InputMap.add_action(var_to_str(KEY_J)+"按键")
	InputMap.add_action(var_to_str(KEY_K)+"按键")
	var 测试1=InputEventKey.new()
	测试1.keycode=KEY_D
	var 测试2=InputEventKey.new()
	测试2.keycode=KEY_F
	var 测试3=InputEventKey.new()
	测试3.keycode=KEY_J
	var 测试4=InputEventKey.new()
	测试4.keycode=KEY_K
	InputMap.action_add_event(var_to_str(KEY_D)+"按键",测试1)
	InputMap.action_add_event(var_to_str(KEY_F)+"按键",测试2)
	InputMap.action_add_event(var_to_str(KEY_J)+"按键",测试3)
	InputMap.action_add_event(var_to_str(KEY_K)+"按键",测试4)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func 键位设置重置按钮():
	pass # Replace with function body.


func 键位更改(new_text):
	pass # Replace with function body.


func 按键设置选项展开():
	if $'控制/键盘鼠标/容器/按键布局'.visible==true:
		$'控制/键盘鼠标/容器/按键布局'.hide()
		$'控制/键盘鼠标/容器/按键布局设置展开/展开'.text="展开"
	else:
		$'控制/键盘鼠标/容器/按键布局'.show()
		$'控制/键盘鼠标/容器/按键布局设置展开/展开'.text="收回"
	pass # Replace with function body.
func 手柄按键选项展开():
	if $'控制/手柄/容器/按键布局'.visible==true:
		$'控制/手柄/容器/按键布局'.hide()
		$'控制/手柄/容器/按键布局设置展开/展开'.text="展开"
	else:
		$'控制/手柄/容器/按键布局'.show()
		$'控制/手柄/容器/按键布局设置展开/展开'.text="收回"
	pass # Replace with function body.

func 判定偏移(value):
	GlobalScript.判定偏移=value
	$'/root/根场景/根界面/设置/设置选项/控制/控制/其他/容器/判定偏移/数值'.text=var_to_str(int(value*1000))+"毫秒"
	pass # Replace with function body.
