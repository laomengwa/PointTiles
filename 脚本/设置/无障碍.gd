extends ScrollContainer
var 语音字典:Array
var 被聚焦节点:Node
var 被悬浮节点:Node
var 语音编号:String=""
var 语音启用:bool=false
func _ready():
	语音字典 = DisplayServer.tts_get_voices()
	var 列表项 = $无障碍/文字转语音/容器/语音列表.create_item()
	$无障碍/文字转语音/容器/语音列表.set_hide_root(true)
	$无障碍/文字转语音/容器/语音列表.set_column_title(0, "语言")
	$无障碍/文字转语音/容器/语音列表.set_column_title(1, "语音")
	$无障碍/文字转语音/容器/语音列表.set_column_titles_visible(true)
	for 循环 in 语音字典:
		var 列表 = $无障碍/文字转语音/容器/语音列表.create_item(列表项)
		列表.set_text(0, 循环["name"])
		列表.set_metadata(0, 循环["id"])
		列表.set_text(1, 循环["language"])
	#set_process(true)
	pass

func _input(事件: InputEvent) -> void:
	#根据鼠标或者触摸手指返回控件
	#print(get_tree().root.gui_get_hovered_control())
	#print(get_tree().root.gui_get_focus_owner())
	if 语音启用==true:
		if get_viewport().gui_get_hovered_control():
			if 被悬浮节点!=get_viewport().gui_get_hovered_control()||DisplayServer.tts_is_speaking()==false:
				被悬浮节点=get_viewport().gui_get_hovered_control()
				if 被悬浮节点 is not BaseButton and 被悬浮节点 is not LineEdit and 被悬浮节点 is not Range and 被悬浮节点 is not TabBar:
					for 子节点 in 被悬浮节点.get_children():
						if 子节点 is Label or 子节点 is RichTextLabel:
							if 事件 is InputEventMouse or 事件 is InputEventScreenTouch:
								if 事件.get_position()[0]>子节点.get_global_position()[0] &&事件.get_position()[1]>子节点.get_global_position()[1] && 事件.get_position()[0]<子节点.get_global_position()[0]+子节点.get_size()[0] && 事件.get_position()[1]<子节点.get_global_position()[1]+子节点.get_size()[1]:
									if 语音编号!="":
										文字转语音输出(TranslationServer.translate(子节点.text))
									break
					pass
				elif 被悬浮节点 is Label or 被悬浮节点 is RichTextLabel:
					if 事件 is InputEventMouse or 事件 is InputEventScreenTouch:
						if 事件.get_position()[0]>被悬浮节点.get_global_position()[0] &&事件.get_position()[1]>被悬浮节点.get_global_position()[1] && 事件.get_position()[0]<被悬浮节点.get_global_position()[0]+被悬浮节点.get_size()[0] && 事件.get_position()[1]<被悬浮节点.get_global_position()[1]+被悬浮节点.get_size()[1]:
							if 语音编号!="":
								文字转语音输出(TranslationServer.translate(被悬浮节点.text))
				else:
					var 文字:String=""
					if "text" in get_viewport().gui_get_hovered_control():
						文字+=TranslationServer.translate(get_viewport().gui_get_hovered_control().text)
					if 被悬浮节点 is BaseButton:
						文字+=TranslationServer.translate("按钮")
					if "tooltip_text" in get_viewport().gui_get_hovered_control():
						文字+=TranslationServer.translate(get_viewport().gui_get_hovered_control().tooltip_text)
					if 语音编号!="":
						文字转语音输出(文字)
		if get_viewport().gui_get_focus_owner():
			if 被聚焦节点!=get_viewport().gui_get_focus_owner():
				被聚焦节点=get_viewport().gui_get_focus_owner()
				var 文字:String=""
				if "text" in get_viewport().gui_get_focus_owner():
					文字+=TranslationServer.translate(get_viewport().gui_get_focus_owner().text)
				if 被聚焦节点 is BaseButton:
					文字+=TranslationServer.translate("按钮")
				if "tooltip_text" in get_viewport().gui_get_focus_owner():
					文字+=TranslationServer.translate(get_viewport().gui_get_focus_owner().tooltip_text)
				if 语音编号!="":
					文字转语音输出(文字)
			pass
	pass
func 文字转语音输出(文字:String)->void:
	DisplayServer.tts_stop()
	DisplayServer.tts_speak(文字,语音编号,$"../音频/音频/音量/容器/语音/滑块".value,$无障碍/文字转语音/容器/语音音调/滑块.value,$无障碍/文字转语音/容器/语音速度/滑块.value)
	pass
func 文字转语音筛选(_文字变更: String) -> void:
	$无障碍/文字转语音/容器/语音列表.clear()
	var 列表项 = $无障碍/文字转语音/容器/语音列表.create_item()
	for 循环 in 语音字典:
		if ($"无障碍/文字转语音/容器/语音筛选/语音名称".text.is_empty() || $"无障碍/文字转语音/容器/语音筛选/语音名称".text.to_lower() in 循环["name"].to_lower()) && ($"无障碍/文字转语音/容器/语音筛选/语言种类".text.is_empty() || $"无障碍/文字转语音/容器/语音筛选/语言种类".text.to_lower() in 循环["language"].to_lower()):
			var 列表 = $无障碍/文字转语音/容器/语音列表.create_item(列表项)
			列表.set_text(0, 循环["name"])
			列表.set_metadata(0, 循环["id"])
			列表.set_text(1, 循环["language"])
	pass

func 语音列表按下() -> void:
	$无障碍/文字转语音/容器/语音选择结果/语音名称.text=$无障碍/文字转语音/容器/语音列表.get_selected().get_metadata(0)
	语音编号=$无障碍/文字转语音/容器/语音选择结果/语音名称.text
	pass

func 语音速度滑块拖拽(值: float) -> void:
	$无障碍/文字转语音/容器/语音速度/数值.text="%.1f" % [值]
	pass

func 语音音调滑块拖拽(值: float) -> void:
	$无障碍/文字转语音/容器/语音音调/数值.text="%.1f" % [值]
	pass

func 色彩矫正选项(选项: int) -> void:
	$/root/根场景/色彩滤镜.get_material().set_shader_parameter("type",选项)
	match 选项:
		1,2,3,4:
			$/root/根场景/色彩滤镜.show()
		_:
			$/root/根场景/色彩滤镜.hide()
	pass

func 文字转语音启用() -> void:
	if $"无障碍/文字转语音/容器/文字转语音/选项框".button_pressed==false:
		语音启用=true
	else:
		语音启用=false
	if 语音启用==true:
		文字转语音输出("屏幕阅读器启用")
	else:
		文字转语音输出("屏幕阅读器关闭")
	$"无障碍/文字转语音/容器/语音列表".visible=语音启用
	$"无障碍/文字转语音/容器/语音筛选".visible=语音启用
	$"无障碍/文字转语音/容器/语音选择结果".visible=语音启用
	$"无障碍/文字转语音/容器/语音速度".visible=语音启用
	$"无障碍/文字转语音/容器/语音音调".visible=语音启用
	pass # Replace with function body.
