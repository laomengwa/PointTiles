extends Node3D
func _process(delta):
	#OS.open_midi_inputs()
	pass
var 按键按下布尔值 = false
var 键盘按键
#键盘游玩方式
func _input(event):
	if event is InputEventKey:
		match event.keycode:
			键盘按键:
				if event.pressed:
					if $'物件区'.get_child_count()!=0:
						$'物件区'.get_child(0).get_node("./模型/触摸区域").音符消除()
					else:
						失误判定()
		pass
	pass
func 失误判定():
	$'失误显示/动画'.play("失误")
	$"/root/根场景/根界面/游戏界面/判定动画".stop()
	$"/root/根场景/根界面/游戏界面/判定动画".play("失误")
	if GlobalScript.游戏界面分数 - 32 > 0:
		GlobalScript.游戏界面分数 = GlobalScript.游戏界面分数 - 32
	else:
		GlobalScript.游戏界面分数 = 0
	GlobalScript.游戏界面连击数 = 0
	get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str(GlobalScript.游戏界面分数)
	get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str(GlobalScript.游戏界面连击数)
	$"/root/根场景/主场景".失误判定=$"/root/根场景/主场景".失误判定+1
	pass
func 白块死区(camera, event, position, normal, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed == true &&	GlobalScript.游戏开始状态==true:
			$'失误显示'.position = Vector3(0,position[1]+4,0)
			失误判定()
	pass
