extends ScrollContainer


var 窗口模式:int=0
var 窗口大小:Vector2=Vector2(1920,1080)
var 窗口边框:bool=false
var 界面缩放数据=1.0
var 上一帧窗口大小:Vector2i
var 自适应缩放数据:bool=true

func _ready() -> void:
	上一帧窗口大小=get_window().get_size()
	pass
	
func _process(_帧处理: float) -> void:
	$界面/界面调整/容器/缩放.visible=!自适应缩放数据
	if 自适应缩放数据:
		if 上一帧窗口大小!=get_window().get_size():
			get_tree().root.content_scale_factor=(get_window().get_size()[0]/400.0) if (get_window().get_size()[0])<(get_window().get_size()[1]) else (get_window().get_size()[1]/600.0)
			上一帧窗口大小=get_window().get_size()
	pass
	
func 读取设置数据(配置文件路径):
	var 设置数据=ConfigFile.new()
	var 读取结果=设置数据.load(配置文件路径)
	if 读取结果==OK:
		if 设置数据.has_section("界面"):
			if 设置数据.has_section_key("界面","窗口模式"):
				窗口模式=设置数据.get_value("界面","窗口模式")
			if 设置数据.has_section_key("界面","窗口边框"):
				窗口边框=设置数据.get_value("界面","窗口边框")
			if 设置数据.has_section_key("界面","界面缩放"):
				界面缩放数据=设置数据.get_value("界面","界面缩放")
			if 设置数据.has_section_key("界面","自适应缩放"):
				自适应缩放数据=设置数据.get_value("界面","自适应缩放")
func 保存设置数据(设置数据):
	设置数据.set_value("界面","界面缩放",界面缩放数据)
	设置数据.set_value("界面","窗口模式",窗口模式)
	设置数据.set_value("界面","窗口边框",窗口边框)
	设置数据.set_value("界面","自适应缩放",自适应缩放数据)
func 设置应用():
	#屏幕缩放
	$'界面/界面调整/容器/缩放/滑块'.value=界面缩放数据
	if !自适应缩放数据:
		get_tree().root.content_scale_factor=界面缩放数据
	else:
		get_tree().root.content_scale_factor=(get_window().get_size()[0]/400.0) if (get_window().get_size()[0])<(get_window().get_size()[1]) else (get_window().get_size()[1]/600.0)
		pass
	$'界面/界面调整/容器/缩放自适应/勾选盒'.button_pressed=自适应缩放数据
	#窗口模式
	DisplayServer.window_set_mode(窗口模式)
	$'界面/界面调整/容器/窗口模式/选项'.selected=窗口模式
	#窗口边框状态
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,窗口边框)
	$界面/界面调整/容器/无边框/勾选盒.button_pressed=窗口边框
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
func 界面自动缩放() -> void:
	if $界面/界面调整/容器/缩放自适应/勾选盒.button_pressed:
		$界面/界面调整/容器/缩放.hide()
		上一帧窗口大小=get_window().get_size()
		get_tree().root.content_scale_factor=(get_window().get_size()[0]/400.0) if (get_window().get_size()[0])<(get_window().get_size()[1]) else (get_window().get_size()[1]/600.0)
	else:
		$界面/界面调整/容器/缩放.show()
		get_tree().root.content_scale_factor=界面缩放数据
	自适应缩放数据=$界面/界面调整/容器/缩放自适应/勾选盒.button_pressed
	pass

func 窗口无边框():
	if DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)==false:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		$界面/界面调整/容器/无边框/勾选盒.button_pressed=true
		窗口边框=true
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		$界面/界面调整/容器/无边框/勾选盒.button_pressed=false
		窗口边框=false
	pass # Replace with function body.

func 文字布局(选项: int) -> void:
	$"../../../".set_layout_direction(选项+1)
	pass # Replace with function body.

func 缩放设置滑块拖拽(_值):
	$'界面/界面调整/容器/缩放/数值'.text=var_to_str($'界面/界面调整/容器/缩放/滑块'.value)
	pass # Replace with function body.
func 缩放设置滑块松开(_值):
	#屏幕缩放比例
	get_tree().root.content_scale_factor=$'界面/界面调整/容器/缩放/滑块'.value
	界面缩放数据=$'界面/界面调整/容器/缩放/滑块'.value
	#get_tree().root.child_controls_changed()
	pass # Replace with function body.
func 分辨率(值):
	match 值:
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
func 安全区设置按钮更改():
	$"../../界面动画".play("安全区设置打开")
	pass
