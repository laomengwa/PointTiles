extends Control
func _ready() -> void:
	#连接选项信号
	for 选项循环 in $"底色/选单栏".get_children():
		var 模态菜单=选项循环.get_popup()
		#添加键盘快捷键
		match 选项循环.get_index():
			0:
				#属性
				模态菜单.set_item_accelerator(4,KEY_MASK_CTRL|KEY_I)
				#保存
				模态菜单.set_item_accelerator(5,KEY_MASK_CTRL|KEY_S)
				#退出
				模态菜单.set_item_accelerator(6,KEY_MASK_CTRL|KEY_Q)
			1:
				pass
			2:
				pass
			3:
				pass
		模态菜单.id_pressed.connect(
			func(编号:int):
				match 选项循环.get_index():
					0:
						print(编号)
					1:
						print(编号)
					2:
						print(编号)
					3:
						调试按钮菜单(编号)
				pass
		)
		pass
func 调试按钮菜单(控件编号:int)->void:
	match 控件编号:
		1:
			#DisplayServer.clipboard_set('PT%02x')
			pass
	pass
