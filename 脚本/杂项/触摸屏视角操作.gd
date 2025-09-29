extends Control
var 触屏摇杆按下=load("res://纹理/界面/触屏摇杆按下.svg")
var 触屏摇杆松开=load("res://纹理/界面/触屏摇杆.svg")
var 摇杆半径:float=80;
var 触屏手指:int=-1
var 视角控制灵敏度:float=0.3
var 使用摇杆状态:bool=false
var 控制输出:Vector2=Vector2(0.0,0.0)
var 触摸位移差:Vector2=Vector2.ZERO
#上升 下降 视角左翻滚 视角右翻滚
var 移动状态判定:Array=[false,false,false,false]
func _ready():
	$'摇杆外圈'.position=Vector2(140,self.size[1]-140)
	$'按键区'.position=self.size-Vector2(70,210)
	$'翻滚按键/左翻滚'.position=Vector2(20,self.size[1]-350)
	$'翻滚按键/右翻滚'.position=self.size-Vector2(70,350)
	pass
func _process(_处理帧):
	$'摇杆外圈'.position=Vector2(140,self.size[1]-140)
	$'按键区'.position=self.size-Vector2(140,210)
	$'翻滚按键/左翻滚'.position=Vector2(20,self.size[1]-350)
	$'翻滚按键/右翻滚'.position=self.size-Vector2(70,350)
	$"../详细信息/游戏界面计时".text="%.3f"%$'/root/根场景/视角节点/背景音乐播放节点'.播放时间
	if $'/root/根场景/视角节点'.控制状态==true:
		$"../调试信息/坐标轴".show()
		$"../调试信息/坐标轴".text="(%.1f"%($'/root/根场景/视角节点'.position[0])+",%.1f"%($'/root/根场景/视角节点'.position[1])+",%.1f)"%($'/root/根场景/视角节点'.position[2])
		$'/root/根场景/视角节点'.translate_object_local(Vector3(控制输出[0]*$'/root/根场景/视角节点'.移动速度,((移动状态判定[0] as float)-(移动状态判定[1] as float))*$'/root/根场景/视角节点'.移动速度,控制输出[1]*$'/root/根场景/视角节点'.移动速度))
		if $'/root/根场景/视角节点'.控制模式==1:
			self.show()
		else:
			self.hide()
	else:
		self.hide()
		$"../调试信息/坐标轴".hide()
	if $'/root/根场景/视角节点'.控制状态==true&&$'/root/根场景/视角节点'.控制模式==1:
		var 视角移动向量:Vector3=Vector3(触摸位移差[1],触摸位移差[0],(移动状态判定[3] as float)-(移动状态判定[2] as float))
		var 视角旋转四元数:Quaternion = Quaternion()
		var 俯仰角 = Quaternion(Vector3.DOWN, 视角移动向量[1])
		var 偏航角 = Quaternion(Vector3.LEFT, 视角移动向量[0])
		var 滚转角 = Quaternion(Vector3.FORWARD, 视角移动向量[2]*视角控制灵敏度*0.1)
		# 更新旋转四元数
		视角旋转四元数 *= 偏航角*滚转角*俯仰角
		# 应用旋转到摄像机
		$'/root/根场景/视角节点'.quaternion*=视角旋转四元数
		触摸位移差=Vector2.ZERO
	pass
func _input(事件):
	if $'/root/根场景/视角节点'.控制状态==true:
		if (事件 is InputEventScreenTouch and 事件.is_pressed())&&$'/root/根场景/视角节点'.控制状态==true:
			#触摸虚拟摇杆事件
			$'/root/根场景/视角节点'.控制模式=1
			var 触屏位置=(事件.position-$'摇杆外圈'.global_position).length()
			#检测摇杆半径位置
			if 触屏位置<=摇杆半径:
				#手指触摸到摇杆区域但第一次按下的情况
				if 使用摇杆状态==false:
					$"摇杆外圈/摇杆".set_global_position(事件.position)
					$"摇杆外圈/摇杆".set_texture(触屏摇杆按下)
					使用摇杆状态=true
					触屏手指=事件.get_index()
		if 事件 is InputEventScreenDrag:
			$'/root/根场景/视角节点'.控制模式=1
			var 触屏位置=(事件.position-$'摇杆外圈'.global_position).length()
			#检测摇杆半径位置
			if 触屏位置<=摇杆半径:
				#防止其他手指干扰摇杆触摸
				if 事件.get_index()==触屏手指:
					$"摇杆外圈/摇杆".set_global_position(事件.position)
					$"摇杆外圈/摇杆".set_texture(触屏摇杆按下)
			#手指滑出摇杆区域外面
			if 触屏位置>摇杆半径&&使用摇杆状态==true&&事件.get_index()==触屏手指:
				var 比例=摇杆半径/((事件.position-$'摇杆外圈'.global_position).length())
				$"摇杆外圈/摇杆".set_position(比例*(事件.position-$'摇杆外圈'.global_position))
		#视角控制代码
		if 事件 is InputEventScreenDrag and 事件.get_index()!=触屏手指 and $'/root/根场景/视角节点'.控制状态==true:
			#if 事件.velocity.length()>200:
				触摸位移差=事件.velocity*0.002*视角控制灵敏度
				#$'/root/根场景/视角节点'.rotation_degrees=Vector3(视角[0]-事件.velocity[1]/视角控制灵敏度,视角[1]-事件.velocity[0]/视角控制灵敏度,视角[2])
			#if get_position_pos()
		#摇杆松开事件
		if 事件 is InputEventScreenTouch and !事件.is_pressed() and 事件.get_index()==触屏手指:
			$"摇杆外圈/摇杆".position=Vector2(0,0)
			$"摇杆外圈/摇杆".set_texture(触屏摇杆松开)
			触屏手指=-1
			使用摇杆状态=false
		控制输出=$"摇杆外圈/摇杆".position/摇杆半径
	pass
func 上升按钮():
	移动状态判定[0]=true
	pass
func 下降按钮():
	移动状态判定[1]=true
	pass
func 下降按钮松开():
	移动状态判定[1]=false
	pass
func 上升按钮松开():
	移动状态判定[0]=false
	pass
func 左翻滚按钮() -> void:
	移动状态判定[2]=true
	pass
func 左翻滚按钮松开() -> void:
	移动状态判定[2]=false
	pass
func 右翻滚按钮() -> void:
	移动状态判定[3]=true
	pass
func 右翻滚按钮松开() -> void:
	移动状态判定[3]=false
	pass
