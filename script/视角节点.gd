extends Node3D
#前进 后退 左移 右移 上升 下降 z轴顺旋 z轴逆旋
var 键盘移动按键:Array=[KEY_W,KEY_S,KEY_A,KEY_D,KEY_SPACE,KEY_SHIFT,KEY_Q,KEY_E]
var 移动状态判定:Array=[false,false,false,false,false,false,false,false]
#上升 下降 z轴顺旋 z轴逆旋
var 手柄按键状态:Array=[false,false,false,false]
var 指针位移差:Vector2
var 视角灵敏度:float=1.0
var 移动速度:float=0.2
var 控制状态:bool=false
#0为键盘鼠标，1为触摸屏，2为手柄
var 控制模式:int=0
var 手柄移动向量=Vector2(0,0)
var 手柄视角向量=Vector2(0,0)
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
			指针位移差=事件.relative*0.1*视角灵敏度
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
					手柄视角向量[0]=事件.get_axis_value()
				JOY_AXIS_RIGHT_Y:
					手柄视角向量[1]=事件.get_axis_value()
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
			#手柄移动向量=Vector2(0,0)
func _process(delta):
	if 控制状态==true:
		match 控制模式:
			0:
				self.translate_object_local(Vector3(((移动状态判定[3] as float)-(移动状态判定[2] as float))*移动速度,((移动状态判定[4] as float)-(移动状态判定[5] as float))*移动速度,((移动状态判定[1] as float)-(移动状态判定[0] as float))*移动速度))
				#rotate_x(self.rotation_degrees[0]-cos(self.rotation[2])*指针位移差[1]+sin(self.rotation[2])*sin(self.rotation[2])*指针位移差[0])
				#rotate_y(self.rotation_degrees[1]-cos(self.rotation[2])*指针位移差[0]-sin(self.rotation[0])*((移动状态判定[6] as float)-(移动状态判定[7] as float))-sin(self.rotation[2])*指针位移差[1])
				#rotate_z(self.rotation_degrees[2]+cos(self.rotation[0])*((移动状态判定[6] as float)-(移动状态判定[7] as float))+sin(self.rotation[0])*指针位移差[0])
				#self.rotation_degrees=Vector3(左右坐标角度,上下坐标角度,前后坐标角度)
				self.rotate_x((指针位移差[1])*(PI/180))
				self.rotate_y((指针位移差[0])*(PI/180))
				self.rotate_z(((移动状态判定[6] as float)-(移动状态判定[7] as float))*(PI/180))
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				指针位移差=Vector2(0,0)
			1:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			2:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				self.translate_object_local(Vector3(手柄移动向量[0]*移动速度,((手柄按键状态[0] as float)-(手柄按键状态[1] as float))*移动速度,手柄移动向量[1]*移动速度))
				self.rotation_degrees=Vector3(self.rotation_degrees[0]-手柄视角向量[1],self.rotation_degrees[1]-手柄视角向量[0],self.rotation_degrees[2]+((手柄按键状态[2] as float)-(手柄按键状态[3] as float))*视角灵敏度)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass
