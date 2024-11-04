extends Control
var 触屏摇杆按下=load("res://texture/gui/触屏摇杆按下.svg")
var 触屏摇杆松开=load("res://texture/gui/触屏摇杆.svg")
var 摇杆半径:float=80;
var 触屏手指:int=-1
var 使用摇杆状态:bool=false
var 控制输出=Vector2(0.0,0.0)
#上升 下降
var 移动状态判定:Array=[false,false]
func _ready():
	$'摇杆外圈'.position=Vector2(140,self.size[1]-140)
	$'按键区'.position=self.size-Vector2(140,210)
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(处理帧):
	$'摇杆外圈'.position=Vector2(140,self.size[1]-140)
	$'按键区'.position=self.size-Vector2(140,210)
	if $'/root/根场景/视角节点'.控制状态==true:
		$'/root/根场景/视角节点'.translate_object_local(Vector3(控制输出[0]*$'/root/根场景/视角节点'.移动速度,((移动状态判定[0] as float)-(移动状态判定[1] as float))*$'/root/根场景/视角节点'.移动速度,控制输出[1]*$'/root/根场景/视角节点'.移动速度))
		if $'/root/根场景/视角节点'.控制模式==1:
			self.show()
		else:
			self.hide()
	else:
		self.hide()
	pass
func _input(事件):
	if $'/root/根场景/视角节点'.控制状态==true:
		if (事件 is InputEventScreenDrag || (事件 is InputEventScreenTouch and 事件.is_pressed()))&&$'/root/根场景/视角节点'.控制状态==true:
			$'/root/根场景/视角节点'.控制模式=1
			var 触屏位置=(事件.position-$'摇杆外圈'.global_position).length()
			#检测摇杆半径位置
			if 触屏位置<=摇杆半径||事件.get_index()==触屏手指:
				触屏手指=事件.get_index()
				$"摇杆外圈/摇杆".position.length()
				$"摇杆外圈/摇杆".set_global_position(事件.position)
				$"摇杆外圈/摇杆".set_texture(触屏摇杆按下)
				使用摇杆状态=true
			if 触屏位置>摇杆半径&&使用摇杆状态==true:
				var 比例=摇杆半径/((事件.position-$'摇杆外圈'.global_position).length())
				$"摇杆外圈/摇杆".set_position(比例*(事件.position-$'摇杆外圈'.global_position))
		if 事件 is InputEventScreenDrag and 事件.get_index()!=触屏手指 and $'/root/根场景/视角节点'.控制状态==true:
			var 视角=$'/root/根场景/视角节点'.rotation_degrees
			if 事件.velocity.length()>200:
				$'/root/根场景/视角节点'.rotation_degrees=Vector3(视角[0]-事件.velocity[1]/1000,视角[1]-事件.velocity[0]/1000,视角[2])
			#if get_position_pos()
		if 事件 is InputEventScreenTouch and !事件.is_pressed():
			$"摇杆外圈/摇杆".position=Vector2(0,0)
			$"摇杆外圈/摇杆".set_texture(触屏摇杆松开)
			触屏手指=-1
			使用摇杆状态=false
		控制输出=$"摇杆外圈/摇杆".position/摇杆半径
	pass
func 上升按钮():
	移动状态判定[0]=true
	pass # Replace with function body.
func 下降按钮():
	移动状态判定[1]=true
	pass # Replace with function body.
func 下降按钮松开():
	移动状态判定[1]=false
	pass # Replace with function bod
func 上升按钮松开():
	移动状态判定[0]=false
	pass # Replace with function body.
