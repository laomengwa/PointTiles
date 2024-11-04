extends ScrollContainer

var 帧率显示:bool=false
var 窗口模式:int=0
var 窗口大小:Vector2=Vector2(1920,1080)
var 窗口边框:bool=false
var 界面缩放数据=1.0

var 垂直同步数据:int=0
var 帧率设置数据:int=60
var 采样抗锯齿数据:int=0
var 空间抗锯齿数据:bool=false
var 渲染精度数据:float=1.0

func 读取设置数据(配置文件路径):
	var 设置数据=ConfigFile.new()
	var 读取结果=设置数据.load(配置文件路径)
	if 读取结果==OK:
		if 设置数据.has_section("视频"):
			if 设置数据.has_section_key("视频","窗口模式"):
				窗口模式=设置数据.get_value("视频","窗口模式")
			if 设置数据.has_section_key("视频","窗口边框"):
				窗口边框=设置数据.get_value("视频","窗口边框")
			if 设置数据.has_section_key("视频","垂直同步"):
				垂直同步数据=设置数据.get_value("视频","垂直同步")
			if 设置数据.has_section_key("视频","帧率设置"):
				帧率设置数据=设置数据.get_value("视频","帧率设置")
			if 设置数据.has_section_key("视频","多重采样抗锯齿"):
				采样抗锯齿数据=设置数据.get_value("视频","多重采样抗锯齿")
			if 设置数据.has_section_key("视频","快速近似抗锯齿"):
				空间抗锯齿数据=设置数据.get_value("视频","快速近似抗锯齿")
			if 设置数据.has_section_key("视频","渲染精度"):
				渲染精度数据=设置数据.get_value("视频","渲染精度")
			if 设置数据.has_section_key("视频","界面缩放"):
				界面缩放数据=设置数据.get_value("视频","界面缩放")
func 保存设置数据(设置数据):
	设置数据.set_value("视频","界面缩放",界面缩放数据)
	设置数据.set_value("视频","窗口模式",窗口模式)
	设置数据.set_value("视频","窗口边框",窗口边框)
	设置数据.set_value("视频","垂直同步",垂直同步数据)
	设置数据.set_value("视频","多重采样抗锯齿",采样抗锯齿数据)
	设置数据.set_value("视频","快速近似抗锯齿",空间抗锯齿数据)
	设置数据.set_value("视频","渲染精度",渲染精度数据)
	设置数据.set_value("视频","帧率设置",帧率设置数据)
func 设置应用():
	#屏幕缩放
	get_tree().root.content_scale_factor=界面缩放数据
	$'视频/界面调整/容器/缩放/滑块'.value=界面缩放数据
	#窗口模式
	DisplayServer.window_set_mode(窗口模式)
	$'视频/界面调整/容器/窗口模式/选项'.selected=窗口模式
	#窗口边框状态
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,窗口边框)
	$视频/界面调整/容器/无边框/勾选盒.button_pressed=窗口边框
	#垂直同步状态
	DisplayServer.window_set_vsync_mode(垂直同步数据)
	$'视频/画质/容器/垂直同步/选项'.selected=垂直同步数据
	#帧率限制设置
	Engine.set_max_fps(帧率设置数据)
	$'视频/画质/容器/帧率设置/滑块'.value=帧率设置数据
	#MSAA设置
	get_viewport().msaa_3d=采样抗锯齿数据
	get_viewport().msaa_2d=采样抗锯齿数据
	$'视频/画质/容器/多重采样抗锯齿/选项'.selected=采样抗锯齿数据
	#FXAA设置
	get_viewport().screen_space_aa=空间抗锯齿数据 as int
	$'视频/画质/容器/快速近似抗锯齿/选项'.button_pressed=空间抗锯齿数据
	#渲染精度设置
	get_viewport().set_scaling_3d_scale(渲染精度数据)
	$'视频/画质/容器/渲染精度/滑块'.value=渲染精度数据
	pass
	
func 窗口模式选项(值):
	窗口模式=值
	match 值:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	pass
func 渲染精度(值):
	渲染精度数据=值
	$视频/画质/容器/渲染精度/数值.text=var_to_str(值)
	get_viewport().set_scaling_3d_scale(值)
	pass # Replace with function body.

func 渲染精度重置():
	$视频/画质/容器/渲染精度/滑块.value=1
	$视频/画质/容器/渲染精度/数值.text="1.0"
	pass # Replace with function body.
#游戏引擎未实现TAA，废弃！
func 时间抗锯齿():
	if $视频/画质/容器/时间抗锯齿/选项.button_pressed==true:
		get_viewport().use_taa=1
	else:
		get_viewport().use_taa=0
	pass # Replace with function body.

func 空间抗锯齿():
	if $视频/画质/容器/快速近似抗锯齿/选项.button_pressed==true:
		空间抗锯齿数据=false
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
	else:
		空间抗锯齿数据=true
		get_viewport().screen_space_aa=Viewport.SCREEN_SPACE_AA_FXAA
	pass # Replace with function body.

func 多重采样抗锯齿(值):
	采样抗锯齿数据=值
	get_viewport().msaa_3d=值
	get_viewport().msaa_2d=值
	pass

func 帧率设置(值):
	帧率设置数据=值
	if 值<135.0:
		$'视频/画质/容器/帧率设置/数值'.text=var_to_str(int(值))
		Engine.set_max_fps(值)
	else:
		$'视频/画质/容器/帧率设置/数值'.text="无限帧"
		Engine.set_max_fps(0)
	pass # Replace with function body.


func 垂直同步(值):
	垂直同步数据=值
	match 值:
		0:
			DisplayServer.window_set_vsync_mode(0)
		1:
			DisplayServer.window_set_vsync_mode(1)
		2:
			DisplayServer.window_set_vsync_mode(2)
		3:
			DisplayServer.window_set_vsync_mode(3)
	pass # Replace with function body.


func 窗口无边框():
	if DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)==false:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		$视频/界面调整/容器/无边框/勾选盒.button_pressed=true
		窗口边框=true
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		$视频/界面调整/容器/无边框/勾选盒.button_pressed=false
		窗口边框=false
	pass # Replace with function body.


func 分辨率(index):
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
	pass


func 缩放设置滑块拖拽(value):
	$'视频/界面调整/容器/缩放/数值'.text=var_to_str($'视频/界面调整/容器/缩放/滑块'.value)
	pass # Replace with function body.
func 缩放设置滑块松开(value_changed):
	#屏幕缩放比例
	get_tree().root.content_scale_factor=$'视频/界面调整/容器/缩放/滑块'.value
	界面缩放数据=$'视频/界面调整/容器/缩放/滑块'.value
	#get_tree().root.child_controls_changed()
	pass # Replace with function body.
