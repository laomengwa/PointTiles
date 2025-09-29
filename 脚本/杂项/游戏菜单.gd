extends Control
@onready var 歌曲卡片场景=preload('res://场景/歌曲卡片.tscn')
@onready var 游玩排名记录=preload("res://场景/玩家排名.tscn")

@onready var 黑块场景 = preload("res://场景/音符/黑块.tscn")
@onready var 长块场景 = preload("res://场景/音符/长块.tscn")
@onready var 叠块场景 = preload("res://场景/音符/狂戳.tscn")
@onready var 滑条场景 = preload("res://场景/音符/滑块.tscn")
@onready var 六角块场景 = preload("res://场景/音符/爆裂.tscn")
@onready var 绿键场景 = preload("res://场景/音符/绿键.tscn")
@onready var 滑键场景 = preload("res://场景/音符/滑键.tscn")
@onready var 圆球场景 = preload("res://场景/音符/旋转.tscn")
@onready var 弯曲滑条场景 = preload("res://场景/音符/弯曲滑块.tscn")
#这个变量检测界面是否处在竖屏状态，如果为真就是竖屏状态，否则为横屏状态
var 界面宽度检测:bool = false
#这个变量检测竖屏状态下详细页面的状态，如果为真就是详细页面，否则为选歌列表
var 竖屏界面布局检测:bool = false
var 对象谱面文件读取:Dictionary
var 谱面每分钟节拍:Array = []
var 谱面基础节拍:Array = []
var 数码乐谱文件路径:String=""
var 数码乐谱父文件夹路径:String=""
var 歌曲加载状态:bool=false
var 歌曲待刷新状态:Dictionary={"状态":false,"页码":0}
var 清空对象池状态:bool=false
var 成绩文件:String
func _ready():
	创建记录文件()
	#旧式谱面列表读取
	##代码逻辑混乱，未来会考虑重构
	if $'界面左列表/表格/容器/旧式谱面列表/列表'.get_child_count() <= 1:
		#检测歌曲列表文件是否存在
		if FileAccess.file_exists("res://音乐/旧式谱面/歌曲列表.cfg")==true:
			添加指定传统歌曲(1)
			#删除正在加载歌曲的标签节点
			$'界面左列表/表格/容器/加载提示标签'.hide()
		else:
			var 歌曲无文件提示=Label.new()
			歌曲无文件提示.text="糟糕，找不到歌曲……"
			歌曲无文件提示.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
			歌曲无文件提示.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
			歌曲无文件提示.anchors_preset=15
			$'界面左列表/表格/容器/旧式谱面列表/列表'.add_child(歌曲无文件提示)
			printerr("无文件")
	#正式谱面列表读取
	数码乐谱文件路径="res://音乐/二进制谱面/"
	for 文件循环 in DirAccess.get_files_at(数码乐谱文件路径).size():
		#var MIDI文件=FileAccess.open("res://音乐/二进制谱面/"+DirAccess.get_files_at("res://音乐/二进制谱面")[文件循环],FileAccess.READ_WRITE)
		var 传统歌曲卡片=歌曲卡片场景.instantiate()
		传统歌曲卡片.get_node("容器/容器/歌曲名").text = DirAccess.get_files_at(数码乐谱文件路径)[文件循环]
		传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str(文件循环+1)
		var 准备按钮 = Button.new()
		准备按钮.text = "准备"
		准备按钮.custom_minimum_size=Vector2(100,0)
		传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
		准备按钮.pressed.connect(数码曲谱卡片按下.bind(数码乐谱文件路径+DirAccess.get_files_at(数码乐谱文件路径)[文件循环],数码乐谱文件路径))
		$'界面左列表/表格/容器/数码曲谱列表/列表'.add_child(传统歌曲卡片)
	if $'界面左列表/表格/容器/传统玩法列表/列表'.get_child_count() <= 1:
		#检测歌曲列表文件是否存在
		if FileAccess.file_exists("res://音乐/传统玩法关卡/歌曲列表.cfg")==true:
			歌曲加载状态=true
			$"界面左列表/表格/搜索栏/输入框".editable=false
			$"界面左列表/表格/搜索栏/输入框".placeholder_text="歌曲列表加载状态下不能搜索！"
			$"界面左列表/表格/搜索栏/输入框".tooltip_text="歌曲列表加载状态下不能搜索！"
			$"界面左列表/表格/搜索栏/搜索".disabled=true
			$"界面左列表/表格/容器/翻页栏".自定义歌曲网格节点=self
			#清除节点
			for 子节点循环 in $'界面左列表/表格/容器/传统玩法列表/列表'.get_child_count():
				var 子节点 = $'界面左列表/表格/容器/传统玩法列表/列表'.get_child(子节点循环)
				if 子节点.has_node("容器/容器/歌曲名")&&子节点.has_node("容器/容器/艺术家")&&子节点.has_node("容器/卡片头/编号"):
					子节点.queue_free()
			#用于添加“歌曲卡片数量“个翻页歌曲卡片
			var 列表文件:Dictionary = JSON.parse_string(FileAccess.open("res://音乐/传统玩法关卡/歌曲列表.cfg",FileAccess.READ).get_as_text())
			$'界面左列表/表格/容器/加载提示标签'.max_value=列表文件.歌曲列表.size()
			$'界面左列表/表格/容器/加载提示标签'.show()
			for 循环 in 列表文件.歌曲列表.size():
				$/root/根场景/根界面/窗口/加载窗口/容器/容器/文件名.text=列表文件.歌曲列表[循环].文件
				$/root/根场景/根界面/窗口/加载窗口/容器/容器/左标签.text=var_to_str(循环+1)
				$/root/根场景/根界面/窗口/加载窗口/容器/进度条.value=循环+1
				$"界面左列表/表格/自定义/下拉框/加载提示标签/进度".text=var_to_str(循环+1)+"/"+var_to_str(列表文件.歌曲列表.size())
				$'界面左列表/表格/容器/加载提示标签/进度'.text=var_to_str(循环+1)+"/"+var_to_str(列表文件.歌曲列表.size())
				$'界面左列表/表格/容器/加载提示标签'.value=循环+1
				var 传统歌曲卡片=歌曲卡片场景.instantiate()
				传统歌曲卡片.get_node("容器/容器/歌曲名").text = 列表文件.歌曲列表[循环].文件
				传统歌曲卡片.get_node("容器/容器/艺术家").text = 列表文件.歌曲列表[循环].艺术家
				传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str(循环+1)
				#设置卡片头纹理
				if 列表文件.歌曲列表[循环].卡片头!="":
					var 卡片头纹理路径:String="res://音乐/传统玩法关卡/卡片头图片/"+列表文件.歌曲列表[循环].卡片头+".png"
					if FileAccess.file_exists(卡片头纹理路径)==true:
						var 卡片头纹理=load(卡片头纹理路径)
						传统歌曲卡片.get_node("容器/卡片头").set_texture(卡片头纹理)
				#隐藏段位显示
				if 列表文件.歌曲列表[循环].has("可段位划分"):
					if 列表文件.歌曲列表[循环].可段位划分==false:
						传统歌曲卡片.get_node("容器/容器/成绩段位/段位").hide()
						pass
					pass
				var 准备按钮 = Button.new()
				准备按钮.text = "准备"
				准备按钮.custom_minimum_size=Vector2(100,0)
				准备按钮.pressed.connect(传统玩法卡片按下.bind(列表文件.歌曲列表[循环]))
				传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
				$'界面左列表/表格/容器/传统玩法列表/列表'.add_child(传统歌曲卡片)
				await get_tree().create_timer(0.0).timeout
			$"界面左列表/表格/容器/翻页栏".刷新状态()
			$'界面左列表/表格/容器/加载提示标签'.hide()
			$"界面左列表/表格/搜索栏/输入框".editable=true
			$"界面左列表/表格/搜索栏/输入框".placeholder_text="输入歌曲名以搜索……"
			$"界面左列表/表格/搜索栏/输入框".tooltip_text="输入歌曲名以搜索……"
			$"界面左列表/表格/搜索栏/搜索".disabled=false
			歌曲加载状态=false
			$'界面左列表/表格/容器/加载提示标签'.hide()
		else:
			var 歌曲无文件提示=Label.new()
			歌曲无文件提示.text="糟糕，找不到歌曲……"
			歌曲无文件提示.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
			歌曲无文件提示.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
			歌曲无文件提示.anchors_preset=15
			$'界面左列表/表格/容器/传统玩法列表/列表'.add_child(歌曲无文件提示)
			printerr("无文件")
			
func _process(_帧处理):
	#UI自适应
	#竖屏
	if $'/root/根场景/根界面'.size[0] <= 720 * get_tree().root.content_scale_factor:
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

func 创建记录文件()->void:
	#创建配置文件
	if OS.has_feature("template")==false:
		#调试模式
		成绩文件="res://测试/游玩记录.cfg"
		$"../游戏界面".文件路径=成绩文件
		var 目录=DirAccess.open("res://")
		#如果没有该文件夹，则就创建
		if 目录.dir_exists("测试")==false:
			目录.make_dir("测试")
		#如果没有设置配置文件，则就创建
		elif FileAccess.file_exists(成绩文件)==false || JSON.parse_string(FileAccess.open(成绩文件, FileAccess.READ).get_as_text())==null:
			FileAccess.open(成绩文件, FileAccess.WRITE)
			var 歌曲列表数据:Dictionary={
					"传统歌曲成绩":{},
					"正式歌曲成绩":{},
					"特殊玩法成绩":{}
				}
			var 文件=FileAccess.open(成绩文件, FileAccess.WRITE)
			文件.store_line(JSON.stringify(歌曲列表数据))
			文件.close()
	else:
		#打包后的正式游戏
		var 目录:DirAccess
		成绩文件="user://指向黑块/游玩记录.cfg"
		目录=DirAccess.open("user://")
		$"../游戏界面".文件路径=成绩文件
		#如果没有该文件夹，则就创建
		if 目录.dir_exists("指向黑块")==false:
			目录.make_dir("指向黑块")
		#如果没有设置配置文件，则就创建
		elif FileAccess.file_exists(成绩文件)==false || JSON.parse_string(FileAccess.open(成绩文件, FileAccess.WRITE).get_as_text())==null:
			FileAccess.open(成绩文件, FileAccess.WRITE)
			var 歌曲列表数据:Dictionary={
					"传统歌曲成绩":{},
					"正式歌曲成绩":{},
					"特殊玩法成绩":{}
				}
			var 文件=FileAccess.open(成绩文件, FileAccess.WRITE)
			文件.store_line(JSON.stringify(歌曲列表数据))
			文件.close()
	pass
func 读取成绩内容(歌曲类型:int,合辑名称:String,当前歌曲名称:String,歌曲排序:int=0,逆向排序:bool=false)->void:
	#清除本地排行榜
	for 子节点循环 in $'../结算画面/右列表/本地排名/表格/容器/排名表'.get_child_count():
		var 子节点 = $'../结算画面/右列表/本地排名/表格/容器/排名表'.get_child(子节点循环)
		子节点.queue_free()
	var 成绩内容=JSON.parse_string(FileAccess.open(成绩文件, FileAccess.READ).get_as_text())
	if 成绩内容!=null:
		if 成绩内容.has("正式歌曲成绩")==false:
			成绩内容.set("正式歌曲成绩",{})
		if 成绩内容.has("传统歌曲成绩")==false:
			成绩内容.set("传统歌曲成绩",{})
		if 成绩内容.has("特殊玩法成绩")==false:
			成绩内容.set("特殊玩法成绩",{})
		var 二级成绩内容:Dictionary
		match 歌曲类型:
			0:
				二级成绩内容=成绩内容.正式歌曲成绩
			1:
				二级成绩内容=成绩内容.传统歌曲成绩
		if 二级成绩内容.has(合辑名称)==false:
			二级成绩内容.set(合辑名称,{})
		#读取游玩记录
		if 二级成绩内容.get(合辑名称).has(当前歌曲名称)==false:
			二级成绩内容.get(合辑名称).set(当前歌曲名称,[])
		if 二级成绩内容.get(合辑名称).get(当前歌曲名称).size()==0:
			#未挑战歌曲的情况
			$'歌曲信息/歌曲信息/容器/成绩/表格/容器/最终评价/文字'.text = "未挑战"
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/最大连击数/文字".text="0"
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/最快手速/文字".text="0.000"
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/最高得分/文字".text="0"
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/精确度/文字".text="0.00%"
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/无瑕度/数值".text="0"
			$"../结算画面/左列表/结算/界面容器/界面容器/界面容器/得分".text = "0"
			$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/精确度/数值".text="0.00%"
			$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/连击数/数值".text = "0"
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/完美/数值".text="0"
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/良好/数值".text="0"
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/较差/数值".text="0"
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/很差/数值".text="0"
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/失误/数值".text="0"
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/漏击/数值".text="0"
			$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/无瑕度/数值".text="0"
			$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/速度/数值".text="0.000"
			$"歌曲信息/歌曲信息/容器/封面/边框/容器/等级".hide()
			$"../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/等级".text="未挑战"
			$"../游戏界面/历史成绩/容器/信息/得分/标签3".text="0"
			$"../游戏界面/历史成绩/容器/信息/得分/标签6".text="0.00"
			$"../游戏界面/历史成绩/容器/评分".text="未挑战"
		else:
			#筛选挑战分数最高的本地记录
			var 最佳分数记录:int=0
			for 循环 in 二级成绩内容.get(合辑名称).get(当前歌曲名称).size():
				if 二级成绩内容.get(合辑名称).get(当前歌曲名称).size()>=2:
					#冒泡排序
					for 二级循环 in 二级成绩内容.get(合辑名称).get(当前歌曲名称).size()-1-循环:
						var 交换字典:Dictionary
						var 大小判定:bool=false
						match 歌曲排序:
							0:#按分数
								大小判定=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环].分数<二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1].分数
							1:#按手速
								大小判定=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环].最快手速<二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1].最快手速
							3:#按最大连击数
								大小判定=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环].最大连击数<二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1].最大连击数
							4:#按无瑕度
								大小判定=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环].无瑕度>二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1].无瑕度
							5:#按完美评价
								大小判定=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环].判定详细[0]<二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1].判定详细[0]
							6:#按段位
								大小判定=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环].获得段位<二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1].获得段位
							7:#按游玩时间
								大小判定=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环].游玩时间>二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1].游玩时间
							2,_:#按精确度
								大小判定=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环].精确度<二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1].精确度
						if 大小判定==!逆向排序:
							交换字典=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1]
							二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环+1]=二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环]
							二级成绩内容.get(合辑名称).get(当前歌曲名称)[二级循环]=交换字典
						pass
				if 二级成绩内容.get(合辑名称).get(当前歌曲名称)[循环].分数>=二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].分数:
					最佳分数记录=循环
			二级成绩内容.get(合辑名称).get(当前歌曲名称)
			#添加本地排行
			for 循环 in 二级成绩内容.get(合辑名称).get(当前歌曲名称).size():
				var 排行=游玩排名记录.instantiate()
				排行.成绩数据=二级成绩内容.get(合辑名称).get(当前歌曲名称)[循环]
				if 歌曲排序!=7:
					if 逆向排序==false:
						排行.get_node("卡片/排名").text=var_to_str(循环+1)
					else:
						排行.get_node("卡片/排名").text=var_to_str(二级成绩内容.get(合辑名称).get(当前歌曲名称).size()-循环)
				else:
					排行.get_node("卡片/排名").hide()
				排行.get_node("卡片/左列表/分数和手速/分数").text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[循环].分数))
				排行.get_node("卡片/左列表/分数和手速/精确度").text="%.2f" %float(二级成绩内容.get(合辑名称).get(当前歌曲名称)[循环].精确度)
				排行.get_node("卡片/左列表/分数和手速/手速").text="%.3f" %float(二级成绩内容.get(合辑名称).get(当前歌曲名称)[循环].最快手速)
				排行.get_node("卡片/右列表/评价").text=二级成绩内容.get(合辑名称).get(当前歌曲名称)[循环].等级评价
				排行.get_node("卡片/右列表/游玩时间").text=Time.get_datetime_string_from_unix_time(二级成绩内容.get(合辑名称).get(当前歌曲名称)[循环].游玩时间+Time.get_time_zone_from_system().bias*60,true)
				$'../结算画面/右列表/本地排名/表格/容器/排名表'.add_child(排行)
			$'歌曲信息/歌曲信息/容器/成绩/表格/容器/最终评价/文字'.text = 二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].等级评价
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/最大连击数/文字".text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].最大连击数))
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/最快手速/文字".text="%.3f" %float(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].最快手速)
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/最高得分/文字".text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].分数))
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/精确度/文字".text="%.2f" %float(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].精确度)+"%"
			$"歌曲信息/歌曲信息/容器/成绩/表格/容器/无瑕度/数值".text="%.2f" %float(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].无瑕度)
			$"../结算画面/左列表/结算/界面容器/界面容器/界面容器/得分".text = var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].分数))
			$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/精确度/数值".text="%.2f" %float(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].精确度)+"%"
			$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/连击数/数值".text = var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].最大连击数))
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/完美/数值".text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].判定详细[0]))
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/良好/数值".text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].判定详细[1]))
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/较差/数值".text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].判定详细[2]))
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/很差/数值".text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].判定详细[3]))
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/失误/数值".text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].判定详细[5]))
			$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/漏击/数值".text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].判定详细[4]))
			$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/无瑕度/数值".text="%.2f" %float(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].无瑕度)
			$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/速度/数值".text="%.3f" %float(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].最快手速)
			$"歌曲信息/歌曲信息/容器/封面/边框/容器/等级".show()
			$"歌曲信息/歌曲信息/容器/封面/边框/容器/等级".text="甲"
			$"../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/等级".text="甲"
			$"../游戏界面/历史成绩/容器/信息/得分/标签3".text=var_to_str(int(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].分数))
			$"../游戏界面/历史成绩/容器/信息/得分/标签6".text="%.2f" %float(二级成绩内容.get(合辑名称).get(当前歌曲名称)[最佳分数记录].精确度)
			$"../游戏界面/历史成绩/容器/评分".text="甲"
			pass
	else:
		$'歌曲信息/歌曲信息/容器/成绩/表格/容器/最终评价/文字'.text = "未挑战"
		$"歌曲信息/歌曲信息/容器/成绩/表格/容器/最大连击数/文字".text="0"
		$"歌曲信息/歌曲信息/容器/成绩/表格/容器/最快手速/文字".text="0.000"
		$"歌曲信息/歌曲信息/容器/成绩/表格/容器/最高得分/文字".text="0"
		$"歌曲信息/歌曲信息/容器/成绩/表格/容器/精确度/文字".text="0.00%"
		$"歌曲信息/歌曲信息/容器/成绩/表格/容器/无瑕度/数值".text="0"
		$"../结算画面/左列表/结算/界面容器/界面容器/界面容器/得分".text = "0"
		$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/精确度/数值".text="0.00%"
		$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/连击数/数值".text = "0"
		$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/完美/数值".text="0"
		$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/良好/数值".text="0"
		$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/较差/数值".text="0"
		$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/很差/数值".text="0"
		$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/失误/数值".text="0"
		$"../结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/漏击/数值".text="0"
		$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/无瑕度/数值".text="0"
		$"../结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/速度/数值".text="0.000"
		$"歌曲信息/歌曲信息/容器/封面/边框/容器/等级".hide()
		$"../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/等级".text="未挑战"
		$"../游戏界面/历史成绩/容器/信息/得分/标签3".text="0"
		$"../游戏界面/历史成绩/容器/信息/得分/标签6".text="0.00"
		$"../游戏界面/历史成绩/容器/评分".text="未挑战"
		$"../游戏界面".保存记录失败()
	pass
func 添加指定传统歌曲(起始页面:int,歌曲卡片数量:int=30,指定节点:Node=$'界面左列表/表格/容器/旧式谱面列表/列表')->void:
	#删除旧的歌曲卡片
	歌曲加载状态=true
	$"界面左列表/表格/搜索栏/输入框".editable=false
	$"界面左列表/表格/搜索栏/输入框".placeholder_text="歌曲列表加载状态下不能搜索！"
	$"界面左列表/表格/搜索栏/输入框".tooltip_text="歌曲列表加载状态下不能搜索！"
	$"界面左列表/表格/搜索栏/搜索".disabled=true
	$"界面左列表/表格/容器/翻页栏".自定义歌曲网格节点=self
	for 子节点循环 in 指定节点.get_child_count():
		var 子节点 = 指定节点.get_child(子节点循环)
		if 子节点.has_node("容器/容器/歌曲名")&&子节点.has_node("容器/容器/艺术家")&&子节点.has_node("容器/卡片头/编号"):
			子节点.queue_free()
	#用于添加“歌曲卡片数量“个翻页歌曲卡片
	var 列表文件:Dictionary = JSON.parse_string(FileAccess.open("res://音乐/旧式谱面/歌曲列表.cfg",FileAccess.READ).get_as_text())
	var 循环次数:int=歌曲卡片数量
	$"界面左列表/表格/容器/翻页栏".总页面=ceili(列表文件.歌曲列表.size()/歌曲卡片数量)+1
	if 起始页面*歌曲卡片数量>=列表文件.歌曲列表.size():
		if 歌曲卡片数量>=列表文件.歌曲列表.size():
			循环次数=列表文件.歌曲列表.size()
		else:
			循环次数=列表文件.歌曲列表.size()-(起始页面-1)*歌曲卡片数量
		pass
	$'界面左列表/表格/容器/加载提示标签'.max_value=循环次数
	$'界面左列表/表格/容器/加载提示标签'.show()
	for 循环 in 循环次数:
		var 对象谱面文件=JSON.parse_string(FileAccess.open("res://音乐/旧式谱面/"+列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件+".json",FileAccess.READ).get_as_text())
		if 对象谱面文件!=null&&对象谱面文件.has("musics")==true:
			$/root/根场景/根界面/窗口/加载窗口/容器/容器/文件名.text=列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件
			$/root/根场景/根界面/窗口/加载窗口/容器/容器/左标签.text=var_to_str(循环+1)
			$/root/根场景/根界面/窗口/加载窗口/容器/进度条.value=循环+1
			$"界面左列表/表格/自定义/下拉框/加载提示标签/进度".text=var_to_str(循环+1)+"/"+var_to_str(循环次数)
			$'界面左列表/表格/容器/加载提示标签/进度'.text=var_to_str(循环+1)+"/"+var_to_str(循环次数)
			$'界面左列表/表格/容器/加载提示标签'.value=循环+1
			var 传统歌曲卡片=歌曲卡片场景.instantiate()
			传统歌曲卡片.get_node("容器/容器/歌曲名").text = 列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件
			传统歌曲卡片.get_node("容器/容器/艺术家").text = 列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].艺术家
			传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str((起始页面-1)*歌曲卡片数量+循环+1)
			#设置卡片头纹理
			if 列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].卡片头!="":
				var 卡片头纹理路径:String="res://音乐/旧式谱面/卡片头图片/"+列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].卡片头+".png"
				if FileAccess.file_exists(卡片头纹理路径)==true:
					var 卡片头纹理=load(卡片头纹理路径)
					传统歌曲卡片.get_node("容器/卡片头").set_texture(卡片头纹理)
			var 准备按钮 = Button.new()
			准备按钮.text = "准备"
			准备按钮.custom_minimum_size=Vector2(100,0)
			准备按钮.pressed.connect(歌曲卡片按钮按下.bind(列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].文件,列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].艺术家,列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].竞技场,列表文件.歌曲列表[(起始页面-1)*歌曲卡片数量+循环].加速度))
			传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
			指定节点.add_child(传统歌曲卡片)
			await get_tree().create_timer(0.0).timeout
	$"界面左列表/表格/容器/翻页栏".刷新状态()
	$'界面左列表/表格/容器/加载提示标签'.hide()
	$"界面左列表/表格/搜索栏/输入框".editable=true
	$"界面左列表/表格/搜索栏/输入框".placeholder_text="输入歌曲名以搜索……"
	$"界面左列表/表格/搜索栏/输入框".tooltip_text="输入歌曲名以搜索……"
	$"界面左列表/表格/搜索栏/搜索".disabled=false
	歌曲加载状态=false
	if 歌曲待刷新状态.状态==true:
		歌曲待刷新状态.状态=false
		全局脚本.发送通知("正在加载歌曲列表","正在加载第%d页，请耐心等待……"%歌曲待刷新状态.页码)
		添加指定传统歌曲(歌曲待刷新状态.页码,歌曲卡片数量)
	pass
func 歌曲收藏按钮按下(组件,按钮,封面歌曲名,封面艺术家,竞技场,竞技场加速度):
	if 组件.get_node("容器/容器/成绩段位/收藏").button_pressed==true:
		var 组件复制=组件.duplicate()
		var 按钮复制=按钮.duplicate(DUPLICATE_SIGNALS)
		按钮复制.pressed.connect(歌曲卡片按钮按下.bind(封面歌曲名,封面艺术家,竞技场,竞技场加速度))
		组件复制.get_node("容器/容器/成绩段位").add_child(按钮复制)
		$'界面左列表/表格/容器/收藏列表/列表'.add_child(组件复制)
	else:
		for 循环 in $'界面左列表/表格/容器/收藏列表/列表'.get_child_count():
			if $'界面左列表/表格/容器/收藏列表/列表'.get_child(循环).get_node('容器/卡片头/编号').text==组件.get_node('容器/卡片头/编号').text&&$'界面左列表/表格/容器/收藏列表/列表'.get_child(循环).get_node('容器/容器/歌曲名').text==组件.get_node('容器/容器/歌曲名').text&&$'界面左列表/表格/容器/收藏列表/列表'.get_child(循环).get_node('容器/容器/艺术家').text==组件.get_node('容器/容器/艺术家').text:
				$'界面左列表/表格/容器/收藏列表/列表'.get_child(循环).queue_free()
	pass
func 功能详细选项变更(恢复状态:bool=true)->void:
	$'歌曲信息/歌曲信息/容器/无限模式'.visible = 恢复状态
	$'歌曲信息/歌曲信息/容器/使用倾斜轨道'.visible = 恢复状态
	$'歌曲信息/歌曲信息/容器/轨道数量'.visible = 恢复状态
	$'歌曲信息/歌曲信息/容器/隐藏分隔线'.visible = 恢复状态
	$'歌曲信息/歌曲信息/容器/无轨道模式'.visible = 恢复状态
	$'歌曲信息/歌曲信息/容器/物件下落方向'.visible = 恢复状态
	$'歌曲信息/歌曲信息/容器/物件连续'.visible = 恢复状态
	$'歌曲信息/歌曲信息/容器/狂戳块节奏模式'.visible = 恢复状态
	pass
func 传统玩法卡片按下(参数:Dictionary)->void:
	if $'歌曲信息/文本'.visible==true||$'歌曲信息/自定义谱师信息'.visible==true:
		$'歌曲信息/界面动画'.stop()
		$'歌曲信息/界面动画'.play("文字提示关闭")
	$'/root/根场景/主场景'.歌曲类型格式=2
	$'../加载画面/封面/边框/容器/上容器/歌曲名称'.text = 参数.文件
	$'../加载画面/封面/边框/容器/下容器/艺术家名称'.text = ""
	$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/歌曲名称'.text = 参数.文件
	$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/容器/艺术家名称'.text = ""
	$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text = 参数.文件
	$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text = ""
	$'../游戏界面/歌曲信息/容器/歌曲名'.text=参数.文件
	$'../游戏界面/歌曲信息/容器/艺术家'.text=""
	功能详细选项变更(false)
	if 参数.参数.has("允许连续"):
		if 参数.参数.允许连续==true:
			$'歌曲信息/歌曲信息/容器/物件连续'.visible = true
	if 参数.参数.has("允许更改轨道"):
		if 参数.参数.允许更改轨道==true:
			$'歌曲信息/歌曲信息/容器/轨道数量'.visible = true
	if 参数.参数.has("允许无轨"):
		if 参数.参数.允许无轨==true:
			$'歌曲信息/歌曲信息/容器/无轨道模式'.visible = true
	$'歌曲信息/歌曲信息/容器/详细/表格/容器/谱面类型/文字'.text = "传统别踩白块模式"
	if 参数.参数.has("代码"):
		var 脚本:GDScript=GDScript.new()
		脚本.set_source_code(Marshalls.base64_to_utf8(参数.参数.代码))
		var 公式错误检测=脚本.reload()
		if 公式错误检测==OK:
			$"/root/根场景/主场景/轨道".set_script(脚本)
		else:
			全局脚本.发送通知("歌曲加载错误","实现这一歌曲玩法的描述文件出错！请检查资源完整性。")
			printerr("错误")
		print($"/root/根场景/主场景/轨道".get_script().get_source_code())
	else:
		全局脚本.发送通知("歌曲加载错误","实现这一歌曲玩法的描述文件不存在！请检查资源完整性。")
	pass
	
func 数码曲谱卡片按下(文件路径,父文件夹路径):
	var 文件大小=FileAccess.open(文件路径,FileAccess.READ).get_length()
	数码乐谱文件路径=文件路径
	数码乐谱父文件夹路径=父文件夹路径
	#检查想播放的谱子是否是与正在播放的谱子一致？一致则忽略变更请求
	if 数码乐谱文件路径!=$'/root/根场景/视角节点/MidiPlayer'.file||$'/root/根场景/主场景'.歌曲类型格式!=0:
		if $'歌曲信息/文本'.visible==true||$'歌曲信息/自定义谱师信息'.visible==true:
			$'歌曲信息/界面动画'.stop()
			$'歌曲信息/界面动画'.play("文字提示关闭")
		#检查文件大小
		#如果文件小于1MiB
		if 文件大小<=1048576:
			允许播放乐谱()
		#如果文件小于10MiB（小型黑乐谱）
		elif 文件大小<=10485760:
			$'../窗口/文件过大警告/容器/轻微'.show()
			$'../窗口/文件过大警告/容器/严重'.hide()
			$'界面左列表/界面动画'.play("警告窗口")
		#大型黑乐谱
		else:
			$'../窗口/文件过大警告/容器/轻微'.hide()
			$'../窗口/文件过大警告/容器/严重'.show()
			$'界面左列表/界面动画'.play("警告窗口")
			全局脚本.发送通知("读取失败","文件过大，无法读取")
		pass
	else:
		if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor && 界面宽度检测 == true:
			$'界面动画'.play("详细界面扩张")
			竖屏界面布局检测 = true
#(文件,艺术家,竞技场,加速度)
func 歌曲卡片按钮按下(封面歌曲名,封面艺术家,竞技场模式,竞技场加速度):
	$'/root/根场景/主场景'.歌曲类型格式=1
	$'../游戏界面'.合辑名称="内置"
	$'../游戏界面'.当前歌曲名称=封面歌曲名
	if $'歌曲信息/文本'.visible==true||$'歌曲信息/自定义谱师信息'.visible==true:
		$'歌曲信息/界面动画'.stop()
		$'歌曲信息/界面动画'.play("文字提示关闭")
	谱面每分钟节拍 = []
	谱面基础节拍 = []
	$'../加载画面/封面/边框/容器/上容器/歌曲名称'.text = 封面歌曲名
	$'../加载画面/封面/边框/容器/下容器/艺术家名称'.text = 封面艺术家
	$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/歌曲名称'.text = 封面歌曲名
	$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/容器/艺术家名称'.text = 封面艺术家
	$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text = 封面歌曲名
	$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text = 封面艺术家
	$'../游戏界面/歌曲信息/容器/歌曲名'.text=封面歌曲名
	$'../游戏界面/歌曲信息/容器/艺术家'.text=封面艺术家
	$'歌曲信息/歌曲信息/容器/详细/表格/容器/谱面类型/文字'.text = "下落式旧格式谱面"
#	var 对象谱面文件路径 = 'user://json_chart/'+封面歌曲名+'.json'
	var 对象谱面文件路径 = 'res://音乐/旧式谱面/'+封面歌曲名+'.json'
	#检测json文件是否存在
	if FileAccess.file_exists(对象谱面文件路径)==false:
		#json文件不存在
		$'歌曲信息/界面动画'.stop()
		$'歌曲信息/界面动画'.play("文本提示打开")
		$'歌曲信息/文本/文本提示'.text="糟糕，找不到谱面文件！\n请检查该文件是否存在？\n文件路径:"+对象谱面文件路径
		全局脚本.发送通知("读取失败","找不到谱面文件")
	else:
		#json文件存在
		if $'歌曲信息/文本'.visible==true:
			$'歌曲信息/界面动画'.play("文字提示关闭")
		var 文件大小=FileAccess.open(对象谱面文件路径,FileAccess.READ).get_length()
		var 对象谱面文件 = JSON.parse_string(FileAccess.open(对象谱面文件路径,FileAccess.READ).get_as_text())
		if 对象谱面文件==null:
			#如果解析失败
			$'歌曲信息/界面动画'.stop()
			$'歌曲信息/界面动画'.play("文本提示打开")
			$'歌曲信息/文本/文本提示'.text="糟糕，谱面文件解析错误！\n请检查该文件格式是否正确？\n文件路径:"+对象谱面文件路径
			全局脚本.发送通知("读取失败","谱面文件解析错误")
		else:
			#解析成功
			读取成绩内容(1,"内置",封面歌曲名)
			#解析歌曲是否存在对应的音频文件
			var MP3音频文件路径 = 'res://音乐/旧式谱面/'+封面歌曲名+'.mp3'
			var WAV音频文件路径 = 'res://音乐/旧式谱面/'+封面歌曲名+'.wav'
			var OGG音频文件路径 = 'res://音乐/旧式谱面/'+封面歌曲名+'.ogg'
			if FileAccess.file_exists(MP3音频文件路径)==true:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=load(MP3音频文件路径)
			elif FileAccess.file_exists(WAV音频文件路径)==true:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=load(WAV音频文件路径)
			elif FileAccess.file_exists(OGG音频文件路径)==true:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=load(OGG音频文件路径)
			else:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=AudioStreamGenerator.new()
			对象谱面文件读取 = 对象谱面文件
			#粗略统计物量(偏离实际值)
			var 物量统计:int=0
			var 玩法状态:bool=false
			#段落循环
			for 对象谱面阶段循环 in 对象谱面文件读取.musics.size():
				var 物件 = 对象谱面文件读取.musics[对象谱面阶段循环].scores[0]
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
			$歌曲信息/歌曲信息/容器/详细/表格/容器/物件数量/数值.text=var_to_str(物量统计)
			$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = 全局脚本.存储单位转换(文件大小)
			$'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = ""
			$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = ""
			$'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text = ""
			$'歌曲信息/歌曲信息/容器/详细/表格/容器/物件数量/数值'.text=var_to_str(物量统计)
			var 空格检测:String=" "
			功能详细选项变更(true)
			for 对象谱面阶段循环 in 对象谱面文件.musics.size():
				if 对象谱面阶段循环==对象谱面文件.musics.size()-1:
					空格检测=""
				$'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text + var_to_str(对象谱面文件.musics[对象谱面阶段循环].baseBeats)+空格检测
				#检查json文件是否存在“bpm”这个对象？
				if 对象谱面文件.musics[对象谱面阶段循环].has("bpm"):
					$'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text + ("%.3f" %(float(对象谱面文件.musics[对象谱面阶段循环].bpm)/((对象谱面文件.musics[对象谱面阶段循环].baseBeats)*60)))+空格检测
					$/root/根场景/根界面/游戏菜单.谱面每分钟节拍.push_back(float(对象谱面文件.musics[对象谱面阶段循环].bpm))
					$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text +var_to_str(对象谱面文件.musics[对象谱面阶段循环].bpm)+空格检测
				#检查json文件是否存在"baseBpm"这个对象？
				elif 对象谱面文件.has("baseBpm"):
					$'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text + ("%.3f" %(float(对象谱面文件.baseBpm)/((对象谱面文件.musics[对象谱面阶段循环].baseBeats)*60)))+空格检测
					$/root/根场景/根界面/游戏菜单.谱面每分钟节拍.push_back(float(对象谱面文件.baseBpm))
					$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text +var_to_str(对象谱面文件.baseBpm)+空格检测
				#如果都不存在，强制使用默认的数值
				else:
					$'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text + ("%.3f" %(60/((对象谱面文件.musics[对象谱面阶段循环].baseBeats)*60)))+空格检测
					$/root/根场景/根界面/游戏菜单.谱面每分钟节拍.push_back(60)
					$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text +"60"+空格检测
				$/root/根场景/根界面/游戏菜单.谱面基础节拍.push_back(对象谱面文件.musics[对象谱面阶段循环].baseBeats)
				#print(对象谱面文件.musics[对象谱面阶段循环].scores[0])
	#自适应界面
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor && 界面宽度检测 == true:
		$'界面动画'.play("详细界面扩张")
		竖屏界面布局检测 = true
	#检测是否为挑战赛
	if 竞技场模式==false:
		全局脚本.挑战赛加速度=[0,0,false]
	else:
		全局脚本.挑战赛加速度=[float(竞技场加速度),float(谱面每分钟节拍[0]),true]
		#对于挑战赛节拍速度为0时的处理
		for 循环 in 谱面每分钟节拍.size():
			if 谱面每分钟节拍[循环]==0:
				谱面每分钟节拍[循环]=谱面基础节拍[循环]/谱面基础节拍[0]*float(谱面每分钟节拍[0])
	全局脚本.谱面每分钟节拍=谱面每分钟节拍
	全局脚本.谱面基础节拍=谱面基础节拍
	pass
const 乐器名称: = ["Acoustic Piano","Bright Piano","Electric Grand Piano","Honky-tonk Piano","Electric Piano","Electric Piano 2","Harpsichord","Clavi","Celesta","Glockenspiel","Musical box","Vibraphone","Marimba","Xylophone","Tubular Bell","Dulcimer","Drawbar Organ","Percussive Organ","Rock Organ","Church organ","Reed organ","Accordion","Harmonica","Tango Accordion","Nylon Guiter","Steel Guiter","Jazz Guiter","Clean Guiter","Muted Guiter","Overdriven Guitar","Distortion Guitar","Guitar harmonics","Acoustic Bass","Finger Bass","Pick Bass","Fretless Bass","Slap Bass 1","Slap Bass 2","Synth Bass 1","Synth Bass 2","Violin","Viola","Cello","Double bass","Tremolo Strings","Pizzicato Strings","Orchestral Harp","Timpani","Strings 1","Strings 2","Synth Strings 1","Synth Strings 2","Voice Aahs","Voice Oohs","Synth Voice","Orchestra Hit","Trumpet","Trombone","Tuba","Muted Trumpet","French horn","Brass Section","Synth Brass 1","Synth Brass 2","Soprano Sax","Alto Sax","Tenor Sax","Baritone Sax","Oboe","English Horn","Bassoon","Clarinet","Piccolo","Flute","Recorder","Pan Flute","Blown Bottle","Shakuhachi","Whistle","Ocarina","Square Lead","Sawtooth Lead","Calliope Lead","Chiff Lead","Charang Lead","Voice Lead","Fifth Lead","Bass & Lead","Fantasia Pad","Warm Pad","Polysynth Pad","Choir Pad","Bowed Pad","Metallic Pad","Halo Pad","Sweep Pad","Rain","Soundtrack","Crystal","Atmosphere","Brightness","Goblins","Echoes","Sci-Fi","Sitar","Banjo","Shamisen","Koto","Kalimba","Bagpipe","Fiddle","Shanai","Tinkle Bell","Agogo","Steel Drums","Woodblock","Taiko Drum","Melodic Tom","Synth Drum","Reverse Cymbal","Guitar Fret Noise","Breath Noise","Seashore","Bird Tweet","Telephone Ring","Helicopter","Applause","Gunshot"]
#开始游戏
func 开始按钮():
	if $'../界面动画'.is_playing()==false:
		$/root/根场景/视角节点/MidiPlayer.stop()
		$'../游戏界面/状态信息/游戏界面进度条'.value=0
		$'/root/根场景/视角节点/背景音乐播放节点'.seek(0)
		$'/root/根场景/视角节点/背景音乐播放节点'.播放时间=0.0
		$'../加载画面/加载文字/进度条'.value=0
		$'../加载画面/加载背景动画'.play("加载谱面画面背景")
		$'../界面动画'.play("加载谱面画面")
		$'../游戏界面/歌曲循环次数'.hide()
		$"/root/根场景/主场景".判定统计=[0,0,0,0,0,0]
		$"/root/根场景/主场景".游戏界面连击数 = 0
		$"/root/根场景/主场景".最大连击数 = 0
		$"/root/根场景/主场景".游戏界面分数 = 0
		$'/root/根场景/主场景/开始按键'.show()
		$'../播放器'.停止()
		for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
			var 子节点 = $'/root/根场景/主场景/轨道'.get_child(子节点循环)
			子节点.get_node("物件区").position[1]=0
		for 子节点循环 in $'/root/根场景/主场景/无轨'.get_child_count():
			var 子节点 = $'/root/根场景/主场景/无轨'.get_child(子节点循环)
			子节点.get_node("物件区").position[1]=0
		while 清空对象池状态==true:
			await get_tree().create_timer(0.0).timeout
		#释放上次加载的曲谱的内存
		if $'/root/根场景/视角节点/MidiPlayer'.smf_data!=全局脚本.数码乐谱文件数据:
			for 循环 in $"/root/根场景/主场景/无轨".物件编号表.size():
				$"/root/根场景/主场景/无轨".物件编号表[循环].物件节点.销毁物件()
				if 循环%50==0:
					await get_tree().create_timer(0.0).timeout
				$'../加载画面/加载文字/进度条'.value=(float(循环)/$"/root/根场景/主场景/无轨".物件编号表.size())*20.0
			for 循环 in $"/root/根场景/主场景/无轨".轨道编号表.size()-1:
				$"/root/根场景/主场景/无轨".轨道编号表[循环+1].轨道节点.queue_free()
			for 循环 in $"/root/根场景/主场景/无轨".轨道编号表.size()-1:
				if $"/root/根场景/主场景/无轨".轨道编号表[循环+1].轨道节点.get_parent()!=null:
					$"/root/根场景/主场景/无轨".remove_child($"/root/根场景/主场景/无轨".轨道编号表[循环+1].轨道节点)
			$"/root/根场景/主场景/无轨".物件编号表.clear()
			$"/root/根场景/主场景/无轨".事件表.clear()
			$"/root/根场景/主场景/无轨".轨道编号表.resize(1)
		match $'/root/根场景/主场景'.歌曲类型格式:
			1:
				$"/root/根场景/主场景".谱面阶段=0
				$'/root/根场景/主场景'.声音数据集合=[]
				get_node("../游戏界面/状态信息/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
				get_node("../游戏界面/详细信息/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
				$'../加载画面/加载文字/进度条'.value=20
				##代码逻辑混乱，未来会考虑重构
				var 轨道连接:Dictionary = {}
				var 轨道物件长度连接:Dictionary = {}
				var 物件类型:Dictionary = {}
				var 乐谱声音:Dictionary = {}
				var 乐器音色:Dictionary = {}
				var 阶段时间位置:Array=[]
				var 歌曲最大音轨数量:int = 0
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
					var 乐器种类=[]
					for 对象谱面音轨循环 in 对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
						
						#判断轨道所使用的乐器
						#判断备选乐器
						if 对象谱面文件读取.musics[对象谱面阶段循环].has("alternatives"):
							#如果备选乐器为空则读取乐器属性
							if 对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环]==""||对象谱面文件读取.musics[对象谱面阶段循环].instruments[对象谱面音轨循环]!="":
								if 对象谱面文件读取.musics[对象谱面阶段循环].has("instruments"):
									if 乐器名称.has(对象谱面文件读取.musics[对象谱面阶段循环].instruments[对象谱面音轨循环])==true:
										乐器种类.push_back("0,"+var_to_str(乐器名称.find(对象谱面文件读取.musics[对象谱面阶段循环].instruments[对象谱面音轨循环])))
									else:
										match 对象谱面文件读取.musics[对象谱面阶段循环].instruments[对象谱面音轨循环]:
											"piano":
												乐器种类.push_back("0,0")
											"bass":
												乐器种类.push_back("0,32")
											"bass2":
												乐器种类.push_back("0,35")
											"drum":
												乐器种类.push_back("9,0")
											_:
												if 对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环]!="":
													if 乐器名称.has(对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环])==true:
														乐器种类.push_back("0,"+var_to_str(乐器名称.find(对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环])))
													else:
														match 对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环]:
															"piano":
																乐器种类.push_back("0,0")
															"bass":
																乐器种类.push_back("0,32")
															"bass2":
																乐器种类.push_back("0,35")
															"drum":
																乐器种类.push_back("9,0")
															#自定义情况
															_:
																乐器种类.push_back("0,0")
												else:
													乐器种类.push_back("0,0")
							else:
								if 乐器名称.has(对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环])==true:
									乐器种类.push_back("0,"+var_to_str(乐器名称.find(对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环])))
								else:
									match 对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环]:
											"piano":
												乐器种类.push_back("0,0")
											"bass":
												乐器种类.push_back("0,32")
											"bass2":
												乐器种类.push_back("0,35")
											"drum":
												乐器种类.push_back("9,0")
											#自定义情况
											_:
												乐器种类.push_back("0,0")
						else:
							乐器种类.push_back("0,0")
						if 对象谱面音轨循环==0:
							if 对象谱面阶段循环==0:
								阶段时间位置.push_back(0)
							else:
								阶段时间位置.push_back(轨道连接[0][轨道连接[0].size()-1]+轨道物件长度连接[0][轨道物件长度连接[0].size()-1])
						#处理字符串并转为数组
						var 物件 = 对象谱面文件读取.musics[对象谱面阶段循环].scores[对象谱面音轨循环]
						物件=物件.replace(";",",")
						while 物件.count(",,")>0:
							物件=物件.replace(",,",",")
						物件=物件.split(",")
						#如果数组结尾不是空子集，则就创建
						if 物件[物件.size()-1]!="":
							物件.push_back("")
						var 物件时长存储=[]
						var 轨道时长积累=[]
						var 段落音符类型=[]
						var 段落乐谱声音=[]
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
							if 物件格式转换.count('(') > 0&&物件格式转换.count(')') > 0:
								#转储音符括号内的内容
								段落乐谱声音.push_back(物件格式转换.substr(物件格式转换.find('(')+1,物件格式转换.find(')')-物件格式转换.find('(')-1))
							elif 物件格式转换.count('[') > 0&&物件格式转换.count(']') > 0:
								if 物件格式转换.find('<')<0:
									段落乐谱声音.push_back(物件格式转换.substr(0,物件格式转换.find('[')))
								else:
									段落乐谱声音.push_back(物件格式转换.substr(物件格式转换.find('<')+1,物件格式转换.find('[')-物件格式转换.find('<')-1))
							else:
								段落乐谱声音.push_back("空白")
							#物件类型检测
							if 物件格式转换.count('1<') > 0:
								段落音符类型.push_back("1")
							elif 物件格式转换.count('2<') > 0:
								段落音符类型.push_back("1")
							elif 物件格式转换.count('3<') > 0:
								if 物件格式转换.count('>') > 0:
									段落音符类型.push_back("3>")
								else:
									段落音符类型.push_back("3")
							elif 物件格式转换.count('5<') > 0:
								if 物件格式转换.count('>') > 0:
									段落音符类型.push_back("5>")
								else:
									段落音符类型.push_back("5")
							elif 物件格式转换.count('6<') > 0:
								if 物件格式转换.count('>') > 0:
									段落音符类型.push_back("6>")
								else:
									段落音符类型.push_back("6")
							elif 物件格式转换.count('7<') > 0:
								if 物件格式转换.count('>') > 0:
									段落音符类型.push_back("7>")
								else:
									段落音符类型.push_back("7")
							elif 物件格式转换.count('8<') > 0:
								if 物件格式转换.count('>') > 0:
									段落音符类型.push_back("8>")
								else:
									段落音符类型.push_back("8")
							elif 物件格式转换.count('9<') > 0:
								if 物件格式转换.count('>') > 0:
									段落音符类型.push_back("9>")
								else:
									段落音符类型.push_back("9")
							elif 物件格式转换.count('10<') > 0:
								段落音符类型.push_back("10")
							elif 物件格式转换.count('>') > 0:
								段落音符类型.push_back(">")
							else:
								#检测是否为休止符
								if 物件格式转换.count('[') > 0&&物件格式转换.count(']') > 0:
									if 物件格式时间计数>32*谱面基础节拍[对象谱面阶段循环]:
										段落音符类型.push_back("6>")
									else:
										段落音符类型.push_back("1")
								else:
									#初次检测
									段落音符类型.push_back("0")
						if 对象谱面阶段循环==0:
							轨道连接[对象谱面音轨循环]=轨道时长积累
							物件类型[对象谱面音轨循环]=段落音符类型
							轨道物件长度连接[对象谱面音轨循环]=物件时长存储
							乐谱声音[对象谱面音轨循环]=段落乐谱声音
							#对齐音轨数量，确保每个段落的音轨数量一致
							if 歌曲最大音轨数量>对象谱面文件读取.musics[对象谱面阶段循环].scores.size()&&对象谱面音轨循环==0:
								for 轨道填充循环 in 歌曲最大音轨数量-对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
									轨道连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道连接[0]
									物件类型[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=物件类型[0]
									轨道物件长度连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道物件长度连接[0]
									var 填充空白声音:Array=[]
									for 空白填充 in 乐谱声音[0].size():
										填充空白声音.push_back("空白")
									乐谱声音[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=填充空白声音
						#其他阶段
						else:
							for 轨道连接循环 in 轨道时长积累.size():
								轨道时长积累[轨道连接循环]=轨道连接[对象谱面音轨循环][轨道连接[对象谱面音轨循环].size()-1]+轨道物件长度连接[对象谱面音轨循环][轨道物件长度连接[对象谱面音轨循环].size()-1]+轨道时长积累[轨道连接循环]
							轨道连接[对象谱面音轨循环]=轨道连接[对象谱面音轨循环]+轨道时长积累
							物件类型[对象谱面音轨循环]=物件类型[对象谱面音轨循环]+段落音符类型
							轨道物件长度连接[对象谱面音轨循环]=轨道物件长度连接[对象谱面音轨循环]+物件时长存储
							乐谱声音[对象谱面音轨循环]=乐谱声音[对象谱面音轨循环]+段落乐谱声音
							#对齐音轨数量，确保每个段落的音轨数量一致
							if 歌曲最大音轨数量>对象谱面文件读取.musics[对象谱面阶段循环].scores.size()&&对象谱面音轨循环==0:
								for 轨道填充循环 in 歌曲最大音轨数量-对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
									轨道连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+轨道连接[0]
									物件类型[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=物件类型[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+物件类型[0]
									轨道物件长度连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道物件长度连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+轨道物件长度连接[0]
									var 填充空白声音:Array=[]
									for 空白填充 in 乐谱声音[0].size():
										填充空白声音.push_back("空白")
									乐谱声音[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=乐谱声音[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+填充空白声音
							if 对象谱面阶段循环==对象谱面文件读取.musics.size()-1 && 对象谱面音轨循环==0:
								阶段时间位置.push_back(轨道连接[0][轨道连接[0].size()-1]+轨道物件长度连接[0][轨道物件长度连接[0].size()-1])
						乐器音色[对象谱面阶段循环]=乐器种类
					pass
					$'../加载画面/加载文字/进度条'.value=(20*(对象谱面阶段循环/对象谱面文件读取.musics.size()))+5
				pass
				全局脚本.乐器音色=乐器音色
				全局脚本.物件总时间=轨道连接
				全局脚本.物件时长=轨道物件长度连接
				全局脚本.物件类型=物件类型
				全局脚本.阶段时间位置=阶段时间位置
				全局脚本.对象文件乐谱声音=乐谱声音
				for 子节点循环 in $'../游戏界面/星星皇冠显示'.get_child_count():
					var 子节点 = $'../游戏界面/星星皇冠显示'.get_child(子节点循环)
					子节点.queue_free()
				$'../游戏界面/星星皇冠显示'.size=Vector2(30*对象谱面文件读取.musics.size(),40)
				for 循环 in 对象谱面文件读取.musics.size():
					var 星星贴图=TextureRect.new()
					var 纹理=load("res://纹理/界面/空星.svg")
					星星贴图.set_texture(纹理)
					星星贴图.size=Vector2(30,38)
					星星贴图.position=Vector2(循环*30,0)
					$'../游戏界面/星星皇冠显示'.add_child(星星贴图)
			0:
				if $'/root/根场景/视角节点/MidiPlayer'.smf_data!=全局脚本.数码乐谱文件数据:
					var 每节节拍:int=4
					var 轨道 = $'/root/根场景/视角节点/MidiPlayer'.track_status
					var 物件编号:int=0
					#该变量用于存储当前正在处理的音符对象，用于判定音符的时长
					var 音符事件存储器:Array=[]
					for 事件循环 in 轨道.events.size():
						var 事件块=轨道.events[事件循环]
						var 通道组:Array[Dictionary] = []
						for 循环 in range(16):
							通道组.append({ "通道编号": 循环, "音色库": 0, })
						var 通道编号:int = 事件块.channel_number
						#var 通道 = 通道组[通道编号]
						#var 时间 = 事件块.time
						var 事件 = 事件块.event
						match 事件.type:
							SMF.MIDIEventType.system_event:
								match 事件.args.type:
									#节拍速度
									SMF.MIDISystemEventType.set_tempo:
										pass
									#获取基础节拍
									SMF.MIDISystemEventType.beat:
										每节节拍=事件.args.beat32
									#乐器名称
									SMF.MIDISystemEventType.instrument_name:
										print(事件.args.text)
									#版权
									SMF.MIDISystemEventType.copyright:
										print(事件.args.text)
									#歌曲名称
									SMF.MIDISystemEventType.track_name:
										print(事件.args.text)
									#歌词
									SMF.MIDISystemEventType.lyric:
										print(事件.args.text,"歌词")
										pass
										#self.emit_signal( "appeared_lyric", event.args.text )
									#事件读取器
									SMF.MIDISystemEventType.marker,SMF.MIDISystemEventType.cue_point:
										match 全局脚本.六十四进制转整数(事件.args.text.left(4),5):
											0x0B:
												#添加轨道
												if JSON.parse_string(事件.args.text.lstrip(事件.args.text.left(4)))!=null:
													if JSON.parse_string(事件.args.text.lstrip(事件.args.text.left(4))) is Dictionary:
														var 对象:Dictionary=JSON.parse_string(事件.args.text.lstrip(事件.args.text.left(4)))
														var 类型:int=0
														var 编号:int
														var 欧拉角旋转顺序:int=0
														var 位置=Vector3(0,0,0)
														var 旋转=Vector3(0,0,0)
														var 缩放=Vector3(1,1,1)
														var 物件区:float=-4
														var 允许触碰白块:bool=true
														#编号
														if 对象.has("I"):
															编号=int(对象.I)
														#类型（0为有轨，1为无轨）
														if 对象.has("T"):
															类型=int(对象.T)
														#位置
														if 对象.has("P"):
															if 对象.P is Array:
																if 对象.P.size()==3:
																	位置=Vector3(float(对象.P[0]),float(对象.P[1]),float(对象.P[2]))
														#旋转
														if 对象.has("R"):
															if 对象.R is Array:
																if 对象.R.size()==4:
																	欧拉角旋转顺序=int(对象.R[3])
																	旋转=Vector3(float(对象.R[0]),float(对象.R[1]),float(对象.R[2]))
														#缩放
														if 对象.has("S"):
															if 对象.S is Array:
																if 对象.S.size()==3:
																	缩放=Vector3(float(对象.S[0]),float(对象.S[1]),float(对象.S[2]))
														#触碰白块失误
														if 对象.has("D"):
															允许触碰白块=bool(对象.D)
														var 事件时间:float=0
														for 变速循环 in $"../播放器".数码乐谱变速记录.size():
															if 事件块.time>=$"../播放器".数码乐谱变速记录[变速循环].时刻:
																事件时间=(事件块.time*(float($"../播放器".数码乐谱变速记录[变速循环].速度)/(1000000.0*$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase)))-$"../播放器".数码乐谱变速记录[变速循环].变速差
																pass
														if 对象.has("N"):
															物件区=float(对象.N)
														get_node("/root/根场景/主场景/无轨").添加轨道(false,事件时间,类型,编号,允许触碰白块,位置,旋转,欧拉角旋转顺序,物件区,缩放)
														print(对象)
												pass
											0x08,0x09,0x0A,0x0C,0x0D,0x0E,0x0F:
												#移动轨道，停止轨道，轨道显隐，更改轨道触摸白块行为
												if JSON.parse_string(事件.args.text.lstrip(事件.args.text.left(4)))!=null:
													if JSON.parse_string(事件.args.text.lstrip(事件.args.text.left(4))) is Dictionary:
														var 对象:Dictionary=JSON.parse_string(事件.args.text.lstrip(事件.args.text.left(4)))
														var 事件时间:float=0
														for 变速循环 in $"../播放器".数码乐谱变速记录.size():
															if 事件块.time>=$"../播放器".数码乐谱变速记录[变速循环].时刻:
																事件时间=(事件块.time*(float($"../播放器".数码乐谱变速记录[变速循环].速度)/(1000000.0*$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase)))-$"../播放器".数码乐谱变速记录[变速循环].变速差
																pass
														对象.set("事件时间",事件时间)
														对象.set("事件类型",全局脚本.六十四进制转整数(事件.args.text.left(4),5))
														get_node("/root/根场景/主场景/无轨").事件表.push_back(对象)
												pass
										pass
							SMF.MIDIEventType.note_on:
								var 对象:Dictionary={"音高":事件.note,"时间戳":事件块.time,"物件时间":0}
								for 变速循环 in $"../播放器".数码乐谱变速记录.size():
									if 事件块.time>=$"../播放器".数码乐谱变速记录[变速循环].时刻:
										对象.物件时间=(事件块.time*(float($"../播放器".数码乐谱变速记录[变速循环].速度)/(1000000.0*$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase)))-$"../播放器".数码乐谱变速记录[变速循环].变速差
										pass
								音符事件存储器.push_back(对象)
								pass
							SMF.MIDIEventType.note_off:
								for 循环 in 音符事件存储器.size():
									if 音符事件存储器[循环].音高==事件.note:
										var 对象:Dictionary={"物件编号":物件编号,"轨道编号":0,"物件节点":null,"音高":事件.note}
										if $'/root/根场景/视角节点/MidiPlayer'.smf_data.format_type==0:
											对象.音轨编号=通道编号
										#物件时长变量记录一个音符的持续时间有多少个滴答声(tick)*(8/每节节拍)
										var 物件时长:float=(事件块.time-音符事件存储器[循环].时间戳)*(8.0/每节节拍)
										if 物件时长>=$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase:
											var 物件=长块场景.instantiate()
											物件.get_node("模型/长条尾").position=Vector3(0,((物件时长/$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase))*3-1.5,0)
											物件.get_node("模型/长条腰").scale=Vector3(1,物件时长/$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase,1)
											物件.get_node("模型/长条尾/标签").text="+"+var_to_str(int(物件时长/$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase+1))
											物件.连击加分=int((物件时长/$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase))
											if 物件时长/$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase>1:
												物件.get_node("模型/长条腰").show()
											物件.position[1]=100.0
											物件.音符出现时间=音符事件存储器[循环].物件时间
											for 变速循环 in $"../播放器".数码乐谱变速记录.size():
												if 事件块.time>=$"../播放器".数码乐谱变速记录[变速循环].时刻:
													物件.数码乐谱节拍速度=(60000000.0/float($"../播放器".数码乐谱变速记录[变速循环].速度))
													pass
											物件.数码乐谱基础节拍=(4.0/float(每节节拍))
											物件.物件编号=物件编号
											物件.物件暂存模式=true
											物件.数码乐谱音高=事件.note
											#音符事件存储器[循环].音符长度=物件时长*7.5/每节节拍
											对象.物件节点=物件
										else:
											var 物件=黑块场景.instantiate()
											物件.position[1]=100.0
											物件.音符出现时间=音符事件存储器[循环].物件时间
											for 变速循环 in $"../播放器".数码乐谱变速记录.size():
												if 事件块.time>=$"../播放器".数码乐谱变速记录[变速循环].时刻:
													物件.数码乐谱节拍速度=(60000000.0/float($"../播放器".数码乐谱变速记录[变速循环].速度))
													pass
											物件.数码乐谱基础节拍=(4.0/float(每节节拍))
											物件.物件编号=物件编号
											物件.物件暂存模式=true
											物件.数码乐谱音高=事件.note
											对象.物件节点=物件
											pass
										$"/root/根场景/主场景/无轨".物件编号表.push_back(对象)
										物件编号+=1
										音符事件存储器.remove_at(循环)
										break
								pass
						if 事件循环%50==0:
							await get_tree().create_timer(0.0).timeout
						$'../加载画面/加载文字/进度条'.value=20+(float(事件循环)/轨道.events.size())*80.0
					$"../窗口/调试窗口".show()
				全局脚本.数码乐谱文件数据=$'/root/根场景/视角节点/MidiPlayer'.smf_data
				$'/root/根场景/主场景'.音频延迟=0.0
				$"/root/根场景/主场景".时间跳转(0)
				$"/root/根场景/主场景".数码乐谱播放时间=0
				$"/root/根场景/主场景".数码事件指针=0
				$"/root/根场景/主场景".物件摆放历史=0
				$"/root/根场景/主场景".轨道摆放指针=0
				$"../游戏界面/自动演奏时间轴".max_value=$"../播放器".播放帧转时间($'/root/根场景/视角节点/MidiPlayer'.track_status.events[len($'/root/根场景/视角节点/MidiPlayer'.track_status.events)-1].time)
			2:
				$'/root/根场景/主场景/轨道'.初始化()
		$'../界面动画'.stop()
		$'../界面动画'.play("加载谱面画面关闭")
		if $'../游戏菜单/歌曲信息/歌曲信息/容器/无限模式/选项勾选盒'.button_pressed==true:
			$'../游戏界面/历史成绩/标签/无限'.show()
		else:
			$'../游戏界面/历史成绩/标签/无限'.hide()
		if $'../游戏菜单/歌曲信息/歌曲信息/容器/自动演奏/选项勾选盒'.button_pressed==true:
			$'../游戏界面/历史成绩/标签/自动'.show()
			$'../游戏界面/自动演奏时间轴'.show()
			全局脚本.发送通知("自动演奏已启用","本次游玩将不记录成绩。")
			$"../../主场景".自动模式=true
			$"../游戏界面/游戏界面暂停键/视角控制".show()
		else:
			$"../../主场景".自动模式=false
			$"../游戏界面/游戏界面暂停键/视角控制".hide()
			$'../游戏界面/历史成绩/标签/自动'.hide()
			$'../游戏界面/自动演奏时间轴'.hide()
		全局脚本.游戏开始状态=true
		$'/root/根场景/主场景'.清除物件()
		$"/root/根场景/主场景".开始按钮位置变更()
		$"/root/根场景/视角节点".恢复摄像机状态()
		pass # Replace with function body.
#返回键
func 菜单按钮按下():
	if 竖屏界面布局检测 == true:
		$'界面动画'.play("详细界面缩放")
		竖屏界面布局检测 = false
	else:
		$'../界面动画'.play('返回')
		get_node("/root/根场景/视角节点/三维动画节点").play("返回")
		$"../主菜单/图标/画布/图标".show()
	pass # Replace with function body.
#歌曲搜索
func 歌曲搜索()->void:
	#判断要搜索的地方是内置歌曲还是自定义歌曲
	var 被添加节点:Node=$'界面左列表/表格/容器/旧式谱面列表/列表'
	var 文件路径:String="res://音乐/旧式谱面"
	var 进度条加载:Node=$"界面左列表/表格/容器/加载提示标签"
	$"界面左列表/表格/搜索栏/输入框".editable=false
	$"界面左列表/表格/搜索栏/输入框".placeholder_text="歌曲列表加载状态下不能搜索！"
	$"界面左列表/表格/搜索栏/输入框".tooltip_text="歌曲列表加载状态下不能搜索！"
	$"界面左列表/表格/搜索栏/搜索".disabled=true
	if $'界面左列表/表格/容器'.visible==true:
		被添加节点=$'界面左列表/表格/容器/旧式谱面列表/列表'
		文件路径="res://音乐/旧式谱面"
		进度条加载=$"界面左列表/表格/容器/加载提示标签"
		pass
	#自定义歌曲项
	elif $'界面左列表/表格/自定义'.visible==true:
		被添加节点=$'歌曲信息/底栏/进入选歌列表'.被添加歌曲节点
		文件路径=$'歌曲信息/底栏/进入选歌列表'.文件路径
		进度条加载=$"界面左列表/表格/自定义/下拉框/加载提示标签"
		##判断当前状态下搜索的是封面还是歌曲
		#if $'界面左列表/表格/自定义/下拉框'.visible==false:
			##遍历自定义谱面的分类项
			#for 菜单循环 in $'界面左列表/表格/自定义/歌曲组表格/容器'.get_child_count():
				##遍历分类项内的封面
				#for 菜单封面循环 in $'界面左列表/表格/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child_count():
					#var 子节点 =$'界面左列表/表格/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child(菜单封面循环)
					#var 文字搜索 = 子节点.get_node("标签").text
					#var 文字搜索语言=TranslationServer.translate(文字搜索,"")
		##搜索自定义歌曲
		#else:
			##遍历歌曲列表节点里的所有歌曲分类
			#pass
	if 被添加节点!=null&&文件路径!="":
		if $"界面左列表/表格/搜索栏/输入框".text!="":
			歌曲加载状态=true
			$"界面左列表/表格/容器/翻页栏".自定义歌曲网格节点=self
			#删除歌曲列表
			for 子节点循环 in 被添加节点.get_child_count():
				var 子节点 = 被添加节点.get_child(子节点循环)
				if 子节点.has_node("容器/容器/歌曲名")&&子节点.has_node("容器/容器/艺术家")&&子节点.has_node("容器/卡片头/编号"):
					子节点.queue_free()
			$"界面左列表/表格/容器/翻页栏".hide()
			var 列表文件:Dictionary = JSON.parse_string(FileAccess.open(文件路径+"/歌曲列表.cfg",FileAccess.READ).get_as_text())
			var 搜索结果:Array
			for 循环 in 列表文件.歌曲列表.size():
				var 艺术家语言=TranslationServer.translate(列表文件.歌曲列表[循环].文件,"")
				var 歌曲名称语言=TranslationServer.translate(列表文件.歌曲列表[循环].艺术家,"")
				#找到匹配的歌曲词条
				if 歌曲名称语言.find($"界面左列表/表格/搜索栏/输入框".text) >= 0 ||艺术家语言.find($"界面左列表/表格/搜索栏/输入框".text) >= 0:
					var 歌曲编号:Dictionary={
						"编号"=循环
					}
					列表文件.歌曲列表[循环].merge(歌曲编号)
					搜索结果.push_back(列表文件.歌曲列表[循环])
			进度条加载.show()
			进度条加载.max_value=搜索结果.size()
			for 结果循环 in 搜索结果.size():
				await get_tree().create_timer(0.0).timeout
				进度条加载.get_node("进度").text=var_to_str(结果循环+1)+"/"+var_to_str(搜索结果.size())
				进度条加载.value=结果循环+1
				var 传统歌曲卡片=歌曲卡片场景.instantiate()
				传统歌曲卡片.get_node("容器/容器/歌曲名").text = 搜索结果[结果循环].文件
				传统歌曲卡片.get_node("容器/容器/艺术家").text = 搜索结果[结果循环].艺术家
				传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str(int(搜索结果[结果循环].编号)+1)
				var 准备按钮 = Button.new()
				准备按钮.text = "准备"
				准备按钮.custom_minimum_size=Vector2(100,0)
				if $'界面左列表/表格/容器'.visible==true:
					准备按钮.pressed.connect(歌曲卡片按钮按下.bind(搜索结果[结果循环].文件,搜索结果[结果循环].艺术家,搜索结果[结果循环].竞技场,搜索结果[结果循环].加速度))
				else:
					准备按钮.pressed.connect($"界面左列表/表格/自定义/歌曲组表格".歌曲卡片按钮按下.bind(搜索结果[结果循环].文件,搜索结果[结果循环].艺术家,$'歌曲信息/底栏/进入选歌列表'.文件路径+"/"+搜索结果[结果循环].文件,$'歌曲信息/底栏/进入选歌列表'.歌曲集合名称))
				#设置卡片头纹理
				if 搜索结果[结果循环].卡片头!="":
					var 卡片头纹理路径:String=文件路径+"/卡片头图片/"+搜索结果[结果循环].卡片头+".png"
					if FileAccess.file_exists(卡片头纹理路径)==true:
						var 卡片头纹理=load(卡片头纹理路径)
						传统歌曲卡片.get_node("容器/卡片头").set_texture(卡片头纹理)
				传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
				被添加节点.add_child(传统歌曲卡片)
				传统歌曲卡片.get_node("容器/容器/成绩段位/收藏").pressed.connect(歌曲收藏按钮按下.bind(传统歌曲卡片,准备按钮,搜索结果[结果循环].文件,搜索结果[结果循环].艺术家,搜索结果[结果循环].竞技场,搜索结果[结果循环].加速度))
				pass
			进度条加载.hide()
			歌曲加载状态=false
		else:
			#搜索框为空
			进度条加载.show()
			if 歌曲加载状态==false:
				if $'界面左列表/表格/容器'.visible==true:
					添加指定传统歌曲(1)
				else:
					$"界面左列表/表格/自定义/歌曲组表格/容器/旧式自定义歌曲/容器/网格".添加指定传统歌曲(1,$'歌曲信息/底栏/进入选歌列表'.文件路径,$'歌曲信息/底栏/进入选歌列表'.歌曲集合名称,$'歌曲信息/底栏/进入选歌列表'.被添加歌曲节点)
			pass
	$"界面左列表/表格/搜索栏/输入框".editable=true
	$"界面左列表/表格/搜索栏/输入框".placeholder_text="输入歌曲名以搜索……"
	$"界面左列表/表格/搜索栏/输入框".tooltip_text="输入歌曲名以搜索……"
	$"界面左列表/表格/搜索栏/搜索".disabled=false
	pass # Replace with function body.

func 结算界面():
	$'../界面动画'.play("结算画面")
	$"../结算画面/顶栏/节点/顶栏".text="历史成绩"
	$'../结算画面/左列表/结算/操作区/重试'.hide()
	$'../结算画面/左列表/结算/操作区/回放'.size_flags_horizontal=3
	pass # Replace with function body.

func 恢复搜索状态():
	$界面左列表/表格/容器/旧式谱面列表.hide()
	$界面左列表/表格/容器/数码曲谱列表.hide()
	$界面左列表/表格/容器/传统玩法列表.hide()
	$界面左列表/表格/容器/收藏列表.hide()
	#恢复搜索状态
	for 菜单循环 in $'界面左列表/表格/容器'.get_child_count()-1:
		var 菜单组建路径=$'界面左列表/表格/容器'.get_child(菜单循环+1).get_path()
		if $'界面左列表/表格/容器'.get_child(菜单循环+1).visible==true:
			for 子节点循环 in get_node(菜单组建路径).get_child(0).get_child_count():
				var 子节点 = get_node(菜单组建路径).get_child(0).get_child(子节点循环)
				子节点.visible=true
	#检查歌曲收藏状态
	for 卡片循环 in $'界面左列表/表格/容器/收藏列表/列表'.get_child_count():
		if $'界面左列表/表格/容器/收藏列表/列表'.get_child(卡片循环).get_node('容器/容器/成绩段位/收藏').button_pressed==false:
			for 循环 in $'界面左列表/表格/容器/旧式谱面列表/列表'.get_child_count():
				if $'界面左列表/表格/容器/旧式谱面列表/列表'.get_child(循环).has_node('容器/卡片头/编号'):
					if $'界面左列表/表格/容器/旧式谱面列表/列表'.get_child(循环).get_node('容器/卡片头/编号').text==$'界面左列表/表格/容器/收藏列表/列表'.get_child(卡片循环).get_node('容器/卡片头/编号').text&&$'界面左列表/表格/容器/旧式谱面列表/列表'.get_child(循环).get_node('容器/容器/歌曲名').text==$'界面左列表/表格/容器/收藏列表/列表'.get_child(卡片循环).get_node('容器/容器/歌曲名').text&&$'界面左列表/表格/容器/旧式谱面列表/列表'.get_child(循环).get_node('容器/容器/艺术家').text==$'界面左列表/表格/容器/收藏列表/列表'.get_child(卡片循环).get_node('容器/容器/艺术家').text:
						$'界面左列表/表格/容器/旧式谱面列表/列表'.get_child(循环).get_node('容器/容器/成绩段位/收藏').button_pressed=false
						$'界面左列表/表格/容器/收藏列表/列表'.get_child(卡片循环).queue_free()
	pass # Replace with function body.


func 隐藏分隔线():
	for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
		if $歌曲信息/歌曲信息/容器/隐藏分隔线/选项勾选盒.button_pressed == false:
			get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(子节点循环+1)+"/分隔线").hide()
		else:
			get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(子节点循环+1)+"/分隔线").show()
	pass # Replace with function body.


func 轨道数量滑块(值):
	$'../游戏界面/历史成绩/标签/键数'.text=var_to_str(int(值))+"键"
	$'/root/根场景/主场景'.物件位置占位=[]
	if 值==1.0:
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.disabled=true
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.button_pressed=true
	else:
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.disabled=false
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.button_pressed=false
	for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
		get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(子节点循环+1)).hide()
	for 子节点循环 in 值:
		$'/root/根场景/主场景'.物件位置占位.push_back(0)
		get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(int(子节点循环+1))).show()
	$歌曲信息/歌曲信息/容器/轨道数量/数值.text=var_to_str(int(值))
	if $/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/使用倾斜轨道/选项勾选盒.button_pressed == true:
		$"/root/根场景/视角节点".position[0]=-(4-值)
		$"/root/根场景/视角节点".position[2]=-9+值
		$"/root/根场景/视角节点".position[1]=-4-(值/2)
		pass
	pass # Replace with function body.


func 允许播放乐谱():
	#自适应界面
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor && 界面宽度检测 == true:
		$'界面动画'.play("详细界面扩张")
		竖屏界面布局检测 = true
	var 文件大小=FileAccess.open(数码乐谱文件路径,FileAccess.READ).get_length()
	$'/root/根场景/主场景'.歌曲类型格式=0
	$'/root/根场景/视角节点/MidiPlayer'.stop()
	$'/root/根场景/视角节点/MidiPlayer'.file=数码乐谱文件路径
	$'/root/根场景/视角节点/MidiPlayer'.play()
	功能详细选项变更(true)
	var 文件名称=数码乐谱文件路径.substr(数码乐谱父文件夹路径.split("", false).size(),数码乐谱文件路径.split("", false).size())
	if $'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text=="歌曲选项测试"||$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text=="艺术家测试":
		$'歌曲信息/界面动画'.stop()
		$'歌曲信息/界面动画'.play("文字提示关闭")
	$'../加载画面/封面/边框/容器/下容器/艺术家名称'.text = ""
	$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/容器/艺术家名称'.text = ""
	$'../游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text = ""
	$'../游戏界面/歌曲信息/容器/艺术家'.text=""
	$'../加载画面/封面/边框/容器/上容器/歌曲名称'.text = 文件名称
	$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/歌曲名称'.text =文件名称
	$'../游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text = 文件名称
	$'../游戏界面/歌曲信息/容器/歌曲名'.text=文件名称
	$'歌曲信息/歌曲信息/容器/详细/表格/容器/谱面类型/文字'.text = "多样式正式谱面"
	$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = 全局脚本.存储单位转换(文件大小)
	$"../播放器/播放器窗口/播放器/歌曲名称".text=文件名称
	var 每分钟节拍存储:Array=[]
	var 基础节拍存储:Array=[]
	$"../播放器".数码乐谱变速记录.clear()
	for 事件块 in $'/root/根场景/视角节点/MidiPlayer'.smf_data.tracks[0].events:
		var 通道组:Array[Dictionary] = []
		for 循环 in range(16):
			通道组.append({ "通道编号": 循环, "音色库": 0, })
		#var 通道 = 通道组[通道编号]
		#var 时间 = 事件块.time
		var 事件 = 事件块.event
		match 事件.type:
			#SMF.MIDIEventType.program_change:
				#var 轨道乐器编号:int = 事件.number | ( 通道.音色库 << 7 )
				#print(轨道乐器编号,",",时间,",",通道编号)
			#系统事件
			SMF.MIDIEventType.system_event:
				match 事件.args.type:
					#乐器名称
					#SMF.MIDISystemEventType.instrument_name:
						#print(事件.args.text)
					#版权
					SMF.MIDISystemEventType.copyright:
						$'../加载画面/封面/边框/容器/下容器/艺术家名称'.text = 事件.args.text
						$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/容器/艺术家名称'.text = 事件.args.text
						$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text = 事件.args.text
						$'../游戏界面/歌曲信息/容器/艺术家'.text=事件.args.text
					#歌曲名称
					SMF.MIDISystemEventType.track_name:
						#万国码
						if 事件.args.text.find("�")==-1:
							$'../游戏界面/歌曲信息/容器/歌曲名'.text=事件.args.text
							$'../加载画面/封面/边框/容器/上容器/歌曲名称'.text = 事件.args.text
							$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/歌曲名称'.text =事件.args.text
							$'../游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text = 事件.args.text
							$"../播放器/播放器窗口/播放器/歌曲名称".text=事件.args.text+"("+文件名称+")"
					#歌词
					#SMF.MIDISystemEventType.lyric:
						#print(事件.args.text)
					#获取BPM的值
					SMF.MIDISystemEventType.set_tempo:
						每分钟节拍存储.push_back(60000000.0/float(事件.args.bpm))
						if $"../播放器".数码乐谱变速记录.size()==0:
							$"../播放器".数码乐谱变速记录.push_back({"时刻":事件块.time,"速度":事件.args.bpm,"变速差":0})
						else:
							$"../播放器".数码乐谱变速记录.push_back({"时刻":事件块.time,"速度":事件.args.bpm,"变速差":(事件块.time*(float(事件.args.bpm)/(1000000.0*$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase)))-(事件块.time*(float($"../播放器".数码乐谱变速记录[$"../播放器".数码乐谱变速记录.size()-1].速度)/(1000000.0*$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase)))+$"../播放器".数码乐谱变速记录[$"../播放器".数码乐谱变速记录.size()-1].变速差})
					#获取基础节拍
					SMF.MIDISystemEventType.beat:
						基础节拍存储.push_back(4.0/float(事件.args.beat32))
	if 每分钟节拍存储.size()==1:
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text="%.2f"%每分钟节拍存储[0]
	else:
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text="%.2f~%.2f"%[每分钟节拍存储.min(),每分钟节拍存储.max()]
	if 基础节拍存储.size()==0:
		基础节拍存储.push_back(1)
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text=var_to_str(基础节拍存储[0])
	elif 基础节拍存储.size()==1:
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text=var_to_str(基础节拍存储[0])
	else:
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text=var_to_str(基础节拍存储.min())+"~"+var_to_str(基础节拍存储.max())
	$'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = ("%.3f" %float(每分钟节拍存储.min()/(基础节拍存储.min()*60)))+"~"+("%.3f" %float(每分钟节拍存储.max()/(基础节拍存储.max()*60)))
	$'界面左列表/界面动画'.play("警告窗口关闭")
	if 清空对象池状态==false:
		$'/root/根场景/主场景'.数码文件指针.clear()
		$'/root/根场景/主场景'.数码乐谱音色.clear()
		for 循环 in $'/root/根场景/视角节点/MidiPlayer'.smf_data.tracks.size():
			$'/root/根场景/主场景'.数码文件指针.push_back(0)
		for 循环 in 16:
			$'/root/根场景/主场景'.数码乐谱音色.push_back(0)
		全局脚本.数码乐谱文件数据=null
		清空对象池状态=true
		for 循环 in $"/root/根场景/主场景/无轨".物件编号表.size():
			$"/root/根场景/主场景/无轨".物件编号表[循环].物件节点.销毁物件()
			if 循环%50==0:
				await get_tree().create_timer(0.0).timeout
			$'../加载画面/加载文字/进度条'.value=(float(循环)/$"/root/根场景/主场景/无轨".物件编号表.size())*20.0
		$"/root/根场景/主场景/无轨".事件表.clear()
		$"/root/根场景/主场景/无轨".物件编号表.clear()
		for 循环 in $"/root/根场景/主场景/无轨".轨道编号表.size()-1:
			$"/root/根场景/主场景/无轨".轨道编号表[循环+1].轨道节点.queue_free()
		$"/root/根场景/主场景/无轨".轨道编号表.resize(1)
		清空对象池状态=false
	pass # Replace with function body.
func 取消播放乐谱():
	$'界面左列表/界面动画'.play("警告窗口关闭")
	pass # Replace with function body.
func 旧式歌曲列表() -> void:
	恢复搜索状态()
	$界面左列表/表格/容器/旧式谱面列表.show()
	pass # Replace with function body.
func 正式歌曲列表() -> void:
	恢复搜索状态()
	$界面左列表/表格/容器/数码曲谱列表.show()
	pass # Replace with function body.
func 传统歌曲列表() -> void:
	恢复搜索状态()
	$界面左列表/表格/容器/传统玩法列表.show()
	pass # Replace with function body.
func 收藏歌曲列表() -> void:
	恢复搜索状态()
	$'/root/根场景/视角节点/MidiPlayer'.seek(100000)
	$界面左列表/表格/容器/收藏列表.show()
	pass
