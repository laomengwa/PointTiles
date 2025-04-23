extends ScrollContainer
var 通知节点=preload("res://场景/通知卡片.tscn")
var 有轨键盘按键布局:Dictionary={
	1:[KEY_SPACE],
	2:[KEY_F,KEY_J],
	3:[KEY_F,KEY_SPACE,KEY_J],
	4:[KEY_D,KEY_F,KEY_J,KEY_K],
	5:[KEY_D,KEY_F,KEY_SPACE,KEY_J,KEY_K],
	6:[KEY_S,KEY_D,KEY_F,KEY_J,KEY_K,KEY_L],
	7:[KEY_S,KEY_D,KEY_F,KEY_SPACE,KEY_J,KEY_K,KEY_L],
	8:[KEY_A,KEY_S,KEY_D,KEY_F,KEY_J,KEY_K,KEY_L,KEY_SEMICOLON],
	9:[KEY_A,KEY_S,KEY_D,KEY_F,KEY_SPACE,KEY_J,KEY_K,KEY_L,KEY_SEMICOLON],
	10:[KEY_A,KEY_S,KEY_D,KEY_F,KEY_SPACE,KEY_ALT,KEY_L,KEY_SEMICOLON,KEY_APOSTROPHE,KEY_ENTER]
	}
var 有轨手柄按键布局:Dictionary={
	1:[JOY_BUTTON_Y],
	2:[JOY_BUTTON_X,JOY_BUTTON_B],
	3:[JOY_BUTTON_X,JOY_BUTTON_Y,JOY_BUTTON_B],
	4:[JOY_BUTTON_X,JOY_BUTTON_A,JOY_BUTTON_Y,JOY_BUTTON_B],
	5:[JOY_BUTTON_DPAD_LEFT,JOY_BUTTON_DPAD_RIGHT,JOY_BUTTON_X,JOY_BUTTON_Y,JOY_BUTTON_B],
	6:[JOY_BUTTON_DPAD_LEFT,JOY_BUTTON_DPAD_UP,JOY_BUTTON_DPAD_RIGHT,JOY_BUTTON_X,JOY_BUTTON_Y,JOY_BUTTON_B],
	7:[JOY_BUTTON_DPAD_LEFT,JOY_BUTTON_DPAD_UP,JOY_BUTTON_DPAD_RIGHT,JOY_BUTTON_X,JOY_BUTTON_A,JOY_BUTTON_Y,JOY_BUTTON_B],
	8:[JOY_BUTTON_DPAD_LEFT,JOY_BUTTON_DPAD_DOWN,JOY_BUTTON_DPAD_UP,JOY_BUTTON_DPAD_RIGHT,JOY_BUTTON_X,JOY_BUTTON_A,JOY_BUTTON_Y,JOY_BUTTON_B],
	9:[JOY_BUTTON_DPAD_LEFT,JOY_BUTTON_DPAD_DOWN,JOY_BUTTON_DPAD_UP,JOY_BUTTON_DPAD_RIGHT,JOY_BUTTON_X,JOY_BUTTON_A,JOY_BUTTON_Y,JOY_BUTTON_B,JOY_BUTTON_RIGHT_SHOULDER],
	10:[JOY_BUTTON_LEFT_SHOULDER,JOY_BUTTON_DPAD_LEFT,JOY_BUTTON_DPAD_DOWN,JOY_BUTTON_DPAD_UP,JOY_BUTTON_DPAD_RIGHT,JOY_BUTTON_X,JOY_BUTTON_A,JOY_BUTTON_Y,JOY_BUTTON_B,JOY_BUTTON_RIGHT_SHOULDER]
}
var 键位设置状态:bool=false
var 键位设置参数:Dictionary={
	"设备":0,
	"选项":0,
	"节点":Node.new()
}
func _ready():
	for 循环 in 10:
		InputMap.add_action(var_to_str(循环+1)+"轨道")
	var 编号=$控制/键盘鼠标/容器/按键布局设置展开/设置下拉项.selected
	键盘下拉项(编号)
	编号=$控制/手柄/容器/键位布局/设置下拉项.selected
	手柄下拉项(编号)
	for 循环 in 编号+1:
		$'控制/手柄/容器/按键布局/容器'.get_child(循环+1).show()
		$'控制/手柄/容器/按键布局/容器'.get_child(循环+1).get_node("确定").text=手柄按键名称(有轨手柄按键布局.get(编号+1)[循环])
	手柄按键标签(有轨手柄按键布局.get(编号+1))
	pass # Replace with function body.
func _input(事件):
	if 键位设置状态==true:
		if 键位设置参数.设备==0:
			if 事件 is InputEventKey:
				var 设置项=$'控制/键盘鼠标/容器/按键布局设置展开/设置下拉项'.selected+1
				var 键位冲突检测:bool=false
				for 循环 in 有轨键盘按键布局.get(设置项).size():
					if 事件.keycode==有轨键盘按键布局.get(设置项)[循环]:
						键位冲突检测=true
						break
				if 键位冲突检测==false:
					有轨键盘按键布局.get(设置项)[键位设置参数.选项]=事件.keycode
					键位设置参数.节点.text=OS.get_keycode_string(事件.keycode)
					键位设置状态=false
				else:
					键位设置参数.节点.text="键位冲突"
					键位设置状态=false
					var 通知=通知节点.instantiate()
					通知.get_node("控件/标题").text="键位冲突"
					通知.get_node("控件/内容").text="请重新设置你的键位"
					$'/root/根场景/根界面/通知栏'.add_child(通知)
				pass
		elif 键位设置参数.设备==1:
			if 事件 is InputEventJoypadButton:
				有轨手柄按键布局.get($'控制/手柄/容器/键位布局/设置下拉项'.selected+1)[键位设置参数.选项]=事件.button_index
				键位设置参数.节点.text=手柄按键名称(事件.button_index)
				键位设置状态=false
				pass
	pass
func 判定偏移(value):
	全局脚本.判定偏移=value
	$'/root/根场景/根界面/设置/设置选项/控制/控制/其他/容器/判定偏移/数值'.text=var_to_str(int(value*1000))+"毫秒"
	pass
func 手柄下拉项(编号):
	for 循环 in $'控制/手柄/容器/按键布局/容器'.get_child_count()-1:
		$'控制/手柄/容器/按键布局/容器'.get_child(循环+1).hide()
	for 循环 in 编号+1:
		$'控制/手柄/容器/按键布局/容器'.get_child(循环+1).show()
		$'控制/手柄/容器/按键布局/容器'.get_child(循环+1).get_node("确定").text=手柄按键名称(有轨手柄按键布局.get(编号+1)[循环])
		$'控制/手柄/容器/按键布局/容器'.get_child(循环+1).get_node("确定").pressed.connect(轨道键位监听.bind(1,循环,$'控制/手柄/容器/按键布局/容器'.get_child(循环+1).get_node("确定")))
	手柄按键标签(有轨手柄按键布局.get(编号+1))
	pass
func 键盘下拉项(编号):
	for 循环 in $'控制/键盘鼠标/容器/按键布局/容器'.get_child_count()-1:
		$'控制/键盘鼠标/容器/按键布局/容器'.get_child(循环+1).hide()
	for 循环 in 编号+1:
		$'控制/键盘鼠标/容器/按键布局/容器'.get_child(循环+1).show()
		$'控制/键盘鼠标/容器/按键布局/容器'.get_child(循环+1).get_node("确定").text=OS.get_keycode_string(有轨键盘按键布局.get(编号+1)[循环])
		$'控制/键盘鼠标/容器/按键布局/容器'.get_child(循环+1).get_node("确定").pressed.connect(轨道键位监听.bind(0,循环,$'控制/键盘鼠标/容器/按键布局/容器'.get_child(循环+1).get_node("确定")))
	pass

func 手柄按键名称(键值)->String:
	var 按键名称:String
	match 键值:
		#● JOY_BUTTON_A = 0
		#游戏控制器 SDL 按键 A。对应底部动作按钮：Sony Cross、Xbox A、Nintendo B。
		0:
			match $'控制/手柄/容器/手柄种类/设置下拉项'.selected:
				0:
					按键名称="A"
				1:
					按键名称="×"
				2:
					按键名称="B"
		#● JOY_BUTTON_B = 1
		#游戏控制器 SDL 按钮 B。对应右侧动作按钮：Sony Circle、Xbox B、Nintendo A。
		1:
			match $'控制/手柄/容器/手柄种类/设置下拉项'.selected:
				0:
					按键名称="B"
				1:
					按键名称="○"
				2:
					按键名称="A"
		#● JOY_BUTTON_X = 2
		#游戏控制器 SDL 按钮 X。对应左侧动作按钮：Sony Square、Xbox X、Nintendo Y。
		2:
			match $'控制/手柄/容器/手柄种类/设置下拉项'.selected:
				0:
					按键名称="X"
				1:
					按键名称="□"
				2:
					按键名称="Y"
		#● JOY_BUTTON_Y = 3
		#游戏控制器 SDL 按钮 Y。对应顶部动作按钮：Sony Triangle、Xbox Y、Nintendo X。
		3:
			match $'控制/手柄/容器/手柄种类/设置下拉项'.selected:
				0:
					按键名称="Y"
				1:
					按键名称="△"
				2:
					按键名称="X"
		#● JOY_BUTTON_BACK = 4
		#游戏控制器 SDL back 按钮。对应于 Sony Select、Xbox Back、Nintendo - 按钮。
		4:
			按键名称="返回键"
		#● JOY_BUTTON_GUIDE = 5
		#游戏控制器 SDL guide 按钮。对应于索尼 PS、Xbox 的 Home 键。
		5:
			按键名称="主页键"
		#● JOY_BUTTON_START = 6
		#游戏控制器 SDL start 按钮。对应于 Sony Options、Xbox Menu、Nintendo + 按钮。
		6:
			按键名称="开始键"
		#● JOY_BUTTON_LEFT_STICK = 7
		#游戏控制器 SDL 左摇杆按钮。对应于 Sony L3、Xbox L/LS 按钮。
		7:
			match $'控制/手柄/容器/手柄种类/设置下拉项'.selected:
				0,2:
					按键名称="LS"
				1:
					按键名称="L3"
		#● JOY_BUTTON_RIGHT_STICK = 8
		#游戏控制器 SDL 右摇杆按钮。对应于 Sony R3、Xbox R/RS 按钮。
		8:
			match $'控制/手柄/容器/手柄种类/设置下拉项'.selected:
				0,2:
					按键名称="RS"
				1:
					按键名称="R3"
		#● JOY_BUTTON_LEFT_SHOULDER = 9
		#游戏控制器 SDL 左肩按钮。对应于 Sony L1、Xbox LB 按钮。
		9:
			match $'控制/手柄/容器/手柄种类/设置下拉项'.selected:
				0,2:
					按键名称="LB"
				1:
					按键名称="L1"
		#● JOY_BUTTON_RIGHT_SHOULDER = 10
		#游戏控制器 SDL 右肩按钮。对应于 Sony R1、Xbox RB 按钮。
		10:
			match $'控制/手柄/容器/手柄种类/设置下拉项'.selected:
				0,2:
					按键名称="RB"
				1:
					按键名称="R1"
		#● JOY_BUTTON_DPAD_UP = 11
		#游戏控制器方向键向上按钮。
		11:
			按键名称="上键"
		#● JOY_BUTTON_DPAD_DOWN = 12
		#游戏控制器方向键向下按钮。
		12:
			按键名称="下键"
		#● JOY_BUTTON_DPAD_LEFT = 13
		#游戏控制器方向键向左键。
		13:
			按键名称="左键"
		#● JOY_BUTTON_DPAD_RIGHT = 14
		#游戏控制器方向键向右键。
		14:
			按键名称="右键"
		#● JOY_BUTTON_MISC1 = 15
		#游戏控制器 SDL 杂项按钮。对应 Xbox 分享键、PS5 麦克风键、Nintendo Switch 捕捉键。
		15:
			match $'控制/手柄/容器/手柄种类/设置下拉项'.selected:
				0:
					按键名称="分享键"
				1:
					按键名称="话筒键"
				2:
					按键名称="捕捉键"
		#● JOY_BUTTON_PADDLE1 = 16
		#游戏控制器 SDL 拨片 1 按钮。
		16:
			按键名称="拨片1"
		#● JOY_BUTTON_PADDLE2 = 17
		#游戏控制器 SDL 拨片 2 按钮。
		17:
			按键名称="拨片2"
		#● JOY_BUTTON_PADDLE3 = 18
		#游戏控制器 SDL 拨片 3 按钮。
		18:
			按键名称="拨片3"
		#● JOY_BUTTON_PADDLE4 = 19
		#游戏控制器 SDL 拨片 4 按钮。
		19:
			按键名称="拨片4"
		#● JOY_BUTTON_TOUCHPAD = 20
		#游戏控制器 SDL 触摸板按钮。
		20:
			按键名称="触摸板"
		_:
			按键名称="未知"
	return 按键名称
func 手柄按键标签(键位):
	#隐藏所有标签
	var 手柄模型节点=$'控制/手柄/容器/预览项/容器/手柄布局/画布/节点/手柄模型'
	for 循环 in 手柄模型节点.get_child_count():
		手柄模型节点.get_child(循环).hide()
	for 循环 in 键位.size():
		match 键位[循环]:
			0:
				手柄模型节点.get_node("绿键").show()
				手柄模型节点.get_node("绿键").text=var_to_str(循环+1)
			1:
				手柄模型节点.get_node("红键").show()
				手柄模型节点.get_node("红键").text=var_to_str(循环+1)
			2:
				手柄模型节点.get_node("蓝键").show()
				手柄模型节点.get_node("蓝键").text=var_to_str(循环+1)
			3:
				手柄模型节点.get_node("橙键").show()
				手柄模型节点.get_node("橙键").text=var_to_str(循环+1)
			7:
				手柄模型节点.get_node("左摇杆内键").show()
				手柄模型节点.get_node("左摇杆内键").text=var_to_str(循环+1)
			8:
				手柄模型节点.get_node("右摇杆内键").show()
				手柄模型节点.get_node("右摇杆内键").text=var_to_str(循环+1)
			9:
				手柄模型节点.get_node("左肩键").show()
				手柄模型节点.get_node("左肩键").text=var_to_str(循环+1)
			10:
				手柄模型节点.get_node("右肩键").show()
				手柄模型节点.get_node("右肩键").text=var_to_str(循环+1)
			11:
				手柄模型节点.get_node("上键").show()
				手柄模型节点.get_node("上键").text=var_to_str(循环+1)
			12:
				手柄模型节点.get_node("下键").show()
				手柄模型节点.get_node("下键").text=var_to_str(循环+1)
			13:
				手柄模型节点.get_node("左键").show()
				手柄模型节点.get_node("左键").text=var_to_str(循环+1)
			14:
				手柄模型节点.get_node("右键").show()
				手柄模型节点.get_node("右键").text=var_to_str(循环+1)
		pass
	pass
func 轨道键位监听(设备类型,设置项,按钮节点):
	键位设置参数.设备=设备类型
	键位设置参数.选项=设置项
	键位设置参数.节点=按钮节点
	按钮节点.text="正在监听"
	键位设置状态=true
	pass
func 手柄种类选择(编号):
	手柄下拉项($控制/手柄/容器/键位布局/设置下拉项.selected)
	pass
