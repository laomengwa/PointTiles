extends GridContainer
@onready var 网格封面 = preload("res://scene/自定义歌曲卡片.tscn")
@onready var 歌曲卡片场景 = preload('res://scene/歌曲卡片.tscn')

#var 歌曲加载状态:bool=false
#var 自定义歌曲数量:int=0
#var 自定义文件路径:String
#var 自定义歌曲名称:String
func _ready():
	for 文件循环 in DirAccess.get_directories_at("res://music/custom").size():
		var 网格封面卡片=网格封面.instantiate()
		网格封面卡片.get_node("标签").text=DirAccess.get_directories_at("res://music/custom")[文件循环]
		var 文件路径="res://music/custom/"+DirAccess.get_directories_at("res://music/custom")[文件循环]
		if FileAccess.file_exists(文件路径+"/icon.png")==true:
			var 封面图片=load(文件路径+"/icon.png")
			网格封面卡片.get_node("封面边框/封面").texture_normal=封面图片
		网格封面卡片.get_node("封面边框/封面").tooltip_text=DirAccess.get_directories_at("res://music/custom")[文件循环]
		var 滚动栏=ScrollContainer.new()
		var 滚动栏列表=VBoxContainer.new()
		滚动栏列表.name="容器"
		滚动栏.name=DirAccess.get_directories_at("res://music/custom")[文件循环]
		滚动栏.add_theme_stylebox_override("panel",preload("res://scene/主题/滚动栏背景.tres"))
		滚动栏.set_anchors_preset(PRESET_FULL_RECT)
		滚动栏列表.size_flags_horizontal=3
		滚动栏列表.size_flags_vertical=3
		滚动栏.add_child(滚动栏列表)
		$/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表.add_child(滚动栏)
		网格封面卡片.get_node("封面边框/封面").focus_entered.connect(网格卡片聚焦.bind(网格封面卡片))
		网格封面卡片.get_node("封面边框/封面").focus_exited.connect(网格卡片聚焦离开.bind(网格封面卡片))
		网格封面卡片.get_node("封面边框/封面").pressed.connect(网格卡片按下.bind(文件路径,DirAccess.get_directories_at("res://music/custom")[文件循环]))
		self.add_child(网格封面卡片)
	pass
func _process(delta):
	if $/root/根场景/根界面/游戏菜单/界面左列表.size[0]>=130:
		self.columns=int($/root/根场景/根界面/游戏菜单/界面左列表.size[0]/130)
	else:
		self.columns=1
	#if 歌曲加载状态==true:
		##for 文件循环 in DirAccess.get_files_at(文件路径).size():
		##检查里面的文件是否是正确的格式并把文件加入到卡片中
		#if 自定义歌曲数量<DirAccess.get_files_at(自定义文件路径).size():
			#var 对象谱面文件=JSON.parse_string(FileAccess.open(自定义文件路径+"/"+DirAccess.get_files_at(自定义文件路径)[自定义歌曲数量],FileAccess.READ).get_as_text())
			#if 对象谱面文件!=null&&对象谱面文件.has("musics")==true:
				#$/root/根场景/根界面/窗口/加载窗口/容器/容器/文件名.text=DirAccess.get_files_at(自定义文件路径)[自定义歌曲数量]
				#$/root/根场景/根界面/窗口/加载窗口/容器/容器/左标签.text=var_to_str(自定义歌曲数量+1)
				#$/root/根场景/根界面/窗口/加载窗口/容器/进度条.value=float(自定义歌曲数量+1)
				#var 传统歌曲卡片=歌曲卡片场景.instantiate()
				#传统歌曲卡片.get_node("容器/容器/歌曲名").text = DirAccess.get_files_at(自定义文件路径)[自定义歌曲数量]
				#传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str(自定义歌曲数量+1)
				#var 准备按钮 = Button.new()
				#准备按钮.text = "准备"
				#准备按钮.custom_minimum_size=Vector2(100,0)
				#var 封面歌曲名=DirAccess.get_files_at(自定义文件路径)[自定义歌曲数量]
				#准备按钮.pressed.connect(歌曲卡片按钮按下.bind(DirAccess.get_files_at(自定义文件路径)[自定义歌曲数量],"",自定义文件路径+"/"+DirAccess.get_files_at(自定义文件路径)[自定义歌曲数量]))
				#传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
				#get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表/"+自定义歌曲名称+"/容器").add_child(传统歌曲卡片)
			#自定义歌曲数量=自定义歌曲数量+1
		#else:
			#歌曲加载状态=false
			#自定义歌曲数量=0
			#$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.stop()
			#$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.play("下拉框动画")
	pass
func 网格卡片聚焦(节点):
	节点.get_node("封面边框").add_theme_stylebox_override("panel",preload("res://scene/主题/网格卡片聚焦样式.tres"))
	节点.get_node("标签").add_theme_color_override("font_color", Color(1,0.6,0.6))
	节点.get_node("标签").add_theme_color_override("font_shadow_color", Color(0,0,0))
	pass
func 网格卡片聚焦离开(节点):
	节点.get_node("封面边框").add_theme_stylebox_override("panel",preload("res://scene/主题/网格卡片未聚焦样式.tres"))
	节点.get_node("标签").add_theme_color_override("font_color", Color(1,1.0,1.0))
	节点.get_node("标签").remove_theme_color_override("font_shadow_color")
	pass
func 网格卡片按下(文件路径,名称):
	#清空搜索框的文字
	$/root/根场景/根界面/游戏菜单/界面左列表/自定义/搜索栏/输入框.text=""
	#恢复被搜索的封面搜索项
	if $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框'.visible==false:
		#遍历自定义谱面的分类项
		for 菜单循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/歌曲组表格/容器'.get_child_count():
			#遍历分类项内的封面
			for 菜单封面循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child_count():
				var 子节点 =$'/root/根场景/根界面/游戏菜单/界面左列表/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child(菜单封面循环)
				var 文字搜索 = 子节点.get_node("标签").text
				子节点.visible=true
	if get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表/"+名称+"/容器").get_child_count()==0:
		$/root/根场景/根界面/窗口/加载窗口/容器/进度条.value=0
		$/root/根场景/根界面/窗口/加载窗口/容器/容器/文件名.text=""
		$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.play("加载窗口")
		$/root/根场景/根界面/窗口/加载窗口/容器/容器/左标签.text="0"
		$/root/根场景/根界面/窗口/加载窗口/容器/容器/右标签.text=var_to_str(DirAccess.get_files_at(文件路径).size())
		$/root/根场景/根界面/窗口/加载窗口/容器/进度条.max_value=float(DirAccess.get_files_at(文件路径).size())
		#自定义歌曲数量=0
		#自定义文件路径=文件路径
		#自定义歌曲名称=名称
		#歌曲加载状态=true
		#因为引擎的循环执行缺陷导致在某些设备上造成性能卡顿，等待优化
		for 文件循环 in DirAccess.get_files_at(文件路径).size():
			#检查里面的文件是否是正确的格式并把文件加入到卡片中
			var 对象谱面文件=JSON.parse_string(FileAccess.open(文件路径+"/"+DirAccess.get_files_at(文件路径)[文件循环],FileAccess.READ).get_as_text())
			if 对象谱面文件!=null&&对象谱面文件.has("musics")==true:
				$/root/根场景/根界面/窗口/加载窗口/容器/容器/文件名.text=DirAccess.get_files_at(文件路径)[文件循环]
				$/root/根场景/根界面/窗口/加载窗口/容器/容器/左标签.text=var_to_str(文件循环+1)
				$/root/根场景/根界面/窗口/加载窗口/容器/进度条.value=float(文件循环+1)
				var 传统歌曲卡片=歌曲卡片场景.instantiate()
				传统歌曲卡片.get_node("容器/容器/歌曲名").text = DirAccess.get_files_at(文件路径)[文件循环]
				传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str(文件循环+1)
				var 准备按钮 = Button.new()
				准备按钮.text = "准备"
				准备按钮.custom_minimum_size=Vector2(100,0)
				var 封面歌曲名=DirAccess.get_files_at(文件路径)[文件循环]
				准备按钮.pressed.connect(歌曲卡片按钮按下.bind(DirAccess.get_files_at(文件路径)[文件循环],"",文件路径+"/"+DirAccess.get_files_at(文件路径)[文件循环]))
				传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
				get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表/"+名称+"/容器").add_child(传统歌曲卡片)
				await get_tree().create_timer(0.0).timeout
	for 自定义歌曲列表循环 in get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表").get_child_count():
		get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表").get_child(自定义歌曲列表循环).hide()
	#if 歌曲加载状态==false:
	$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.stop()
	$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.play("下拉框动画")
	$/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/标题.text=名称
	get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表").show()
	get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表/"+名称).show()
	pass
func 下拉框收回():
	#清空搜索框的文字
	$/root/根场景/根界面/游戏菜单/界面左列表/自定义/搜索栏/输入框.text=""
	#恢复搜索状态
	#遍历恢复歌曲列表节点里的所有歌曲分类
	for 循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表'.get_child_count():
		#遍历歌曲列表
		for 子节点循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表'.get_child(循环).get_child(0).get_child_count():
			var 子节点 = $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表'.get_child(循环).get_child(0).get_child(子节点循环)
			子节点.visible=true
	$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.play("下拉框动画收回")
	pass # Replace with function body.

func 歌曲卡片按钮按下(封面歌曲名,封面艺术家,对象文件路径):
	$'/root/根场景/主场景'.歌曲类型格式=1
	if $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text=="歌曲选项测试"||$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text=="艺术家测试":
		$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.stop()
		$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.play("文字提示关闭")
	$/root/根场景/根界面/游戏菜单.谱面每分钟节拍 = []
	$/root/根场景/根界面/游戏菜单.谱面基础节拍 = []
	$'/root/根场景/根界面/加载画面/封面/边框/容器/上容器/歌曲名称'.text = 封面歌曲名
	$'/root/根场景/根界面/加载画面/封面/边框/容器/下容器/艺术家名称'.text = 封面艺术家
	$'/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/歌曲名称'.text = 封面歌曲名
	$'/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/容器/艺术家名称'.text = 封面艺术家
	$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text = 封面歌曲名
	$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text = 封面艺术家
	$'/root/根场景/根界面/游戏界面/歌曲信息/容器/歌曲名'.text=封面歌曲名
	$'/root/根场景/根界面/游戏界面/歌曲信息/容器/艺术家'.text=封面艺术家
	$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/谱面类型/文字'.text = "下落式旧格式谱面"
	#检测json文件是否存在
	if FileAccess.file_exists(对象文件路径)==false:
		#json文件不存在
		$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.stop()
		$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.play("文本提示打开")
		$'/root/根场景/根界面/游戏菜单/歌曲信息/文本/文本提示'.text="糟糕，找不到谱面文件！\n请检查该文件是否存在？\n文件路径:"+对象文件路径
	else:
		#json文件存在
		if $'/root/根场景/根界面/游戏菜单/歌曲信息/文本'.visible==true:
			$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.play("文字提示关闭")
		var 文件大小=FileAccess.open(对象文件路径,FileAccess.READ).get_length()
		var 对象谱面文件 = JSON.parse_string(FileAccess.open(对象文件路径,FileAccess.READ).get_as_text())
		if 对象谱面文件==null:
			#如果解析失败
			$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.stop()
			$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.play("文本提示打开")
			$'/root/根场景/根界面/游戏菜单/歌曲信息/文本/文本提示'.text="糟糕，谱面文件解析错误！\n请检查该文件格式是否正确？\n文件路径:"+对象文件路径
		elif 对象谱面文件.has("musics")==false:
			#不是游戏的对象文件格式的
			$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.stop()
			$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.play("文本提示打开")
			$'/root/根场景/根界面/游戏菜单/歌曲信息/文本/文本提示'.text="糟糕，谱面文件解析错误！\n请检查该文件格式是否正确？\n文件路径:"+对象文件路径
		else:
			#解析成功
			#解析歌曲是否存在对应的音频文件
			var MP3音频文件路径 = 'res://music/json_chart/'+封面歌曲名+'.mp3'
			var WAV音频文件路径 = 'res://music/json_chart/'+封面歌曲名+'.wav'
			var OGG音频文件路径 = 'res://music/json_chart/'+封面歌曲名+'.ogg'
			if FileAccess.file_exists(MP3音频文件路径)==true:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=load(MP3音频文件路径)
			elif FileAccess.file_exists(WAV音频文件路径)==true:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=load(WAV音频文件路径)
			elif FileAccess.file_exists(OGG音频文件路径)==true:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=load(OGG音频文件路径)
			else:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=AudioStreamGenerator.new()
			$/root/根场景/根界面/游戏菜单.对象谱面文件读取 = 对象谱面文件
			if 文件大小/1024 > pow(1024,2):
				$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = ("%.2f" %(float(文件大小)/pow(1024,3)))+"GiB"
			elif 文件大小/1024 > pow(1024,1):
				$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = ("%.2f" %(float(文件大小)/pow(1024,2)))+"MiB"
			elif 文件大小/1024 > pow(1024,0):
				$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = ("%.2f" %(float(文件大小)/1024.0))+"KiB"
			else:
				$'/root/根场景/根界面/游戏菜单歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = var_to_str(文件大小)+"B"
			$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = ""
			$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = ""
			$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text = ""
			for 对象谱面阶段循环 in 对象谱面文件.musics.size():
				$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text = $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text + var_to_str(对象谱面文件.musics[对象谱面阶段循环].baseBeats)+" "
				#检查json文件是否存在“bpm”这个对象？
				if 对象谱面文件.musics[对象谱面阶段循环].has("bpm"):
					$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text + ("%.3f" %(float(对象谱面文件.musics[对象谱面阶段循环].bpm)/((对象谱面文件.musics[对象谱面阶段循环].baseBeats)*60)))+" "
					$/root/根场景/根界面/游戏菜单.谱面每分钟节拍.push_back(float(对象谱面文件.musics[对象谱面阶段循环].bpm))
					$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text +var_to_str(对象谱面文件.musics[对象谱面阶段循环].bpm)+" "
				#检查json文件是否存在"baseBpm"这个对象？
				elif 对象谱面文件.has("baseBpm"):
					$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text + ("%.3f" %(float(对象谱面文件.baseBpm)/((对象谱面文件.musics[对象谱面阶段循环].baseBeats)*60)))+" "
					$/root/根场景/根界面/游戏菜单.谱面每分钟节拍.push_back(float(对象谱面文件.baseBpm))
					$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text +var_to_str(对象谱面文件.baseBpm)+" "
				#如果都不存在，强制使用默认的数值
				else:
					$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text + ("%.3f" %(60/((对象谱面文件.musics[对象谱面阶段循环].baseBeats)*60)))+" "
					$/root/根场景/根界面/游戏菜单.谱面每分钟节拍.push_back(60)
					$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text +"60 "
				$/root/根场景/根界面/游戏菜单.谱面基础节拍.push_back(对象谱面文件.musics[对象谱面阶段循环].baseBeats)
				#print(临时谱面歌曲速度[谱面歌曲速度循环+对象谱面阶段循环-1].BPM)
				#print(对象谱面文件.musics[对象谱面阶段循环].scores[0])
	#自适应界面
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor && $/root/根场景/根界面/游戏菜单.界面宽度检测 == true:
		$'/root/根场景/根界面/游戏菜单/界面动画'.play("详细界面扩张")
		$/root/根场景/根界面/游戏菜单.竖屏界面布局检测 = true
	pass
	#对于挑战赛节拍速度为0时的处理
	for 循环 in $/root/根场景/根界面/游戏菜单.谱面每分钟节拍.size():
		if $/root/根场景/根界面/游戏菜单.谱面每分钟节拍[循环]==0:
			$/root/根场景/根界面/游戏菜单.谱面每分钟节拍[循环]=$/root/根场景/根界面/游戏菜单.谱面每分钟节拍[0]
	GlobalScript.谱面每分钟节拍=$/root/根场景/根界面/游戏菜单.谱面每分钟节拍
	GlobalScript.谱面基础节拍=$/root/根场景/根界面/游戏菜单.谱面基础节拍
