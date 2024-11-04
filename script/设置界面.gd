extends Control
var 游戏暂停设置检测:Node
var 设置配置文件:String
#以下是默认的设置选项保存变量
var 屏幕安全区数据=[0.0,0.0,0.0,0.0]
var 语言区域设置数据=OS.get_locale_language()
#定义节点
var 音频:Node
var 视频:Node
var 控制:Node
var 外观:Node
var 语言:Node
var 关于:Node
var 账户:Node
var 调试:Node
var 无障碍:Node

func _ready():
	音频=$'设置选项/音频'
	视频=$'设置选项/视频'
	控制=$'设置选项/控制'
	外观=$'设置选项/外观'
	语言=$'设置选项/语言'
	关于=$'设置选项/关于'
	账户=$'设置选项/账户'
	调试=$'设置选项/调试'
	无障碍=$'设置选项/无障碍'
	游戏暂停设置检测 = $'../游戏界面'
	#创建配置文件
	if OS.has_feature("template")==false:
		#调试模式
		设置配置文件="res://测试/设置.cfg"
		var 目录=DirAccess.open("res://")
		$'设置选项/调试/调试/其他/容器/存储位置信息/数据'.text=目录.get_current_dir(false)
		#如果没有该文件夹，则就创建
		if 目录.dir_exists("测试")==false:
			目录.make_dir("测试")
		#如果没有设置配置文件，则就创建
		elif FileAccess.file_exists(设置配置文件)==false:
			FileAccess.open(设置配置文件, FileAccess.WRITE)
		#读取文件
		else:
			读取设置数据(设置配置文件)
	else:
		#打包后的正式游戏
		#暂时没有iOS平台的文件路径
		var 目录:DirAccess
		if OS.get_name()!="Android":
			设置配置文件="user://PointTiles/Settings.cfg"
			目录=DirAccess.open("user://")
		else:
			设置配置文件="/storage/self/primary/Android/data/org.mengwa.pointtiles/PointTiles/Settings.cfg"
			目录=DirAccess.open("/storage/self/primary/Android/data/org.mengwa.pointtiles")
		$'设置选项/调试/调试/其他/容器/存储位置信息/数据'.text=目录.get_current_dir(false)
		#如果没有该文件夹，则就创建
		if 目录.dir_exists("PointTiles")==false:
			目录.make_dir("PointTiles")
		#如果没有设置配置文件，则就创建
		elif FileAccess.file_exists(设置配置文件)==false:
			FileAccess.open(设置配置文件, FileAccess.WRITE)
		#读取文件
		else:
			读取设置数据(设置配置文件)
	设置应用()
	音频.设置应用()
	视频.设置应用()
	pass
var 屏幕宽度检测 = false
func _process(delta):
	#UI自适应
	#竖屏
	if $'/root/根场景/根界面'.size[0] <= 600:
		if $'/root/根场景/根界面'.size[0] <= 400:
			$"设置选项/语言/语言/zh/zh".columns = int(1)
		else:
			$"设置选项/语言/语言/zh/zh".columns = int(2)
		pass
		if 屏幕宽度检测 == false:
			$'界面动画'.play("界面缩放")
			$'顶栏/顶栏/文字框/文字'.horizontal_alignment=1
			$'顶栏/顶栏/文字框/斜杠'.hide()
			$'顶栏/顶栏/文字框/选项文字'.hide()
			屏幕宽度检测 = true
			pass
	else:
		#横屏
		#$"设置选项/语言/语言/zh/zh".columns = int(($'/root/根场景/根界面'.size[0]/300)-2)
		if 屏幕宽度检测 == true:
			$'顶栏/顶栏/文字框/文字'.horizontal_alignment=2
			$'顶栏/顶栏/文字框/斜杠'.show()
			$'顶栏/顶栏/文字框/选项文字'.show()
			$'界面动画'.play("界面扩张")
			屏幕宽度检测 = false
		pass

func 保存设置数据(配置文件路径):
	var 设置数据=ConfigFile.new()
	#设置数据.set_value("视频","帧率显示",帧率显示设置数据)
	设置数据.set_value("视频","屏幕安全区",屏幕安全区数据)
	视频.保存设置数据(设置数据)
	音频.保存设置数据(设置数据)
	设置数据.set_value("语言","语言",语言区域设置数据)
	设置数据.save(配置文件路径)
	#var 设置数据文件=FileAccess.open(配置文件路径, FileAccess.WRITE)
	#var 设置数据:Dictionary={
		#"界面缩放":界面缩放数据,
		#"帧率显示":帧率显示设置数据,
		#"屏幕安全区":屏幕安全区数据,
		#"语言":语言区域设置数据
	#}
	#设置数据文件.store_line(JSON.stringify(设置数据))
	#设置数据文件.close()
	pass

func 读取设置数据(配置文件路径):
	var 设置数据=ConfigFile.new()
	var 读取结果=设置数据.load(配置文件路径)
	视频.读取设置数据(配置文件路径)
	音频.读取设置数据(配置文件路径)
	if 读取结果==OK:
		屏幕安全区数据=设置数据.get_value("视频","屏幕安全区")
		语言区域设置数据=设置数据.get_value("语言","语言")
	pass
func 设置应用():
	#帧率显示
	#$'../设置/设置选项/视频/视频/界面调整/容器/帧率/勾选盒'.button_pressed = 帧率显示设置数据
	#语言
	TranslationServer.set_locale(语言区域设置数据)
	#屏幕安全区设置
	$'../窗口/界面安全区偏移/表格/水平调整/滑块'.value=屏幕安全区数据[2]
	$'../窗口/界面安全区偏移/表格/垂直调整/滑块'.value=屏幕安全区数据[3]
	$'../窗口/界面安全区偏移/表格/水平缩放/滑块'.value=屏幕安全区数据[0]
	$'../窗口/界面安全区偏移/表格/垂直缩放/滑块'.value=屏幕安全区数据[1]
	pass

func 安全区设置按钮更改():
	$"界面动画".play("安全区设置打开")
	pass

func 安全区设置关闭():
	$"界面动画".play("安全区设置关闭")
	pass
func 设置返回():
	保存设置数据(设置配置文件)
	if $'界面动画'.is_playing()==false:
		$'顶栏/顶栏/文字框/文字'.horizontal_alignment=1
		$'顶栏/顶栏/文字框/斜杠'.hide()
		$'顶栏/顶栏/文字框/选项文字'.hide()
		if 屏幕宽度检测==true && $设置选项按钮.visible==false:
			$'界面动画'.play("界面缩放")
		else:
			$'界面动画'.play('设置界面关闭')
			if 游戏暂停设置检测.游戏暂停设置窗口==true&&$'../结算画面'.visible==false:
				$'../游戏界面/界面动画'.play("暂停窗口")
				$顶栏/顶栏/状态.text=""
				游戏暂停设置检测.游戏暂停设置窗口=false
	pass
func 选项打开():
	$'顶栏/顶栏/文字框/文字'.horizontal_alignment=2
	$'顶栏/顶栏/文字框/斜杠'.show()
	$'顶栏/顶栏/文字框/选项文字'.show()
	if 屏幕宽度检测==true:
		$'界面动画'.play("选项扩张")
	for 子节点循环 in $'设置选项'.get_child_count():
		var 子节点 = $'设置选项'.get_child(子节点循环)
		子节点.hide()
	pass

func 视频选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="视频"
	$'设置选项/视频'.show()
	pass


func 语言选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="语言"
	$'设置选项/语言'.show()
	pass

func 音频选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="音频"
	$'设置选项/音频'.show()
	pass
func 外观选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="外观"
	$'设置选项/外观'.show()
	pass
func 控制选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="控制"
	$'设置选项/控制'.show()
	pass
func 账户选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="账户"
	$'设置选项/账户'.show()
func 调试选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="调试"
	$'设置选项/调试'.show()
func 关于选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="关于"
	$'设置选项/关于'.show()
	pass

func 辅助功能():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="无障碍"
	$'设置选项/无障碍'.show()
	pass

func 总音量调节(value):
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
	$设置选项/音频/音频/音量/容器/总音量/数值.text=var_to_str(value*10)
	pass

#若如果想分支这个项目，请保留作者的信息，谢谢！
#github：https://github.com/laomengwa
#bilibili账户：https://space.bilibili.com/46345895
#acfun账户：https://www.acfun.cn/u/27737336
func 作者标识():
	OS.shell_open("https://space.bilibili.com/46345895")
	pass
