extends Node3D
@export var 移动状态:bool=false
@export var 位移表达式:Array=["0","0","0"]
@export var 旋转表达式:Array=["0","0","0"]
var 静止时刻:float=0.0
var 局部位置:Array=[0.0,0.0,0.0,0.0,0.0,0.0]
var 脚本:Array=[Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new()]
var 状态变更:bool=false
#前进 后退 左移 右移 上升 下降 z轴顺旋 z轴逆旋
var 键盘移动按键:Array=[KEY_W,KEY_S,KEY_A,KEY_D,KEY_SPACE,KEY_SHIFT,KEY_Q,KEY_E]
var 移动状态判定:Array=[false,false,false,false,false,false,false,false]
#上升 下降 z轴顺旋 z轴逆旋
var 手柄按键状态:Array=[false,false,false,false]
var 指针位移差:Vector2=Vector2.ZERO
var 键鼠视角灵敏度:float=0.3
var 手柄视角灵敏度:float=0.3
var 移动速度:float=0.2
var 控制状态:bool=false
#0为键盘鼠标，1为触摸屏，2为手柄
var 控制模式:int=0
var 手柄移动向量:Vector2=Vector2.ZERO
var 手柄视角向量:Vector2=Vector2.ZERO
#自由移动视角
func _input(事件):
	#键盘输入事件
	if 控制状态==true:
		$"摄像机".projection=0
		if 事件 is InputEventKey:
			控制模式=0
			for 循环 in 键盘移动按键.size():
				if 事件.keycode==键盘移动按键[循环]:
					移动状态判定[循环]=事件.pressed
		#鼠标输入事件
		if 事件 is InputEventMouseMotion:
			控制模式=0
			指针位移差=事件.relative*0.1*键鼠视角灵敏度
			pass
		#手柄输入事件
		if 事件 is InputEventJoypadMotion:
			控制模式=2
			match 事件.axis:
				JOY_AXIS_LEFT_X:
					手柄移动向量[0]=事件.get_axis_value()
				JOY_AXIS_LEFT_Y:
					手柄移动向量[1]=事件.get_axis_value()
				JOY_AXIS_RIGHT_X:
					手柄视角向量[0]=事件.get_axis_value()*手柄视角灵敏度
				JOY_AXIS_RIGHT_Y:
					手柄视角向量[1]=事件.get_axis_value()*手柄视角灵敏度
		if 事件 is InputEventJoypadButton:
			控制模式=2
			match 事件.button_index:
				JOY_BUTTON_A:
					手柄按键状态[0]=事件.is_pressed()
				JOY_BUTTON_B:
					手柄按键状态[1]=事件.is_pressed()
				JOY_BUTTON_LEFT_STICK:
					手柄按键状态[2]=事件.is_pressed()
				JOY_BUTTON_RIGHT_STICK:
					手柄按键状态[3]=事件.is_pressed()

func _process(delta):
	if 全局脚本.游戏开始状态==false:
		静止时刻=0
		移动状态=false
	if 全局脚本.游戏开始状态==true&&控制状态==false:
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
			if 状态变更==false:
				状态变更=true
	if 控制状态==true:
		match 控制模式:
			0:
				#视角移动
				self.translate_object_local(Vector3(((移动状态判定[3] as float)-(移动状态判定[2] as float))*移动速度,((移动状态判定[4] as float)-(移动状态判定[5] as float))*移动速度,((移动状态判定[1] as float)-(移动状态判定[0] as float))*移动速度))
				var 视角移动向量:Vector3=Vector3(指针位移差[1],指针位移差[0],(移动状态判定[7] as float)-(移动状态判定[6] as float))
				var 视角旋转四元数:Quaternion = Quaternion()
				var 俯仰角 = Quaternion(Vector3.DOWN, 视角移动向量[1])
				var 偏航角 = Quaternion(Vector3.LEFT, 视角移动向量[0])
				var 滚转角 = Quaternion(Vector3.FORWARD, 视角移动向量[2]*键鼠视角灵敏度*0.1)
				# 更新旋转四元数
				视角旋转四元数 *= 偏航角*滚转角*俯仰角
				# 应用旋转到摄像机
				self.quaternion*=视角旋转四元数
				#self.quaternion.x+=视角移动向量[0]
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				指针位移差=Vector2.ZERO
				$"/root/根场景/根界面/游戏界面/操作提示/表格/左列表".show()
				$"/root/根场景/根界面/游戏界面/操作提示/表格/手柄左列表".hide()
				if $"/root/根场景/根界面/游戏界面/操作提示".visible==false:
					$"/root/根场景/根界面/游戏界面/操作提示/动画".stop()
					$"/root/根场景/根界面/游戏界面/操作提示/动画".play("提示打开")
			1:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				if $"/root/根场景/根界面/游戏界面/操作提示".visible==true&&$"/root/根场景/根界面/游戏界面/操作提示/动画".is_playing()==false:
					$"/root/根场景/根界面/游戏界面/操作提示/动画".stop()
					$"/root/根场景/根界面/游戏界面/操作提示/动画".play("提示关闭")
			2:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				self.translate_object_local(Vector3(手柄移动向量[0]*移动速度,((手柄按键状态[0] as float)-(手柄按键状态[1] as float))*移动速度,手柄移动向量[1]*移动速度))
				var 视角移动向量:Vector3=Vector3(手柄视角向量[1],手柄视角向量[0],(手柄按键状态[2] as float)-(手柄按键状态[3] as float))
				var 视角旋转四元数:Quaternion = Quaternion()
				var 俯仰角 = Quaternion(Vector3.DOWN, 视角移动向量[1])
				var 偏航角 = Quaternion(Vector3.LEFT, 视角移动向量[0])
				var 滚转角 = Quaternion(Vector3.FORWARD, 视角移动向量[2]*手柄视角灵敏度*0.1)
				# 更新旋转四元数
				视角旋转四元数 *= 偏航角*滚转角*俯仰角
				# 应用旋转到摄像机
				self.quaternion*=视角旋转四元数
				$"/root/根场景/根界面/游戏界面/操作提示/表格/左列表".hide()
				$"/root/根场景/根界面/游戏界面/操作提示/表格/手柄左列表".show()
				if $"/root/根场景/根界面/游戏界面/操作提示".visible==false:
					$"/root/根场景/根界面/游戏界面/操作提示/动画".stop()
					$"/root/根场景/根界面/游戏界面/操作提示/动画".play("提示打开")
	else:
		移动状态判定=[false,false,false,false,false,false,false,false]
		手柄按键状态=[false,false,false,false]
		if $"/root/根场景/根界面/游戏界面/操作提示".visible==true&&$"/root/根场景/根界面/游戏界面/操作提示/动画".is_playing()==false:
			$"/root/根场景/根界面/游戏界面/操作提示/动画".stop()
			$"/root/根场景/根界面/游戏界面/操作提示/动画".play("提示关闭")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass
