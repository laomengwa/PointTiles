extends Node3D
#控制游戏行为的接口
@onready var 有轨轨道场景 = preload("res://场景/音符/有轨轨道.tscn")
@onready var 无轨轨道场景 = preload("res://场景/音符/无轨轨道.tscn")
@onready var 黑块场景 = preload("res://场景/音符/黑块.tscn")
@onready var 长块场景 = preload("res://场景/音符/长块.tscn")
@onready var 叠块场景 = preload("res://场景/音符/狂戳.tscn")
@onready var 滑条场景 = preload("res://场景/音符/滑块.tscn")
@onready var 六角块场景 = preload("res://场景/音符/爆裂.tscn")
@onready var 绿键场景 = preload("res://场景/音符/绿键.tscn")
@onready var 滑键场景 = preload("res://场景/音符/滑键.tscn")
@onready var 圆球场景 = preload("res://场景/音符/旋转.tscn")
@onready var 弯曲滑条场景 = preload("res://场景/音符/弯曲滑块.tscn")
var 轨道编号表:Array=[]
var 物件编号表:Array=[]
var 事件表:Array=[]
func _ready() -> void:
	var 轨道=无轨轨道场景.instantiate()
	轨道.name="轨道0"
	轨道.轨道编号=0
	self.add_child(轨道)
	轨道编号表=[{"轨道编号":0,"轨道节点":轨道,"出现时间":0.0}]
	pass
func 恢复初始状态()->void:
	_ready()
	物件编号表=[]
	事件表=[]
	pass

#0x09
func 摄像机移动(位移表达式:Array=["0","0","0"],旋转表达式:Array=["0","0","0"],欧拉角旋转顺序:float=1,投影模式:int=0,视距表达式:Array=["s","s","s"],长宽比:int=1,视口偏移表达式:Array=["s","s","s","s"])->int:
	var 状态:int=OK
	$/root/根场景/视角节点.移动状态=true
	$/root/根场景/视角节点.状态变更=false
	$/root/根场景/视角节点/摄像机.keep_aspect=长宽比
	$/root/根场景/视角节点/摄像机.projection=投影模式
	if int(欧拉角旋转顺序)==0:
		$/root/根场景/视角节点.四元数旋转状态=true
	else:
		$/root/根场景/视角节点.四元数旋转状态=false
	#未来添加语句检测，防止恶意代码注入以及语法错误的表达式
	$/root/根场景/视角节点.位移表达式=位移表达式
	$/root/根场景/视角节点.旋转表达式=旋转表达式
	$/root/根场景/视角节点.视距变更表达式=视距表达式
	$/root/根场景/视角节点.视角偏移表达式=视口偏移表达式
	$/root/根场景/视角节点.rotation_order=int(欧拉角旋转顺序-1)
	return 状态
#0x08
func 摄像机停止移动(位移:Array=["0","0","0"],旋转:Array=["0","0","0"],欧拉角旋转顺序:float=1,投影模式:int=0,视距:Array=["s","s","s"],保持长宽比:int=1,视口偏移:Array=["s","s","s","s"])->int:
	var 状态:int=OK
	if int(欧拉角旋转顺序)!=0:
		$/root/根场景/视角节点.rotation_order=int(欧拉角旋转顺序-1)
	$/root/根场景/视角节点.移动状态=false
	$/root/根场景/视角节点/摄像机.keep_aspect=保持长宽比
	$/root/根场景/视角节点/摄像机.projection=投影模式
	if int(欧拉角旋转顺序)==0:
		$/root/根场景/视角节点.四元数旋转状态=true
	else:
		$/root/根场景/视角节点.四元数旋转状态=false
	#位置x,位置y,位置z,旋转x,旋转y,旋转z,视野,近视,远视,视角偏移x,视角偏移y,视锥偏移x,视锥偏移y
	if int(欧拉角旋转顺序)!=0:
		if 投影模式==0:
			$/root/根场景/视角节点.局部位置=[$/root/根场景/视角节点.position[0],$/root/根场景/视角节点.position[1],$/root/根场景/视角节点.position[2],$/root/根场景/视角节点.rotation[0],$/root/根场景/视角节点.rotation[1],$/root/根场景/视角节点.rotation[2],$/root/根场景/视角节点/摄像机.fov,$/root/根场景/视角节点/摄像机.near,$/root/根场景/视角节点/摄像机.far,$/root/根场景/视角节点/摄像机.h_offset,$/root/根场景/视角节点/摄像机.v_offset,$/root/根场景/视角节点/摄像机.frustum_offset[0],$/root/根场景/视角节点/摄像机.frustum_offset[1]]
		else:
			$/root/根场景/视角节点.局部位置=[$/root/根场景/视角节点.position[0],$/root/根场景/视角节点.position[1],$/root/根场景/视角节点.position[2],$/root/根场景/视角节点.rotation[0],$/root/根场景/视角节点.rotation[1],$/root/根场景/视角节点.rotation[2],$/root/根场景/视角节点/摄像机.size,$/root/根场景/视角节点/摄像机.near,$/root/根场景/视角节点/摄像机.far,$/root/根场景/视角节点/摄像机.h_offset,$/root/根场景/视角节点/摄像机.v_offset,$/root/根场景/视角节点/摄像机.frustum_offset[0],$/root/根场景/视角节点/摄像机.frustum_offset[1]]
	else:
		if 投影模式==0:
			$/root/根场景/视角节点.局部位置=[$/root/根场景/视角节点.position[0],$/root/根场景/视角节点.position[1],$/root/根场景/视角节点.position[2],$/root/根场景/视角节点.quaternion.x,$/root/根场景/视角节点.quaternion.y,$/root/根场景/视角节点.quaternion.z,$/root/根场景/视角节点/摄像机.fov,$/root/根场景/视角节点/摄像机.near,$/root/根场景/视角节点/摄像机.far,$/root/根场景/视角节点/摄像机.h_offset,$/root/根场景/视角节点/摄像机.v_offset,$/root/根场景/视角节点/摄像机.frustum_offset[0],$/root/根场景/视角节点/摄像机.frustum_offset[1]]
		else:
			$/root/根场景/视角节点.局部位置=[$/root/根场景/视角节点.position[0],$/root/根场景/视角节点.position[1],$/root/根场景/视角节点.position[2],$/root/根场景/视角节点.quaternion.x,$/root/根场景/视角节点.quaternion.y,$/root/根场景/视角节点.quaternion.z,$/root/根场景/视角节点/摄像机.size,$/root/根场景/视角节点/摄像机.near,$/root/根场景/视角节点/摄像机.far,$/root/根场景/视角节点/摄像机.h_offset,$/root/根场景/视角节点/摄像机.v_offset,$/root/根场景/视角节点/摄像机.frustum_offset[0],$/root/根场景/视角节点/摄像机.frustum_offset[1]]
	var 四元数存储:Quaternion=$/root/根场景/视角节点.quaternion
	for 循环 in 3:
		$/root/根场景/视角节点.位移表达式[循环]="0"
		$/root/根场景/视角节点.旋转表达式[循环]="0"
		$/root/根场景/视角节点.视距变更表达式[循环]="0"
		#检测选择停止运动后运动状态是保持在原地还是指定位置，拉丁字母“s”表示保持原来状态
		if 位移[循环]!="s":
			$/root/根场景/视角节点.position[循环]=float(位移[循环])
		if int(欧拉角旋转顺序)!=0:
			if 旋转[循环]!="s":
				$/root/根场景/视角节点.rotation[循环]=float(旋转[循环])
	if 视距[0]!="s":
		if 投影模式==0:
			$/root/根场景/视角节点/摄像机.fov=float(视距[0])
		else:
			$/root/根场景/视角节点/摄像机.size=float(视距[0])
	if 视距[1]!="s":
		$/root/根场景/视角节点/摄像机.near=float(视距[1])
	if 视距[2]!="s":
		$/root/根场景/视角节点/摄像机.far=float(视距[2])
	if 视口偏移[0]!="s":
		$/root/根场景/视角节点/摄像机.h_offset=float(视口偏移[0])
	if 视口偏移[1]!="s":
		$/root/根场景/视角节点/摄像机.v_offset=float(视口偏移[1])
	if 视口偏移[2]!="s":
		$/root/根场景/视角节点/摄像机.frustum_offset[0]=float(视口偏移[2])
	if 视口偏移[3]!="s":
		$/root/根场景/视角节点/摄像机.frustum_offset[1]=float(视口偏移[3])
	#print(四元数存储)
	if int(欧拉角旋转顺序)==0:
		if 旋转[0]!="s":
			四元数存储.x=float(旋转[0])
		if 旋转[1]!="s":
			四元数存储.y=float(旋转[1])
		if 旋转[2]!="s":
			四元数存储.z=float(旋转[2])
		if 四元数存储.x+四元数存储.y+四元数存储.z==0.0:
			四元数存储.w=1
		else:
			四元数存储.w=float(欧拉角旋转顺序)
		$/root/根场景/视角节点.quaternion=四元数存储
	return 状态
#0x0A
func 游戏模式(类型:int)->void:
	if 类型==0:
		$/root/根场景/主场景/轨道.show()
		$/root/根场景/主场景/无轨.hide()
	else:
		$/root/根场景/主场景/轨道.hide()
		$/root/根场景/主场景/无轨.show()
	pass
#0x0B
func 添加轨道(立即添加:bool=false,出现时间:float=0,轨道类型:int=1,定义轨道编号:int=0,允许触碰白块:int=1,轨道位置:Vector3=Vector3(0,0,0),轨道旋转角:Vector3=Vector3(0,0,0),欧拉角旋转顺序:float=EULER_ORDER_YXZ,物件区位置:float=-4,缩放值:Vector3=Vector3(1,1,1))->int:
	var 对象:Dictionary={"轨道编号":-1,"轨道节点":null,"出现时间":出现时间}
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		#检查定义的轨道编号是否存在
		for 循环 in 轨道编号表.size():
			if 轨道编号表[循环].轨道编号==定义轨道编号:
				状态=FAILED
				break
		if 状态==OK:
			match 轨道类型:
				#有轨
				0:
					var 轨道=有轨轨道场景.instantiate()
					轨道.name="轨道"+var_to_str(定义轨道编号)
					轨道.轨道编号=定义轨道编号
					轨道.position=轨道位置
					match int(欧拉角旋转顺序):
						1,2,3,4,5,6:
							轨道.rotation_order=int(欧拉角旋转顺序-1)
							轨道.rotation=轨道旋转角
						0,_:
							# 更新旋转四元数
							轨道.quaternion=Quaternion(轨道旋转角[0],轨道旋转角[1],轨道旋转角[2],欧拉角旋转顺序)
					轨道.scale=缩放值
					轨道.允许失误=允许触碰白块
					轨道.更改物件区位置(物件区位置)
					if 立即添加:
						self.add_child(轨道)
					对象.轨道编号=定义轨道编号
					对象.轨道节点=轨道
				#无轨
				1:
					var 轨道=无轨轨道场景.instantiate()
					轨道.name="轨道"+var_to_str(定义轨道编号)
					轨道.轨道编号=定义轨道编号
					轨道.position=轨道位置
					match int(欧拉角旋转顺序):
						1,2,3,4,5,6:
							轨道.rotation_order=int(欧拉角旋转顺序-1)
							轨道.rotation=轨道旋转角
						0,_:
							# 更新旋转四元数
							轨道.quaternion=Quaternion(轨道旋转角[0],轨道旋转角[1],轨道旋转角[2],欧拉角旋转顺序)
					轨道.scale=缩放值
					轨道.允许失误=允许触碰白块
					轨道.更改物件区位置(物件区位置)
					if 立即添加:
						self.add_child(轨道)
					对象.轨道编号=定义轨道编号
					对象.轨道节点=轨道
			轨道编号表.push_back(对象)
	return 状态
#0x0C
func 轨道移动(轨道编号:int,出现时间:float=0,位移表达式:Array=["0","0","0"],旋转表达式:Array=["0","0","0"],欧拉角旋转顺序:int=EULER_ORDER_YXZ,物件区移动表达式:String="0",缩放表达式:Array=["0","0","0"])->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 轨道编号表.size():
			if 轨道编号表[节点循环].轨道编号==轨道编号:
				节点=轨道编号表[节点循环].轨道节点
				轨道编号表[节点循环].轨道节点.移动状态=true
				break
		if 节点!=null:
			if int(欧拉角旋转顺序)!=0:
				节点.rotation_order=int(欧拉角旋转顺序-1)
			节点.状态变更=false
			节点.静止时刻=出现时间
			if int(欧拉角旋转顺序)==0:
				节点.四元数旋转状态=true
			else:
				节点.四元数旋转状态=false
			#未来添加语句检测，防止恶意代码注入以及语法错误的表达式
			节点.位移表达式=位移表达式
			节点.旋转表达式=旋转表达式
			节点.缩放表达式=缩放表达式
			节点.物件区移动表达式=物件区移动表达式
		else:
			状态=FAILED
	else:
		状态=FAILED
	return 状态
#0x0D
func 轨道停止移动(轨道编号:int,位移:Array=["0","0","0"],旋转:Array=["0","0","0"],欧拉角旋转顺序:int=EULER_ORDER_YXZ,物件区位置:String="0",缩放:Array=["0","0","0"])->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 轨道编号表.size():
			if 轨道编号表[节点循环].轨道编号==轨道编号:
				节点=轨道编号表[节点循环].轨道节点
				轨道编号表[节点循环].轨道节点.移动状态=false
				if int(欧拉角旋转顺序)==0:
					轨道编号表[节点循环].轨道节点.局部位置=[轨道编号表[节点循环].轨道节点.position[0],轨道编号表[节点循环].轨道节点.position[1],轨道编号表[节点循环].轨道节点.position[2],轨道编号表[节点循环].轨道节点.quaternion.x,轨道编号表[节点循环].轨道节点.quaternion.y,轨道编号表[节点循环].轨道节点.quaternion.z,轨道编号表[节点循环].轨道节点.scale[0],轨道编号表[节点循环].轨道节点.scale[1],轨道编号表[节点循环].轨道节点.scale[2],轨道编号表[节点循环].轨道节点.get_node("判定线").position[1]]
				else:
					轨道编号表[节点循环].轨道节点.局部位置=[轨道编号表[节点循环].轨道节点.position[0],轨道编号表[节点循环].轨道节点.position[1],轨道编号表[节点循环].轨道节点.position[2],轨道编号表[节点循环].轨道节点.rotation[0],轨道编号表[节点循环].轨道节点.rotation[1],轨道编号表[节点循环].轨道节点.rotation[2],轨道编号表[节点循环].轨道节点.scale[0],轨道编号表[节点循环].轨道节点.scale[1],轨道编号表[节点循环].轨道节点.scale[2],轨道编号表[节点循环].轨道节点.get_node("判定线").position[1]]
				break
		if 节点!=null:
			if int(欧拉角旋转顺序)==0:
				节点.四元数旋转状态=true
			else:
				节点.四元数旋转状态=false
				节点.rotation_order=int(欧拉角旋转顺序-1)
			#位移
			for 循环 in 3:
				节点.位移表达式[循环]="0"
				节点.旋转表达式[循环]="0"
				节点.缩放表达式[循环]="0"
				#检测选择停止运动后运动状态是保持在原地还是指定位置，拉丁字母“s”表示保持原来状态
				if 位移[循环]!="s":
					节点.position[循环]=float(位移[循环])
				if 旋转[循环]!="s":
					节点.rotation[循环]=float(旋转[循环])
				if 缩放[循环]!="s":
					节点.scale[循环]=float(缩放[循环])
			if 物件区位置!="s":
				节点.物件区移动表达式=物件区位置
		else:
			状态=FAILED
	else:
		状态=FAILED
	return 状态
#0x0E
func 轨道显示隐藏(轨道编号:int,隐藏状态:bool=false)->int:
	var 节点:Node=null
	var 状态:int=OK
	for 节点循环 in 轨道编号表.size():
		if 轨道编号表[节点循环].轨道编号==轨道编号:
			节点=轨道编号表[节点循环].轨道节点
			break
	if 节点!=null:
		节点.visible=隐藏状态
	else:
		状态=FAILED
	return 状态
func 轨道线条变更(轨道编号:int,线条编号:int=0,网格表达式:Array=["0.05","1","0,05"],纹理表达式:Array=["s","s","s","s"])->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 轨道编号表.size():
			if 轨道编号表[节点循环].轨道编号==轨道编号:
				节点=轨道编号表[节点循环].轨道节点
				break
		if 节点!=null:
			for 循环 in 节点.线条节点组.size():
				#未来添加语句检测，防止恶意代码注入以及语法错误的表达式
				if 线条编号==循环:
					节点.状态变更=[false,false]
					节点.线条节点组[循环].网格表达式=网格表达式
					节点.线条节点组[循环].纹理表达式=纹理表达式
					if 网格表达式!=["s","s","s"]:
						节点.线条节点组[循环].网格变更状态=true
					else:
						节点.线条节点组[循环].网格变更状态=false
					if 纹理表达式!=["s","s","s","s"]:
						节点.线条节点组[循环].纹理变更状态=true
					else:
						节点.线条节点组[循环].纹理变更状态=false
					break
			if 线条编号>=节点.线条节点组.size():
				状态=FAILED
		else:
			状态=FAILED
	else:
		状态=FAILED
	return 状态

func 线条停止变更(轨道编号:int,线条编号:int=0,网格表达式:Array=["s","s","s"],纹理表达式:Array=["s","s","s","s"])->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 轨道编号表.size():
			if 轨道编号表[节点循环].轨道编号==轨道编号:
				节点=轨道编号表[节点循环].轨道节点
				break
		if 节点!=null:
			#位移
			#判定线、左分隔线与右分隔线循环
			for 循环 in 节点.线条节点组.size():
				if 线条编号==循环:
					节点.线条节点组[循环].网格表达式=网格表达式
					节点.线条节点组[循环].纹理表达式=纹理表达式
					节点.线条节点组[循环].网格变更状态=false
					节点.线条节点组[循环].纹理变更状态=false
					#检测选择停止运动后运动状态是保持在原地还是指定位置，英文字母“s”表示保持原来状态
					for 网格表达式循环 in 网格表达式.size():
						if 网格表达式[网格表达式循环]!="s":
							节点.线条节点组[循环].mesh.size[网格表达式循环]=float(网格表达式[网格表达式循环])
					for 纹理表达式循环 in 纹理表达式.size():
						if 纹理表达式[纹理表达式循环]!="s":
							节点.线条节点组[循环].get_material_override().albedo_color[纹理表达式循环]=float(纹理表达式[纹理表达式循环])
					break
		else:
			状态=FAILED
	else:
		状态=FAILED
	return 状态
#0x0F
func 轨道允许失误(轨道编号:int,允许失误:int=1)->int:
	var 节点:Node=null
	var 状态:int=OK
	for 节点循环 in 轨道编号表.size():
		if 轨道编号表[节点循环].轨道编号==轨道编号:
			节点=轨道编号表[节点循环].轨道节点
			break
	if 节点!=null:
		节点.允许失误=允许失误
	else:
		状态=FAILED
	return 状态
func 删除轨道(轨道编号:int,立刻删除:bool=false)->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 轨道编号表.size():
			if 轨道编号表[节点循环].轨道编号==轨道编号:
				节点=轨道编号表[节点循环].轨道节点
				轨道编号表[节点循环].轨道节点.移动状态=false
				if 立刻删除==true:
					节点.queue_free()
					轨道编号表.remove_at(节点循环)
				else:
					if 节点.get_parent()!=null:
						节点.get_parent().remove_child(节点)
				状态=OK
				break
			else:
				状态=FAILED
	else:
		状态=FAILED
	return 状态

func 添加物件(物件类型:int=1,轨道编号:int=0,定义物件编号:int=0,物件位置:Vector3=Vector3(0,0,0),轨道旋转角:Vector3=Vector3(0,0,0),欧拉角旋转顺序:int=EULER_ORDER_YXZ,缩放值:Vector3=Vector3(1,1,1),默认移动方式:bool=true)->int:
	var 对象:Dictionary={"物件编号":0,"轨道编号":0,"音轨编号":0,"物件节点":null,"出现状态":false}
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		for 循环 in 物件编号表.size():
			if 物件编号表[循环].轨道编号==定义物件编号:
				状态=FAILED
				break
		if 状态==OK:
			var 物件:Node
			match 物件类型:
				#@onready var 黑块场景 = preload("res://场景/音符/黑块.tscn")
				#@onready var 长块场景 = preload("res://场景/音符/长块.tscn")
				#@onready var 叠块场景 = preload("res://场景/音符/狂戳.tscn")
				#@onready var 滑条场景 = preload("res://场景/音符/滑块.tscn")
				#@onready var 六角块场景 = preload("res://场景/音符/爆裂.tscn")
				#@onready var 绿键场景 = preload("res://场景/音符/绿键.tscn")
				#@onready var 滑键场景 = preload("res://场景/音符/滑键.tscn")
				#@onready var 圆球场景 = preload("res://场景/音符/旋转.tscn")
				#@onready var 弯曲滑条场景 = preload("res://场景/音符/弯曲滑块.tscn")
				1:
					物件=长块场景.instantiate()
				2:
					物件=叠块场景.instantiate()
				3:
					物件=滑条场景.instantiate()
				4:
					物件=六角块场景.instantiate()
				5:
					物件=绿键场景.instantiate()
				6:
					物件=滑键场景.instantiate()
				7:
					物件=圆球场景.instantiate()
				8:
					物件=弯曲滑条场景.instantiate()
				0,_:
					物件=黑块场景.instantiate()
			物件.name="物件"+var_to_str(定义物件编号)
			物件.音符出现时间=$/root/根场景/视角节点/背景音乐播放节点.播放时间
			物件.物件编号=定义物件编号
			物件.position=物件位置
			match int(欧拉角旋转顺序):
				1,2,3,4,5,6:
					物件.rotation_order=int(欧拉角旋转顺序-1)
					物件.rotation=轨道旋转角
				0,_:
					# 更新旋转四元数
					物件.quaternion=Quaternion(轨道旋转角[0],轨道旋转角[1],轨道旋转角[2],欧拉角旋转顺序)
			物件.scale=缩放值
			物件.默认移动方式=默认移动方式
			if 默认移动方式==true:
				物件.数码乐谱节拍速度=(60000000.0/float($"/root/根场景/主场景".微秒每拍))
				物件.数码乐谱基础节拍=(4.0/float($"/root/根场景/主场景".每节节拍))
			if $/root/根场景/主场景/无轨.visible==true:
				var 节点:Node=null
				for 节点循环 in 轨道编号表.size():
					if 轨道编号表[节点循环].轨道编号==轨道编号:
						节点=轨道编号表[节点循环].轨道节点
						break
				if 节点!=null:
					节点.get_node("物件区").add_child(物件)
					对象.物件编号=定义物件编号
					对象.轨道编号=轨道编号
					对象.物件节点=物件
					物件编号表.push_back(对象)
	return 状态
func 物件移动(物件编号:int,位移表达式:Array=["0","0","0"],旋转表达式:Array=["0","0","0"],欧拉角旋转顺序:int=EULER_ORDER_YXZ,缩放表达式:Array=["0","0","0"])->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 物件编号表.size():
			if 物件编号表[节点循环].物件编号==物件编号:
				节点=物件编号表[节点循环].物件节点
				物件编号表[节点循环].物件节点.移动状态=true
				break
		if 节点!=null:
			节点.rotation_order=int(欧拉角旋转顺序-1)
			节点.状态变更=false
			#位移
			for 循环 in 3:
				#未来添加语句检测，防止恶意代码注入以及语法错误的表达式
				节点.位移表达式[循环]=位移表达式[循环]
				节点.旋转表达式[循环]=旋转表达式[循环]
				节点.缩放表达式[循环]=缩放表达式[循环]
		else:
			状态=FAILED
	else:
		状态=FAILED
	return 状态
func 物件停止移动(物件编号:int,位移:Array=["0","0","0"],旋转:Array=["0","0","0"],欧拉角旋转顺序:int=EULER_ORDER_YXZ,缩放:Array=["0","0","0"])->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 物件编号表.size():
			if 物件编号表[节点循环].物件编号==物件编号:
				节点=物件编号表[节点循环].物件节点
				物件编号表[节点循环].物件节点.移动状态=false
				物件编号表[节点循环].物件节点.局部位置=[物件编号表[节点循环].物件节点.position[0],物件编号表[节点循环].物件节点.position[1],物件编号表[节点循环].物件节点.position[2],物件编号表[节点循环].物件节点.rotation[0],物件编号表[节点循环].物件节点.rotation[1],物件编号表[节点循环].物件节点.rotation[2],物件编号表[节点循环].物件节点.scale[0],物件编号表[节点循环].物件节点.scale[1],物件编号表[节点循环].物件节点.scale[2]]
				break
		if 节点!=null:
			节点.rotation_order=int(欧拉角旋转顺序-1)
			#位移
			for 循环 in 3:
				节点.位移表达式[循环]="0"
				节点.旋转表达式[循环]="0"
				节点.缩放表达式[循环]="0"
				#检测选择停止运动后运动状态是保持在原地还是指定位置，拉丁字母“s”表示保持原来状态
				if 位移[循环]!="s":
					节点.position[循环]=float(位移[循环])
				if 旋转[循环]!="s":
					节点.rotation[循环]=float(旋转[循环])
				if 缩放[循环]!="s":
					节点.scale[循环]=float(缩放[循环])
		else:
			状态=FAILED
	else:
		状态=FAILED
	return 状态

func 删除物件(物件编号:int)->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 物件编号表.size():
			if 物件编号表[节点循环].物件编号==物件编号:
				节点=物件编号表[节点循环].物件节点
				物件编号表[节点循环].物件节点.移动状态=false
				节点.queue_free()
				物件编号表.remove_at(节点循环)
				状态=OK
				break
			else:
				状态=FAILED
	else:
		状态=FAILED
	return 状态

func 设置背景音频(空音频状态:bool=true,音频文件路径:String="")->int:
	if 空音频状态==false:
		var 读取结果: = FileAccess.open(音频文件路径, FileAccess.READ )
		if 读取结果!=null:
			if 读取结果.get_error() == OK:
				var 文件流:StreamPeerBuffer = StreamPeerBuffer.new( )
				文件流.set_data_array(读取结果.get_buffer( 读取结果.get_length( ) ) )
				文件流.big_endian = false
				var 文件头:String=文件流.get_string(4)
				var 音频资源=ResourceLoader.load(音频文件路径)
				if 文件头.find("ID3")==0:
					文件头="ID3"
				match 文件头:
					"ID3","OggS","RIFF":
						print(音频资源)
						if 音频资源!=null:
							$'/root/根场景/视角节点/背景音乐播放节点'.stream=ResourceLoader.load(音频文件路径)
						else:
							$"/root/根场景/视角节点/背景音乐播放节点".stream=AudioStreamGenerator.new()
							return FAILED
						pass
					"flaC",_:
						$"/root/根场景/视角节点/背景音乐播放节点".stream=AudioStreamGenerator.new()
						#flac文件
						pass
			else:
				return 读取结果.get_error()
		else:
			$"/root/根场景/视角节点/背景音乐播放节点".stream=AudioStreamGenerator.new()
			return FAILED
	else:
		$"/root/根场景/视角节点/背景音乐播放节点".stream=AudioStreamGenerator.new()
	return OK
