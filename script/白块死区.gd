extends Node3D
var 键盘按键
var 键盘消除状态:bool=false
var 允许失误:bool=true
#键盘游玩方式
func _input(event):
	if event is InputEventKey && GlobalScript.游戏开始状态==true:
		if Input.is_action_pressed(var_to_str(键盘按键)+"按键")==true:
			if $'物件区'.get_child_count()!=0:
				for 按键循环 in $'物件区'.get_child_count():
					if $'物件区'.get_child(按键循环).音符消除状态==false&&键盘消除状态==false:
						$'物件区'.get_child(按键循环).音符消除()
						键盘消除状态=true
						break
			else:
				失误判定(true)
		else:
			键盘消除状态=false
	pass
func _process(delta):
	if 允许失误==true:
		$白块死区.show()
	else:
		$白块死区.hide()
	pass
func 失误判定(白块区域:bool):
	if $"/root/根场景/主场景".自动模式==false&&GlobalScript.游戏开始状态==true:
		get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
		$"/root/根场景/根界面/游戏界面/判定动画".stop()
		$"/root/根场景/根界面/游戏界面/判定动画".play("失误")
		$"/root/根场景/主场景".丢失生命值()
		#判断失误原因是碰到了白色区域还是打击失误
		if 白块区域==true:
			$'失误显示/动画'.play("失误")
		$"/root/根场景/主场景".游戏界面连击数 = 0
		get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
		$"/root/根场景/主场景".判定统计[5]=$"/root/根场景/主场景".判定统计[5]+1
		$/root/根场景/主场景.精确度判定组.push_back(0)
		$/root/根场景/主场景.精确度判定=0.0
		#统计精确度
		for 循环 in $/root/根场景/主场景.精确度判定组.size():
			$/root/根场景/主场景.精确度判定=$/root/根场景/主场景.精确度判定+($/root/根场景/主场景.精确度判定组[循环]/floor($/root/根场景/主场景.精确度判定组.size()))
		$/root/根场景/根界面/游戏界面/游戏界面精确度.text="%02.2f" %float($/root/根场景/主场景.精确度判定)+"%"
	pass
func 白块死区(camera, event, position, normal, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed == true && GlobalScript.游戏开始状态==true&&允许失误==true:
			if self.has_node('分隔线')==true:
				$'失误显示'.position = Vector3(0,position[1]+4,0)
			else:
				#print(position)
				$'失误显示'.position = Vector3(position[0],position[1]+4,0)
			失误判定(true)
	pass
