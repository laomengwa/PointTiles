extends Control
@onready var 歌曲卡片场景 = preload('res://scene/song.tscn')

func _ready():
	#传统谱面列表读取
	if $'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.get_child_count() == 0:
		#检测歌曲列表文件是否存在
		if FileAccess.file_exists("res://music/json_chart/csv_config/music_json.cfg")==true:
			for 循环 in GlobalScript.传统文件列表[1].size()-1:
				var 传统谱面编号 = GlobalScript.传统文件列表[1][循环+1].Mid
				for 对象循环 in GlobalScript.传统文件列表[0].size()-1:
					if GlobalScript.传统文件列表[1][循环+1].Mid == GlobalScript.传统文件列表[0][对象循环].Mid:
						var 传统歌曲卡片=歌曲卡片场景.instantiate()
						传统歌曲卡片.get_node("容器/容器/歌曲名").text = GlobalScript.传统文件列表[0][对象循环].MusicJson
						传统歌曲卡片.get_node("容器/容器/艺术家").text = GlobalScript.传统文件列表[0][对象循环].Musician
						传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str(循环+1)
						var 准备按钮 = Button.new()
						准备按钮.text = "准备"
						准备按钮.custom_minimum_size=Vector2(100,0)
						var 封面歌曲名=GlobalScript.传统文件列表[0][对象循环].MusicJson
						var 封面艺术家=GlobalScript.传统文件列表[0][对象循环].Musician
						var 临时谱面歌曲速度=GlobalScript.传统文件列表[0]
						var 谱面歌曲速度循环=对象循环
						准备按钮.pressed.connect(歌曲卡片按钮按下.bind(封面歌曲名,封面艺术家,临时谱面歌曲速度,谱面歌曲速度循环))
						传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
						$'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.add_child(传统歌曲卡片)
						break
					pass
				pass
			pass
		else:
			var 歌曲无文件提示=Label.new()
			歌曲无文件提示.text="糟糕，找不到歌曲……"
			歌曲无文件提示.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
			歌曲无文件提示.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
			歌曲无文件提示.anchors_preset=15
			$'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.add_child(歌曲无文件提示)
			print("无文件")
		pass
		print(DirAccess.get_files_at("res://music/midi_chart"))
		for 文件循环 in DirAccess.get_files_at("res://music/midi_chart").size():
			#var MIDI文件=FileAccess.open("res://music/midi_chart/"+DirAccess.get_files_at("res://music/midi_chart")[文件循环],FileAccess.READ_WRITE)
			var 传统歌曲卡片=歌曲卡片场景.instantiate()
			传统歌曲卡片.get_node("容器/容器/歌曲名").text = DirAccess.get_files_at("res://music/midi_chart")[文件循环]
			传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str(文件循环+1)
			var 准备按钮 = Button.new()
			准备按钮.text = "准备"
			准备按钮.custom_minimum_size=Vector2(100,0)
			var 封面歌曲名=DirAccess.get_files_at("res://music/midi_chart")[文件循环]
			传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
			准备按钮.pressed.connect(数码曲谱卡片按下.bind("res://music/midi_chart/"+DirAccess.get_files_at("res://music/midi_chart")[文件循环]))
			$'../游戏菜单/界面左列表/容器/数码曲谱列表/列表'.add_child(传统歌曲卡片)
	pass
func 数码曲谱卡片按下(文件路径):
	$'/root/根场景/视角节点/MidiPlayer'.stop()
	$'/root/根场景/视角节点/MidiPlayer'.file=文件路径
	$'/root/根场景/视角节点/MidiPlayer'.play()
	pass
var 界面宽度检测 = false
var 竖屏界面布局检测 = false
var 对象谱面文件读取 = ""
var 谱面每分钟节拍 = []
var 谱面基础节拍 = []
func 歌曲卡片按钮按下(封面歌曲名,封面艺术家,临时谱面歌曲速度,谱面歌曲速度循环):
	if $'歌曲信息/歌曲信息/容器/Panel/Label/HBoxContainer/VBoxContainer/歌曲名称'.text=="歌曲选项测试"||$'歌曲信息/歌曲信息/容器/Panel/Label/HBoxContainer/VBoxContainer/HBoxContainer/艺术家名称'.text=="艺术家测试":
		$'歌曲信息/界面动画'.stop()
		$'歌曲信息/界面动画'.play("文字提示关闭")
	谱面每分钟节拍 = []
	谱面基础节拍 = []
	$'../加载画面/Panel2/Label/VBoxContainer/HBoxContainer2/歌曲名称'.text = 封面歌曲名
	$'../加载画面/Panel2/Label/VBoxContainer/HBoxContainer/艺术家名称'.text = 封面艺术家
	$'../结算画面/左列表/结算/界面容器/界面容器/Panel/Label/HBoxContainer/VBoxContainer/歌曲名称'.text = 封面歌曲名
	$'../结算画面/左列表/结算/界面容器/界面容器/Panel/Label/HBoxContainer/VBoxContainer/HBoxContainer/艺术家名称'.text = 封面艺术家
	$'../游戏菜单/歌曲信息/歌曲信息/容器/Panel/Label/HBoxContainer/VBoxContainer/歌曲名称'.text = 封面歌曲名
	$'../游戏菜单/歌曲信息/歌曲信息/容器/Panel/Label/HBoxContainer/VBoxContainer/HBoxContainer/艺术家名称'.text = 封面艺术家
#	var 对象谱面文件路径 = 'user://json_chart/'+封面歌曲名+'.json'
	var 对象谱面文件路径 = 'res://music/json_chart/'+封面歌曲名+'.json'
	#检测json文件是否存在
	if FileAccess.file_exists(对象谱面文件路径)==false:
		#json文件不存在
		$'歌曲信息/界面动画'.stop()
		$'歌曲信息/界面动画'.play("文本提示打开")
		$'歌曲信息/文本/文本提示'.text="糟糕，找不到谱面文件！\n请检查该文件是否存在？\n文件路径:"+对象谱面文件路径
	else:
		#json文件存在
		if $'歌曲信息/文本'.visible==true:
			$'歌曲信息/界面动画'.play("文字提示关闭")
		var 对象谱面文件 = JSON.parse_string(FileAccess.open(对象谱面文件路径,FileAccess.READ).get_as_text())
		if 对象谱面文件==null:
			#如果解析失败
			$'歌曲信息/界面动画'.stop()
			$'歌曲信息/界面动画'.play("文本提示打开")
			$'歌曲信息/文本/文本提示'.text="糟糕，谱面文件解析错误！\n请检查该文件格式是否正确？\n文件路径:"+对象谱面文件路径
		else:
			对象谱面文件读取 = 对象谱面文件
			$'../游戏菜单/歌曲信息/歌曲信息/容器/Text/VBoxContainer/VBoxContainer/HBoxContainer3/Label2'.text = ""
			$'../游戏菜单/歌曲信息/歌曲信息/容器/Text/VBoxContainer/VBoxContainer/HBoxContainer2/Label2'.text = ""
			$'../游戏菜单/歌曲信息/歌曲信息/容器/Text/VBoxContainer/VBoxContainer/HBoxContainer/Label2'.text = ""
			for 对象谱面阶段循环 in 对象谱面文件.musics.size():
				$'../游戏菜单/歌曲信息/歌曲信息/容器/Text/VBoxContainer/VBoxContainer/HBoxContainer3/Label2'.text = $'../游戏菜单/歌曲信息/歌曲信息/容器/Text/VBoxContainer/VBoxContainer/HBoxContainer3/Label2'.text + var_to_str(对象谱面文件.musics[对象谱面阶段循环].baseBeats)+" "
				$'../游戏菜单/歌曲信息/歌曲信息/容器/Text/VBoxContainer/VBoxContainer/HBoxContainer/Label2'.text = $'../游戏菜单/歌曲信息/歌曲信息/容器/Text/VBoxContainer/VBoxContainer/HBoxContainer/Label2'.text + ("%.3f" %(float(临时谱面歌曲速度[谱面歌曲速度循环+对象谱面阶段循环].BPM)/((对象谱面文件.musics[对象谱面阶段循环].baseBeats)*60)))+" "
				谱面每分钟节拍.push_back(float(临时谱面歌曲速度[谱面歌曲速度循环+对象谱面阶段循环].BPM))
				谱面基础节拍.push_back(对象谱面文件.musics[对象谱面阶段循环].baseBeats)
				#print(临时谱面歌曲速度[谱面歌曲速度循环+对象谱面阶段循环-1].BPM)
				$'../游戏菜单/歌曲信息/歌曲信息/容器/Text/VBoxContainer/VBoxContainer/HBoxContainer2/Label2'.text = $'../游戏菜单/歌曲信息/歌曲信息/容器/Text/VBoxContainer/VBoxContainer/HBoxContainer2/Label2'.text +临时谱面歌曲速度[谱面歌曲速度循环+对象谱面阶段循环].BPM+" "
				#print(对象谱面文件.musics[对象谱面阶段循环].scores[0])
	#自适应界面
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor && 界面宽度检测 == true:
		$'界面动画'.play("详细界面扩张")
		竖屏界面布局检测 = true
	pass
	GlobalScript.谱面每分钟节拍=谱面每分钟节拍
	GlobalScript.谱面基础节拍=谱面基础节拍

#开始游戏
func 开始按钮按钮():
	$'/root/根场景/根界面/游戏界面/游戏界面进度条'.value=0
	$'../加载画面/加载文字/进度条'.value=0
	$'../加载画面/加载背景动画'.play("加载谱面画面背景")
	$'../界面动画'.play("加载谱面画面")
	$'../加载画面/加载文字/进度条'.value=0
	GlobalScript.游戏界面分数 = 0
	$"/root/根场景/主场景".完美判定=0
	$"/root/根场景/主场景".良好判定=0
	$"/root/根场景/主场景".较差判定=0
	$"/root/根场景/主场景".很差判定=0
	$"/root/根场景/主场景".失误判定=0
	$"/root/根场景/主场景".漏击判定=0
	get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str(GlobalScript.游戏界面分数)
	$'/root/根场景/主场景/开始按键'.show()
	GlobalScript.游戏开始状态=true
	$'/root/根场景/主场景'.清除物件()
	$'../加载画面/加载文字/进度条'.value=5
	var 轨道连接 = {}
	var 轨道物件长度连接 = {}
	var 物件类型 = {}
	var 阶段时间位置=[]
	var 歌曲最大音轨数量 = 0
	#段落循环
	for 对象谱面阶段循环 in 对象谱面文件读取.musics.size():
		#轨道循环
		for 对象谱面音轨循环 in 对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
			#最大轨道数量检查
			if 歌曲最大音轨数量<对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
				歌曲最大音轨数量=对象谱面文件读取.musics[对象谱面阶段循环].scores.size()
	#段落循环
	for 对象谱面阶段循环 in 对象谱面文件读取.musics.size():
		#轨道循环
		for 对象谱面音轨循环 in 对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
			if 对象谱面音轨循环==0:
				if 对象谱面阶段循环==0:
					阶段时间位置.push_back(0)
				else:
					阶段时间位置.push_back(轨道连接[0][轨道连接[0].size()-1]+轨道物件长度连接[0][轨道物件长度连接[0].size()-1])
			#处理字符串并转为数组
			var 物件 = 对象谱面文件读取.musics[对象谱面阶段循环].scores[对象谱面音轨循环]
			物件=物件.replace(";",",")
			物件=物件.split(",")
			#如果数组结尾不是空子集，则就创建
			if 物件[物件.size()-1]!="":
				物件.push_back("")
			var 物件时长存储=[]
			var 轨道时长积累=[]
			var 段落音符类型=[]
			var 物件时间累积=0
			#轨道内物件循环
			for 物件时间循环 in 物件.size()-1:
				var 物件格式转换=物件[物件时间循环]
				var 物件格式时间计数 = 0
				#统计时间
				物件格式时间计数=物件格式转换.count('H')*256+物件格式转换.count('Q')*256+物件格式转换.count('I')*128+物件格式转换.count('R')*128+物件格式转换.count('J')*64+物件格式转换.count('S')*64+物件格式转换.count('K')*32+物件格式转换.count('T')*32+物件格式转换.count('L')*16+物件格式转换.count('U')*16+物件格式转换.count('M')*8+物件格式转换.count('V')*8+物件格式转换.count('N')*4+物件格式转换.count('W')*4+物件格式转换.count('O')*2+物件格式转换.count('X')*2+物件格式转换.count('P')+物件格式转换.count('Y')+物件格式转换.count('Z')*0
				物件时长存储.push_back(物件格式时间计数)
				物件时间累积 = 物件时间累积+物件格式时间计数
				轨道时长积累.push_back(物件时间累积-物件时长存储[物件时间循环])
				if 物件格式转换.count('1<') > 0:
					段落音符类型.push_back("黑块")
				elif 物件格式转换.count('2<') > 0:
					段落音符类型.push_back("黑块")
				elif 物件格式转换.count('3<') > 0:
					段落音符类型.push_back("狂戳")
				elif 物件格式转换.count('5<') > 0:
					段落音符类型.push_back("双黑")
				elif 物件格式转换.count('6<') > 0:
					段落音符类型.push_back("长块")
				elif 物件格式转换.count('7<') > 0:
					段落音符类型.push_back("单滑")
				elif 物件格式转换.count('8<') > 0:
					段落音符类型.push_back("叠滑")
				elif 物件格式转换.count('9<') > 0:
					段落音符类型.push_back("伴奏")
				elif 物件格式转换.count('10<') > 0:
					段落音符类型.push_back("爆裂")
				elif 物件格式转换.count('>') > 0:
					段落音符类型.push_back("结束")
				else:
					if 物件格式时间计数>32*谱面基础节拍[对象谱面阶段循环]:
						段落音符类型.push_back("长块")
					else:
						段落音符类型.push_back("黑块")
			if 对象谱面阶段循环==0:
				轨道连接[对象谱面音轨循环]=轨道时长积累
				物件类型[对象谱面音轨循环]=段落音符类型
				轨道物件长度连接[对象谱面音轨循环]=物件时长存储
				if 歌曲最大音轨数量!=对象谱面文件读取.musics[对象谱面阶段循环].scores.size()&&对象谱面音轨循环==0:
					for 轨道填充循环 in 歌曲最大音轨数量-对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
						轨道连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道连接[0]
						物件类型[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=物件类型[0]
						轨道物件长度连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道物件长度连接[0]
			#其他阶段
			else:
				for 轨道连接循环 in 轨道时长积累.size():
					轨道时长积累[轨道连接循环]=轨道连接[对象谱面音轨循环][轨道连接[对象谱面音轨循环].size()-1]+轨道物件长度连接[对象谱面音轨循环][轨道物件长度连接[对象谱面音轨循环].size()-1]+轨道时长积累[轨道连接循环]
				轨道连接[对象谱面音轨循环]=轨道连接[对象谱面音轨循环]+轨道时长积累
				物件类型[对象谱面音轨循环]=物件类型[对象谱面音轨循环]+段落音符类型
				轨道物件长度连接[对象谱面音轨循环]=轨道物件长度连接[对象谱面音轨循环]+物件时长存储
				if 歌曲最大音轨数量!=对象谱面文件读取.musics[对象谱面阶段循环].scores.size()&&对象谱面音轨循环==0:
					for 轨道填充循环 in 歌曲最大音轨数量-对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
						轨道连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+轨道连接[0]
						物件类型[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=物件类型[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+物件类型[0]
						轨道物件长度连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道物件长度连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+轨道物件长度连接[0]
		pass
		$'../加载画面/加载文字/进度条'.value=(20*(对象谱面阶段循环/对象谱面文件读取.musics.size()))+5
	pass
	GlobalScript.物件总时间=轨道连接
	GlobalScript.物件时长=轨道物件长度连接
	GlobalScript.物件类型=物件类型
	GlobalScript.阶段时间位置=阶段时间位置
	$'../界面动画'.stop()
	$'../界面动画'.play("加载谱面画面关闭")
	
	pass # Replace with function body.

func _process(delta):
	#UI自适应
	#竖屏
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor:
		if 界面宽度检测 == false:
			$'界面动画'.play("界面缩放")
			界面宽度检测 = true
	#全横屏
	else:
		竖屏界面布局检测 = false
		$'歌曲信息'.offset_left=0
		if 界面宽度检测 == true:
			$'界面动画'.play("界面扩张")
			界面宽度检测 = false
		pass
	pass
#返回键
func 菜单按钮按下():
	if 竖屏界面布局检测 == true:
		$'界面动画'.play("详细界面缩放")
		竖屏界面布局检测 = false
	else:
		$'../界面动画'.play('返回')
		get_node("/root/根场景/视角节点/三维动画节点").play("Back")
	pass # Replace with function body.
#歌曲搜索（测试用）
func _on_line_edit_text_changed(new_text):
	for 子节点循环 in $'界面左列表/容器/旧式谱面列表/列表'.get_child_count():
		var 子节点 = $'界面左列表/容器/旧式谱面列表/列表'.get_child(子节点循环)
		if $'界面左列表/容器/搜索栏/输入框'.text == "":
			子节点.visible=true
		else:
			var 文字歌曲搜索 = 子节点.get_node("容器/容器/歌曲名").text
			var 文字艺术家搜索 = 子节点.get_node("容器/容器/艺术家").text
			#var 文字编号搜索 = 子节点.get_node("HBoxContainer/卡片头/编号").text
			if 文字歌曲搜索.find($'界面左列表/容器/搜索栏/输入框'.text) > 0 || 文字艺术家搜索.find($'界面左列表/容器/搜索栏/输入框'.text) > 0:
				子节点.visible=true
			else:
				子节点.visible=false
	pass # Replace with function body.

func _on_结算界面_button_down():
	$'../界面动画'.play("结算画面")
	$'../结算画面/左列表/结算/操作区/重试'.hide()
	$'../结算画面/左列表/结算/操作区/回放'.size_flags_horizontal=3
	pass # Replace with function body.


func 顶部选项卡1(tab):
	for 子节点循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/容器'.get_child_count()-1:
		$'/root/根场景/根界面/游戏菜单/界面左列表/容器'.get_child(子节点循环+1).hide()
	$'/root/根场景/根界面/游戏菜单/界面左列表/容器'.get_child(tab+1).show()
	pass # Replace with function body.


func 隐藏分隔线():
	for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
		if $歌曲信息/歌曲信息/容器/隐藏分隔线/选项勾选盒.button_pressed == false:
			get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(子节点循环+1)+"/分隔线").hide()
		else:
			get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(子节点循环+1)+"/分隔线").show()
	pass # Replace with function body.


func 轨道数量滑块(value):
	if value==1.0:
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.disabled=true
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.button_pressed=true
	else:
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.disabled=false
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.button_pressed=false
	for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
		get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(子节点循环+1)).hide()
	for 子节点循环 in value:
		get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(int(子节点循环+1))).show()
	$歌曲信息/歌曲信息/容器/轨道数量/数值.text=var_to_str(int(value))
	match int(value):
		1:
			get_node("/root/根场景/视角节点").position=Vector3(-3,0,0)
		2:
			get_node("/root/根场景/视角节点").position=Vector3(-2,0,0)
		3:
			get_node("/root/根场景/视角节点").position=Vector3(-1,0,0)
		4:
			get_node("/root/根场景/视角节点").position=Vector3(0,0,0)
		5:
			get_node("/root/根场景/视角节点").position=Vector3(1,0,0)
		6:
			get_node("/root/根场景/视角节点").position=Vector3(2,0,0)
		7:
			get_node("/root/根场景/视角节点").position=Vector3(3,0,0)
		8:
			get_node("/root/根场景/视角节点").position=Vector3(4,0,0)
		9:
			get_node("/root/根场景/视角节点").position=Vector3(5,0,0)
		10:
			get_node("/root/根场景/视角节点").position=Vector3(6,0,0)
	pass # Replace with function body.
