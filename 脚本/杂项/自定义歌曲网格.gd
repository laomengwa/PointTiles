extends GridContainer
@onready var 网格封面 = preload("res://场景/自定义歌曲卡片.tscn")
@onready var 歌曲卡片场景 = preload('res://场景/歌曲卡片.tscn')
@onready var 加载进度条=preload('res://场景/加载标签.tscn')
@onready var 通知节点=preload("res://场景/通知卡片.tscn")
var 默认封面图标=preload("res://icon.svg")
var 歌曲加载状态:bool=false
var 歌曲待刷新状态:Dictionary={"状态":false,"页码":0}
func _ready():
	#因为引擎的执行缺陷导致在安卓设备上造成性能卡顿、执行效率低下等恶性问题
	#严禁使用 DirAccess.get_files_at 进行遍历操作！
	if OS.has_feature("template")==false:
		#调试模式
		for 文件循环 in DirAccess.get_directories_at("res://音乐/额外").size():
			#创建网格按钮
			var 网格封面卡片=网格封面.instantiate()
			网格封面卡片.get_node("标签").text=DirAccess.get_directories_at("res://音乐/额外")[文件循环]
			var 文件路径="res://音乐/额外/"+DirAccess.get_directories_at("res://音乐/额外")[文件循环]
			var 封面图片:Texture2D
			if FileAccess.file_exists(文件路径+"/icon.png")==true:
				封面图片=load(文件路径+"/icon.png")
				网格封面卡片.get_node("封面边框/封面").texture_normal=封面图片
			网格封面卡片.get_node("封面边框/封面").tooltip_text=DirAccess.get_directories_at("res://音乐/额外")[文件循环]
			网格封面卡片.get_node("封面边框/封面").focus_entered.connect(网格卡片聚焦.bind(网格封面卡片))
			网格封面卡片.get_node("封面边框/封面").focus_exited.connect(网格卡片聚焦离开.bind(网格封面卡片))
			网格封面卡片.get_node("封面边框/封面").pressed.connect(网格卡片按下.bind(文件路径,DirAccess.get_directories_at("res://音乐/额外")[文件循环],封面图片))
			self.add_child(网格封面卡片)
	else:
		#打包后的正式游戏
		#暂时没有iOS平台的文件路径
		var 目录:DirAccess
		var 自定义谱面文件:String
		if OS.get_name()!="Android":
			自定义谱面文件="user://PointTiles/Custom"
			目录=DirAccess.open("user://")
		else:
			自定义谱面文件="/storage/self/primary/Android/data/org.mengwa.pointtiles/PointTiles/Custom"
			目录=DirAccess.open("/storage/self/primary/Android/data/org.mengwa.pointtiles")
		#如果没有该文件夹，则就创建
		if 目录.dir_exists("PointTiles")==false:
			目录.make_dir("PointTiles")
		if 目录.dir_exists("PointTiles/Custom")==false:
			目录.make_dir("PointTiles/Custom")
		for 文件循环 in DirAccess.get_directories_at(自定义谱面文件).size():
			#创建网格按钮
			var 网格封面卡片=网格封面.instantiate()
			网格封面卡片.get_node("标签").text=DirAccess.get_directories_at(自定义谱面文件)[文件循环]
			var 文件路径=自定义谱面文件+DirAccess.get_directories_at(自定义谱面文件)[文件循环]
			var 封面图片:Texture2D
			if FileAccess.file_exists(文件路径+"/icon.png")==true:
				封面图片=load(文件路径+"/icon.png")
				网格封面卡片.get_node("封面边框/封面").texture_normal=封面图片
			网格封面卡片.get_node("封面边框/封面").tooltip_text=DirAccess.get_directories_at(自定义谱面文件)[文件循环]
			网格封面卡片.get_node("封面边框/封面").focus_entered.connect(网格卡片聚焦.bind(网格封面卡片))
			网格封面卡片.get_node("封面边框/封面").focus_exited.connect(网格卡片聚焦离开.bind(网格封面卡片))
			网格封面卡片.get_node("封面边框/封面").pressed.connect(网格卡片按下.bind(文件路径,DirAccess.get_directories_at(自定义谱面文件)[文件循环],封面图片))
			self.add_child(网格封面卡片)
	pass
func _process(帧处理):
	#画面自适应
	if $/root/根场景/根界面/游戏菜单/界面左列表.size[0]>=130:
		self.columns=int($/root/根场景/根界面/游戏菜单/界面左列表.size[0]/130)
	else:
		self.columns=1
	pass
func 网格卡片聚焦(节点):
	节点.get_node("封面边框").add_theme_stylebox_override("panel",preload("res://场景/主题/网格卡片聚焦样式.tres"))
	节点.get_node("标签").add_theme_color_override("font_color", Color(1,0.6,0.6))
	节点.get_node("标签").add_theme_color_override("font_shadow_color", Color(0,0,0))
	pass
func 网格卡片聚焦离开(节点):
	节点.get_node("封面边框").add_theme_stylebox_override("panel",preload("res://场景/主题/网格卡片未聚焦样式.tres"))
	节点.get_node("标签").add_theme_color_override("font_color", Color(1,1.0,1.0))
	节点.get_node("标签").remove_theme_color_override("font_shadow_color")
	pass
func 网格卡片按下(文件路径,名称,封面图片):
	#因为引擎的执行缺陷导致在安卓设备上造成性能卡顿、执行效率低下等恶性问题
	#严禁使用 DirAccess.get_files_at 进行遍历操作！
	#get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表/"+名称+"/容器/加载提示标签").max_value=传统文件列表[1].size()
	if FileAccess.file_exists(文件路径+"/list.cfg")==false:
		var 歌曲列表数据:Dictionary={
			"模组名称":名称,
			"模组简介":"",
			"谱面类型":1,
			"歌曲列表":[],
		}
		#测试，未来修改
		for 循环 in DirAccess.get_files_at(文件路径).size():
			var 文件名称=DirAccess.get_files_at(文件路径)[循环]
			var 文件后缀=文件名称.split(".")
			if 文件后缀[文件后缀.size()-1].to_lower()=="json":
				var 对象谱面文件=JSON.parse_string(FileAccess.open(文件路径+"/"+文件名称,FileAccess.READ).get_as_text())
				if 对象谱面文件.has("musics")==true:
					var 歌曲信息:Dictionary={
						"文件":文件名称,
						"卡片头":"",
						"艺术家":"",
						"谱师":"",
						"封面":"",
						"竞技场":false,
						"加速度":0
					}
					歌曲列表数据.歌曲列表.push_back(歌曲信息)
		var 文件=FileAccess.open(文件路径+"/list.cfg", FileAccess.WRITE)
		文件.store_line(JSON.stringify(歌曲列表数据))
		文件.close()
	#清空搜索框的文字
	$/root/根场景/根界面/游戏菜单/界面左列表/自定义/搜索栏/输入框.text=""
	if $'/root/根场景/根界面/游戏菜单/歌曲信息/文本'.visible==true||$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息'.visible==true:
		$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.stop()
		$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.play("歌曲合集详介")
	if 封面图片!=null:
		$'/root/根场景/根界面/游戏菜单/歌曲信息/自定义谱师信息/表格/封面信息/封面/封面'.texture=封面图片
	else:
		$'/root/根场景/根界面/游戏菜单/歌曲信息/自定义谱师信息/表格/封面信息/封面/封面'.texture=默认封面图标
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor && $/root/根场景/根界面/游戏菜单.界面宽度检测 == true:
		$'/root/根场景/根界面/游戏菜单/界面动画'.play("详细界面扩张")
		$/root/根场景/根界面/游戏菜单.竖屏界面布局检测 = true
	#恢复被搜索的封面搜索项
	if $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框'.visible==false:
		#遍历自定义谱面的分类项
		for 菜单循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/歌曲组表格/容器'.get_child_count():
			#遍历分类项内的封面
			for 菜单封面循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child_count():
				var 子节点 =$'/root/根场景/根界面/游戏菜单/界面左列表/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child(菜单封面循环)
				var 文字搜索 = 子节点.get_node("标签").text
				子节点.visible=true
	#创建面板
	if $/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表.has_node(名称)==false:
		var 滚动栏=ScrollContainer.new()
		var 滚动栏列表=VBoxContainer.new()
		滚动栏列表.name="容器"
		滚动栏.name=名称
		滚动栏.add_theme_stylebox_override("panel",preload("res://场景/主题/滚动栏背景.tres"))
		滚动栏.set_anchors_preset(PRESET_FULL_RECT)
		滚动栏列表.size_flags_horizontal=3
		滚动栏列表.size_flags_vertical=3
		滚动栏.add_child(滚动栏列表)
		$/root/根场景/根界面/窗口/加载窗口/容器/进度条.value=0
		$/root/根场景/根界面/窗口/加载窗口/容器/容器/文件名.text=""
		$/root/根场景/根界面/窗口/加载窗口/容器/容器/左标签.text="0"
		$/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表.add_child(滚动栏)
	var 列表文件:Dictionary=JSON.parse_string(FileAccess.open(文件路径+"/list.cfg",FileAccess.READ).get_as_text())
	if 列表文件.has("模组名称"):
		$/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/标题.text=列表文件.模组名称
		$'/root/根场景/根界面/游戏菜单/歌曲信息/自定义谱师信息/表格/封面信息/信息/表格/标题'.text=列表文件.模组名称
	else:
		$/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/标题.text=名称
		$'/root/根场景/根界面/游戏菜单/歌曲信息/自定义谱师信息/表格/封面信息/信息/表格/标题'.text=名称
	if 列表文件.has("模组简介"):
		if 列表文件.模组简介!="":
			$'/root/根场景/根界面/游戏菜单/歌曲信息/自定义谱师信息/表格/封面信息/信息/表格/滚动栏/简介'.text=列表文件.模组简介
		else:
			$'/root/根场景/根界面/游戏菜单/歌曲信息/自定义谱师信息/表格/封面信息/信息/表格/滚动栏/简介'.text="该歌曲合集没有写简介……"
	else:
		$'/root/根场景/根界面/游戏菜单/歌曲信息/自定义谱师信息/表格/封面信息/信息/表格/滚动栏/简介'.text="该歌曲合集没有写简介……"
	$'/root/根场景/根界面/游戏菜单/歌曲信息/自定义谱师信息/表格/歌曲合集信息/表格/容器/歌曲数量/文字'.text=var_to_str(列表文件.歌曲列表.size())
	$'/root/根场景/根界面/游戏菜单/歌曲信息/底栏/进入选歌列表'.请求引用节点=self
	$'/root/根场景/根界面/游戏菜单/歌曲信息/底栏/进入选歌列表'.文件路径=文件路径
	$'/root/根场景/根界面/游戏菜单/歌曲信息/底栏/进入选歌列表'.歌曲集合名称=名称
	$'/root/根场景/根界面/游戏菜单/歌曲信息/底栏/进入选歌列表'.被添加歌曲节点=get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表/"+名称+"/容器")
	$'/root/根场景/根界面/游戏菜单/歌曲信息/底栏/进入选歌列表'.show()
	pass
	
func 添加指定传统歌曲(起始页面:int,文件路径:String,名称:String,指定节点:Node,歌曲卡片数量:int=30)->void:
	#删除旧的歌曲卡片
	$'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/加载提示标签'.show()
	歌曲加载状态=true
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/翻页栏".自定义歌曲引用=true
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/翻页栏".文件路径=文件路径
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/翻页栏".歌曲集合名称=名称
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/翻页栏".被添加歌曲节点=指定节点
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/翻页栏".自定义歌曲网格节点=self
	for 子节点循环 in 指定节点.get_child_count():
		var 子节点 = 指定节点.get_child(子节点循环)
		if 子节点.has_node("容器/容器/歌曲名")&&子节点.has_node("容器/容器/艺术家")&&子节点.has_node("容器/卡片头/编号"):
			子节点.queue_free()
	#用于添加“歌曲卡片数量“个翻页歌曲卡片
	var 循环次数:int=歌曲卡片数量
	var 列表文件:Dictionary = JSON.parse_string(FileAccess.open(文件路径+"/list.cfg",FileAccess.READ).get_as_text())
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/翻页栏".总页面=ceili(列表文件.歌曲列表.size()/歌曲卡片数量)+1
	if 起始页面*歌曲卡片数量>=列表文件.歌曲列表.size():
		if 歌曲卡片数量>=列表文件.歌曲列表.size():
			循环次数=列表文件.歌曲列表.size()
		else:
			循环次数=列表文件.歌曲列表.size()-(起始页面-1)*歌曲卡片数量
		pass
	$/root/根场景/根界面/窗口/加载窗口/容器/容器/右标签.text=var_to_str(循环次数)
	$/root/根场景/根界面/窗口/加载窗口/容器/进度条.max_value=循环次数
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/加载提示标签".max_value=循环次数
	for 循环 in 循环次数:
		var 对象谱面文件=JSON.parse_string(FileAccess.open(文件路径+"/"+列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件,FileAccess.READ).get_as_text())
		if 对象谱面文件!=null&&对象谱面文件.has("musics")==true:
			$/root/根场景/根界面/窗口/加载窗口/容器/容器/文件名.text=列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件
			$/root/根场景/根界面/窗口/加载窗口/容器/容器/左标签.text=var_to_str(循环+1)
			$/root/根场景/根界面/窗口/加载窗口/容器/进度条.value=循环+1
			$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/加载提示标签".value=循环+1
			$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/加载提示标签/进度".text=var_to_str(循环+1)+"/"+var_to_str(循环次数)
			var 传统歌曲卡片=歌曲卡片场景.instantiate()
			传统歌曲卡片.get_node("容器/容器/歌曲名").text = 列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件
			传统歌曲卡片.get_node("容器/容器/艺术家").text = 列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].艺术家
			传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str((起始页面-1)*歌曲卡片数量+循环+1)
			var 准备按钮 = Button.new()
			准备按钮.text = "准备"
			准备按钮.custom_minimum_size=Vector2(100,0)
			var 封面歌曲名=列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件
			准备按钮.pressed.connect(歌曲卡片按钮按下.bind(列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件,列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].艺术家,文件路径+"/"+列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件))
			传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
			指定节点.add_child(传统歌曲卡片)
			await get_tree().create_timer(0.0).timeout
		pass
	pass
	#隐藏其他的歌曲合集列表
	for 自定义歌曲列表循环 in get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表").get_child_count():
		get_node("/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表").get_child(自定义歌曲列表循环).hide()
	#if 歌曲加载状态==false:
	$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.stop()
	$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.play("下拉框动画")
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/歌曲列表".show()
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/翻页栏".刷新状态()
	$'/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/加载提示标签'.hide()
	指定节点.get_node("../").show()
	指定节点.show()
	歌曲加载状态=false
	if 歌曲待刷新状态.状态==true:
		歌曲待刷新状态.状态=false
		var 通知=通知节点.instantiate()
		通知.get_node("控件/标题").text="正在加载歌曲列表"
		通知.get_node("控件/内容").text="正在加载第"+var_to_str(歌曲待刷新状态.页码)+"页，请耐心等待……"
		$'/root/根场景/根界面/通知栏'.add_child(通知)
		添加指定传统歌曲(歌曲待刷新状态.页码,文件路径,名称,指定节点,歌曲卡片数量)
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
	$'/root/根场景/根界面/游戏菜单/歌曲信息/底栏/进入选歌列表'.show()
	pass # Replace with function body.
#
func 歌曲卡片按钮按下(封面歌曲名,封面艺术家,对象文件路径):
	$'/root/根场景/主场景'.歌曲类型格式=1
	if $'/root/根场景/根界面/游戏菜单/歌曲信息/文本'.visible==true||$'/root/根场景/根界面/游戏菜单/歌曲信息/自定义谱师信息'.visible==true:
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
		var 通知=通知节点.instantiate()
		通知.get_node("控件/标题").text="读取失败"
		通知.get_node("控件/内容").text="找不到谱面文件"
		$'/root/根场景/根界面/通知栏'.add_child(通知)
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
			var 通知=通知节点.instantiate()
			通知.get_node("控件/标题").text="读取失败"
			通知.get_node("控件/内容").text="谱面文件解析错误"
			$'/root/根场景/根界面/通知栏'.add_child(通知)
		elif 对象谱面文件.has("musics")==false:
			#不是游戏的对象文件格式的
			$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.stop()
			$'/root/根场景/根界面/游戏菜单/歌曲信息/界面动画'.play("文本提示打开")
			$'/root/根场景/根界面/游戏菜单/歌曲信息/文本/文本提示'.text="糟糕，谱面文件解析错误！\n请检查该文件格式是否正确？\n文件路径:"+对象文件路径
			var 通知=通知节点.instantiate()
			通知.get_node("控件/标题").text="读取失败"
			通知.get_node("控件/内容").text="谱面文件解析错误"
			$'/root/根场景/根界面/通知栏'.add_child(通知)
		else:
			#解析成功
			#解析歌曲是否存在对应的音频文件
			var MP3音频文件路径 = 'res://音乐/额外/'+封面歌曲名+'.mp3'
			var WAV音频文件路径 = 'res://音乐/额外/'+封面歌曲名+'.wav'
			var OGG音频文件路径 = 'res://音乐/额外/'+封面歌曲名+'.ogg'
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
			#粗略统计物量(偏离实际值)
			var 物量统计:int=0
			var 玩法状态:bool=false
			#段落循环
			for 对象谱面阶段循环 in 对象谱面文件.musics.size():
				var 物件 = 对象谱面文件.musics[对象谱面阶段循环].scores[0]
				物件=物件.replace(";",",")
				while 物件.count(",,")>0:
					物件=物件.replace(",,",",")
				物件=物件.split(",")
				#如果数组结尾不是空子集，则就创建
				if 物件[物件.size()-1]!="":
					物件.push_back("")
				for 循环 in 物件.size()-1:
					var 物件格式转换=物件[循环]
					if 物件格式转换.count('1<') > 0 || 物件格式转换.count('2<') > 0:
						物量统计+=1
					elif 物件格式转换.count('3<') > 0 || 物件格式转换.count('6<') > 0 || 物件格式转换.count('7<') > 0 || 物件格式转换.count('8<') > 0:
						物量统计+=1
						if 物件格式转换.count('>') > 0:
							玩法状态=false
						else:
							玩法状态=true
					elif 物件格式转换.count('5<') > 0:
						物量统计+=2
						if 物件格式转换.count('>') > 0:
							玩法状态=false
						else:
							玩法状态=true
					#暂时不统计字物件的数量
					elif 物件格式转换.count('9<') > 0:
						物量统计+=1
						if 物件格式转换.count('>') > 0:
							玩法状态=false
						else:
							玩法状态=true
					elif 物件格式转换.count('10<') > 0:
						物量统计+=1
						玩法状态=false
					elif 物件格式转换.count('>') > 0:
						玩法状态=false
					else:
						#把空白符也当成物件,暂不修改
						if 玩法状态==false:
							物量统计+=1
				
			
			$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/详细/表格/容器/物件数量/数值'.text=var_to_str(物量统计)
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
	全局脚本.谱面每分钟节拍=$/root/根场景/根界面/游戏菜单.谱面每分钟节拍
	全局脚本.谱面基础节拍=$/root/根场景/根界面/游戏菜单.谱面基础节拍


func 加载弹窗关闭():
	$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.stop()
	$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.play("下拉框动画")
	pass
