extends Node3D
var 键盘消除状态:bool=false
@export var 允许失误:bool=true
#这个变量用来存储判定线和分隔线的节点
var 线条节点组:Array=[]
var 轨道编号:int
var 长块触摸位置:float=0.0
#这个变量记录轨道开始运动时的时间
var 静止时刻:float=0.0
var 局部位置:Array=[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
#判定线移动
@export var 移动状态:bool=false
@export var 位移表达式:Array=["0","0","0"]
@export var 旋转表达式:Array=["0","0","0"]
@export var 缩放表达式:Array=["0","0","0"]
var 脚本:Array=[Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new()]
#这个变量用来防止创建脚本的代码每帧都执行
var 状态变更:bool=false
func _ready():
	#把判定线的节点加在数组上面
	线条节点组.push_back(self.get_node("判定线"))
	if has_node("分隔线"):
		线条节点组.push_back(self.get_node("分隔线/左分隔线"))
		线条节点组.push_back(self.get_node("分隔线/右分隔线"))
	pass
#键盘游玩方式
func _input(事件):
	#输入提示
	#键盘鼠标
	if 事件 is InputEventKey|| 事件 is InputEventMouseMotion:
		if has_node("判定线/按键提示"):
			$"判定线/按键提示".show()
			if InputMap.has_action(var_to_str(轨道编号)+"轨道"):
				if InputMap.action_get_events(var_to_str(轨道编号)+"轨道").size()==2:
					$"判定线/按键提示/幕布/标签".text=OS.get_keycode_string(InputMap.action_get_events(var_to_str(轨道编号)+"轨道")[0].keycode)
	#手柄
	elif 事件 is InputEventJoypadMotion||事件 is InputEventJoypadButton:
		if has_node("判定线/按键提示"):
			$"判定线/按键提示".show()
			if InputMap.has_action(var_to_str(轨道编号)+"轨道"):
				if InputMap.action_get_events(var_to_str(轨道编号)+"轨道").size()==2:
					$"判定线/按键提示/幕布/标签".text=$/root/根场景/根界面/设置/设置选项/控制.手柄按键名称(InputMap.action_get_events(var_to_str(轨道编号)+"轨道")[1].button_index)
	#触摸屏
	elif 事件 is InputEventScreenTouch||事件 is InputEventScreenDrag:
		if has_node("判定线/按键提示"):
			$"判定线/按键提示".hide()
	if InputMap.has_action(var_to_str(轨道编号)+"轨道")&&全局脚本.游戏开始状态==true:
		if Input.is_action_pressed(var_to_str(轨道编号)+"轨道",true)==true:
			#print(var_to_str(轨道编号)+"已按下")
			if $'物件区'.get_child_count()!=0:
				for 按键循环 in $'物件区'.get_child_count():
					if $'物件区'.get_child(按键循环).has_node('模型/长条尾')==true:
						#长条按下
						if $'物件区'.get_child(按键循环).长条按下事件==false&&键盘消除状态==false:
							$'物件区'.get_child(按键循环).长条按下事件=true
							长块触摸位置=$'物件区'.get_child(按键循环).position[1]
							$'物件区'.get_child(按键循环).打击判定(false)
							$"/root/根场景/主场景".游戏界面连击数 = $"/root/根场景/主场景".游戏界面连击数 + 1
							get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
						#按下过程状态
						if $'物件区'.get_child(按键循环).长条按下事件==true&&键盘消除状态==false&&全局脚本.游戏开始状态==true&&$'物件区'.get_child(按键循环).音符消除状态==false:
							$'物件区'.get_child(按键循环).长条视觉效果(长块触摸位置)
						break
					else:
						#非长条
						if $'物件区'.get_child(按键循环).音符消除状态==false&&键盘消除状态==false:
							$'物件区'.get_child(按键循环).音符消除()
							键盘消除状态=true
							break
			else:
				失误判定(true)
		else:
			#按键松开
			for 按键循环 in $'物件区'.get_child_count():
				if $'物件区'.get_child(按键循环).has_node('模型/长条尾')==true:
					#长条松开
					if $'物件区'.get_child(按键循环).音符消除状态==false&&全局脚本.游戏开始状态==true&&$'物件区'.get_child(按键循环).长条按下事件==true:
						$'物件区'.get_child(按键循环).长条打击判定(长块触摸位置)
					break
			键盘消除状态=false
func _process(帧处理):
	if 允许失误==true:
		$白块死区.show()
	else:
		$白块死区.hide()
	if 全局脚本.游戏开始状态==false:
		静止时刻=0
		移动状态=false
	if 全局脚本.游戏开始状态==true:
		if 移动状态==false:
			静止时刻=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间
			if 状态变更==true:
				局部位置=[self.position[0],self.position[1],self.position[2],self.rotation[0],self.rotation[1],self.rotation[2],self.scale[0],self.scale[1],self.scale[2]]
				状态变更=false
		elif 移动状态==true:
			var 运动时间=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间-静止时刻
			#位移
			for 循环 in 位移表达式.size():
				#检测表达式变更，以防止代码重复执行
				if 状态变更==false:
					var 公式脚本=GDScript.new()
					#字符串转可执行代码
					公式脚本.set_source_code("extends Object\nfunc 函数(t:float=0):\n\tvar s:float="+var_to_str(局部位置[循环])+"\n\treturn("+位移表达式[循环]+")")
					var 公式错误检测=公式脚本.reload()
					if 公式错误检测==OK:
						#检测是否为空实例
						脚本[循环].set_script(公式脚本)
					else:
						print("错误")
				if 脚本[循环].get_script()!=null:
					self.position[循环]=脚本[循环].函数(运动时间)
				pass
			#旋转
			for 循环 in 旋转表达式.size():
				#检测表达式变更，以防止代码重复执行
				if 状态变更==false:
					var 公式脚本=GDScript.new()
					#字符串转可执行代码
					公式脚本.set_source_code("extends Object\nfunc 函数(t:float=0):\n\tvar s:float="+var_to_str(局部位置[循环+3])+"\n\treturn("+旋转表达式[循环]+")")
					var 公式错误检测=公式脚本.reload()
					if 公式错误检测==OK:
						脚本[循环+3].set_script(公式脚本)
					else:
						print("错误")
				if 脚本[循环+3].get_script()!=null:
					self.rotation[循环]=脚本[循环+3].函数(运动时间)
				pass
			#缩放
			for 循环 in 缩放表达式.size():
				#检测表达式变更，以防止代码重复执行
				if 状态变更==false:
					var 公式脚本=GDScript.new()
					#字符串转可执行代码
					公式脚本.set_source_code("extends Object\nfunc 函数(t:float=0):\n\tvar s:float="+var_to_str(局部位置[循环+6])+"\n\treturn("+缩放表达式[循环]+")")
					var 公式错误检测=公式脚本.reload()
					if 公式错误检测==OK:
						脚本[循环+6].set_script(公式脚本)
					else:
						print("错误")
				if 脚本[循环+6].get_script()!=null:
					self.scale[循环]=脚本[循环+6].函数(运动时间)
				pass
			if 状态变更==false:
				状态变更=true
	pass
func 失误判定(白块区域:bool):
	if $"/root/根场景/主场景".自动模式==false&&全局脚本.游戏开始状态==true:
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
func 白块死区(摄像机节点, 事件, 触摸点位置, 法向量, 形状网格):
	if 事件 is InputEventScreenTouch:
		if 事件.pressed == true && 全局脚本.游戏开始状态==true&&允许失误==true:
			if self.has_node('分隔线')==true:
				$'失误显示'.position = Vector3(0,触摸点位置[1]-2,0)
			else:
				#print(position)
				$'失误显示'.position = Vector3(触摸点位置[0],触摸点位置[1]-2,0)
			失误判定(true)
	pass
