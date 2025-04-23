extends Control
var 游戏暂停设置检测
var 设置数据保存路径=""
# Called when the node enters the scene tree for the first time.
func 保存设置数据(配置文件路径):
	var 设置数据文件=FileAccess.open(配置文件路径, FileAccess.WRITE)
	var 设置数据:Dictionary={
		"界面缩放":界面缩放数据,
		"帧率显示":帧率显示设置数据,
		"屏幕安全区":屏幕安全区数据,
		"语言":语言区域设置数据
	}
	设置数据文件.store_line(JSON.stringify(设置数据))
	设置数据文件.close()
	pass
#以下是默认的设置选项保存变量
var 界面缩放数据=1.0
var 屏幕安全区数据=[0.0,0.0,0.0,0.0]
var 帧率显示设置数据=false
var 语言区域设置数据=OS.get_locale_language()

func 读取设置数据(配置文件路径):
	var 设置数据文件=FileAccess.open(配置文件路径, FileAccess.READ)
	while 设置数据文件.get_position()<设置数据文件.get_length():
		var 设置数据=JSON.parse_string(设置数据文件.get_line())
		#如果json解析失败，便以正确的方式重新保存
		if 设置数据==null:
			保存设置数据(配置文件路径)
			break
		else:
			#如果json的对象不存在，则就以默认数值设置
			if 设置数据["界面缩放"]:
				界面缩放数据=设置数据["界面缩放"]
			else:
				界面缩放数据=1.0
			if 设置数据["帧率显示"]:
				帧率显示设置数据=设置数据["帧率显示"]
			else:
				帧率显示设置数据=false
			if 设置数据["屏幕安全区"]:
				屏幕安全区数据=设置数据["屏幕安全区"]
			else:
				屏幕安全区数据=[0.0,0.0,0.0,0.0]
			if 设置数据["语言"]:
				语言区域设置数据=设置数据["语言"]
			else:
				语言区域设置数据=OS.get_locale_language()
	pass
func 设置应用():
	#帧率显示
	$'../设置/设置选项/视频/视频/界面调整/容器/帧率/勾选盒'.button_pressed = 帧率显示设置数据
	#语言
	TranslationServer.set_locale(语言区域设置数据)
	#屏幕缩放
	get_tree().root.content_scale_factor=界面缩放数据
	$'设置选项/视频/视频/界面调整/容器/缩放/滑块'.value=界面缩放数据
	#屏幕安全区设置
	$'../窗口/界面安全区偏移/表格/水平调整/滑块'.value=屏幕安全区数据[2]
	$'../窗口/界面安全区偏移/表格/垂直调整/滑块'.value=屏幕安全区数据[3]
	$'../窗口/界面安全区偏移/表格/水平缩放/滑块'.value=屏幕安全区数据[0]
	$'../窗口/界面安全区偏移/表格/垂直缩放/滑块'.value=屏幕安全区数据[1]
	pass
func 创建设置数据():
	#调试模式
	if OS.is_debug_build()==true:
		var 目录=DirAccess.open("res://")
		#如果没有该文件夹，则就创建
		if 目录.dir_exists("测试")==false:
			目录.make_dir("测试")
		#如果没有设置配置文件，则就创建
		elif FileAccess.file_exists(设置配置文件)==false:
			FileAccess.open(设置配置文件, FileAccess.WRITE)
		#读取文件
		else:
			读取设置数据(设置配置文件)
	#打包后的正式游戏
	else:
		1
#	if OS.get_name()=="Windows":
#		var 输出数组 = []
#		OS.execute("powershell.exe", ["/C","ls "+设置数据保存路径], 输出数组)
#		print(输出数组)
		#OS.execute("powershell.exe", ["/C", "cd %TEMP% && dir"], 1)
#	else:
#		var 输出数组 = []
#		OS.execute("ls", [设置数据保存路径], 输出数组)
#		print(输出数组)
	print(设置配置文件)
	pass
var 设置配置文件
func _ready():
	游戏暂停设置检测 = $'../游戏界面'
	if OS.is_debug_build()==true:
		设置配置文件="res://测试/设置.cfg"
	else:
		设置配置文件=OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)+"/PianoTiles3D/config/settings.cfg"
	#创建配置文件
	创建设置数据()
	设置应用()
	#浮点数转字符串
	$'设置选项/视频/视频/界面调整/容器/缩放/Label2'.text=var_to_str($'设置选项/视频/视频/界面调整/容器/缩放/滑块'.value)
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		$"设置选项/语言/语言/zh/zh".columns = int(($'/root/根场景/根界面'.size[0]/300)-2)
		if 屏幕宽度检测 == true:
			$'顶栏/顶栏/文字框/文字'.horizontal_alignment=2
			$'顶栏/顶栏/文字框/斜杠'.show()
			$'顶栏/顶栏/文字框/选项文字'.show()
			$'界面动画'.play("界面扩张")
			屏幕宽度检测 = false
		pass
	#帧率显示
	if $'../主菜单'.visible == false && $'../设置/设置选项/视频/视频/界面调整/容器/帧率/勾选盒'.button_pressed == true || self.visible == true && $'../设置/设置选项/视频/视频/界面调整/容器/帧率/勾选盒'.button_pressed == true:
		$'../FPS'.text="帧率 "+var_to_str(Performance.get_monitor(Performance.TIME_FPS));
	else:
		$'../FPS'.text="";
	pass

func 缩放设置滑块拖拽(value):
	$'设置选项/视频/视频/界面调整/容器/缩放/Label2'.text=var_to_str($'设置选项/视频/视频/界面调整/容器/缩放/滑块'.value)
	pass # Replace with function body.
func 缩放设置滑块松开(value_changed):
	#屏幕缩放比例
	get_tree().root.content_scale_factor=$'设置选项/视频/视频/界面调整/容器/缩放/滑块'.value
	界面缩放数据=$'设置选项/视频/视频/界面调整/容器/缩放/滑块'.value
	#get_tree().root.child_controls_changed()
	pass # Replace with function body.

func 安全区设置按钮更改():
	$"界面动画".play("安全区设置打开")
	pass # Replace with function body.

func 安全区设置关闭():
	$"界面动画".play("安全区设置关闭")
	pass # Replace with function body.
func 设置返回():
	保存设置数据(设置配置文件)
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
	#$'设置'.保存
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
	pass # Replace with function body.


func 语言选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="语言"
	$'设置选项/语言'.show()
	pass # Replace with function body.

func 音频选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="音频"
	$'设置选项/音频'.show()
	pass # Replace with function body.
func 外观选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="外观"
	$'设置选项/外观'.show()
	pass # Replace with function body.
func 控制选项():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="控制"
	$'设置选项/控制'.show()
	pass # Replace with function body.
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
	pass # Replace with function body.

func 辅助功能():
	选项打开()
	$'顶栏/顶栏/文字框/选项文字'.text="无障碍"
	$'设置选项/无障碍'.show()
	pass # Replace with function body.
	
func 帧率显示选项():
	if $'../设置/设置选项/视频/视频/界面调整/容器/帧率/勾选盒'.button_pressed == true:
		帧率显示设置数据=true
	else:
		帧率显示设置数据=false
	pass # Replace with function body.


func 总音量调节(value):
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
	$设置选项/音频/音频/音量/容器/总音量/数值.text=var_to_str(value*10)
	pass # Replace with function body.

func 乐器音量调节(value):
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	$设置选项/音频/音频/音量/容器/乐器音效/数值.text=var_to_str(value*10)
	pass # Replace with function body.

func 背景音乐音量(value):
	$'../界面音频/主音频'.volume_db=linear_to_db(value)
	$设置选项/音频/音频/音量/容器/背景音乐音量/数值.text=var_to_str(value*10)
	pass # Replace with function body.
func 窗口无边框():
	if DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)==false:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		$设置选项/视频/视频/界面调整/容器/无边框/勾选盒.button_pressed=true
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		$设置选项/视频/视频/界面调整/容器/无边框/勾选盒.button_pressed=false
	pass # Replace with function body.


func 垂直同步(index):
	match index:
		0:
			DisplayServer.window_set_vsync_mode(0)
		1:
			DisplayServer.window_set_vsync_mode(1)
		2:
			DisplayServer.window_set_vsync_mode(2)
		3:
			DisplayServer.window_set_vsync_mode(3)
	pass # Replace with function body.


func 渲染精度(value):
	$设置选项/视频/视频/画质/容器/渲染精度/数值.text=var_to_str(value)
	get_viewport().set_scaling_3d_scale(value)
	pass # Replace with function body.
func 渲染精度重置():
	$设置选项/视频/视频/画质/容器/渲染精度/滑块.value=1
	$设置选项/视频/视频/画质/容器/渲染精度/数值.text="1.0"
	pass # Replace with function body.
func 窗口模式选项(index):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	pass # Replace with function body.
func 分辨率(index):
	#$设置选项/视频/视频/界面调整/容器/分辨率/选项.get_popup().get_node("@MarginContainer@101/@ScrollContainer@102/@Control@103").add_child(Window.new())
	print(index)
	match index:
		0:
			get_window().set_size(Vector2(800,600))
		1:
			get_window().set_size(Vector2(1024,768))
		2:
			get_window().set_size(Vector2(1280,720))
		3:
			get_window().set_size(Vector2(1366,768))
		4:
			get_window().set_size(Vector2(1440,900))
		5:
			get_window().set_size(Vector2(1600,900))
		6:
			get_window().set_size(Vector2(1920,1080))
		7:
			get_window().set_size(Vector2(2560,1440))
		8:
			get_window().set_size(Vector2(3840,2160))
	pass # Replace with function body.



func 帧率设置(value):
	if value<135.0:
		$'设置选项/视频/视频/画质/容器/帧率设置/数值'.text=var_to_str(int(value))
		Engine.set_max_fps(value)
	else:
		$'设置选项/视频/视频/画质/容器/帧率设置/数值'.text="无限帧"
		Engine.set_max_fps(0)
	pass # Replace with function body.


func 多重采样抗锯齿(index):
	get_viewport().msaa_3d=index
	get_viewport().msaa_2d=index
	pass # Replace with function body.

func 空间抗锯齿():
	if $设置选项/视频/视频/画质/容器/快速近似抗锯齿/选项.button_pressed==true:
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
	else:
		get_viewport().screen_space_aa=Viewport.SCREEN_SPACE_AA_FXAA
	pass # Replace with function body.

func 时间抗锯齿():
	if $设置选项/视频/视频/画质/容器/时间抗锯齿/选项.button_pressed==true:
		get_viewport().use_taa=1
	else:
		get_viewport().use_taa=0
	pass # Replace with function body.
func 文字布局(index):
	$'/root/根场景/根界面'.layout_direction=index+1
	pass # Replace with function body.
