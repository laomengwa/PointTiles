extends Node3D
#控制游戏行为的接口
@onready var 有轨轨道场景 = preload("res://场景/音符/有轨轨道.tscn")
@onready var 无轨轨道场景 = preload("res://场景/音符/无轨轨道.tscn")
var 新增轨道编号:int=0
var 轨道编号表:Array=[]
func 恢复初始状态()->void:
	新增轨道编号=0
	轨道编号表=[]
	pass
func 游戏模式(类型:int)->void:
	if 类型==0:
		$/root/根场景/主场景/轨道.show()
		$/root/根场景/主场景/无轨.hide()
	else:
		$/root/根场景/主场景/轨道.hide()
		$/root/根场景/主场景/无轨.show()
	pass
func 添加轨道(轨道类型:int=1,轨道位置:Vector3=Vector3(0,0,0),轨道旋转角:Vector3=Vector3(0,0,0),欧拉角旋转顺序:int=EULER_ORDER_YXZ,缩放值:Vector3=Vector3(1,1,1))->Dictionary:
	var 对象:Dictionary={"轨道编号":0,"轨道节点":null}
	if $/root/根场景/主场景/无轨.visible==true:
		match 轨道类型:
			#有轨
			0:
				var 轨道=有轨轨道场景.instantiate()
				轨道.name="轨道"+var_to_str(新增轨道编号)
				新增轨道编号+=1
				轨道.position=轨道位置
				轨道.rotation=轨道旋转角
				轨道.rotation_order=欧拉角旋转顺序
				轨道.scale=缩放值
				self.add_child(轨道)
				对象.轨道编号=新增轨道编号
				对象.轨道节点=轨道
			#无轨
			1:
				var 轨道=无轨轨道场景.instantiate()
				轨道.name="轨道"+var_to_str(新增轨道编号)
				新增轨道编号+=1
				轨道.position=轨道位置
				轨道.rotation=轨道旋转角
				轨道.rotation_order=欧拉角旋转顺序
				轨道.scale=缩放值
				self.add_child(轨道)
				对象.轨道编号=新增轨道编号
				对象.轨道节点=轨道
		轨道编号表.push_back(对象)
	return 对象
func 轨道移动(轨道编号:int,位移表达式:Array=["0","0","0"],旋转表达式:Array=["0","0","0"],欧拉角旋转顺序:int=EULER_ORDER_YXZ,缩放表达式:Array=["0","0","0"])->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 轨道编号表.size():
			if 轨道编号表[节点循环].轨道编号==轨道编号:
				节点=轨道编号表[节点循环].轨道节点
				轨道编号表[节点循环].轨道节点.移动状态=true
				break
		if 节点!=null:
			节点.rotation_order=欧拉角旋转顺序
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
func 轨道停止移动(轨道编号:int,位移:Array=["0","0","0"],旋转:Array=["0","0","0"],欧拉角旋转顺序:int=EULER_ORDER_YXZ,缩放:Array=["0","0","0"])->int:
	var 状态:int=OK
	if $/root/根场景/主场景/无轨.visible==true:
		var 节点:Node=null
		for 节点循环 in 轨道编号表.size():
			if 轨道编号表[节点循环].轨道编号==轨道编号:
				节点=轨道编号表[节点循环].轨道节点
				轨道编号表[节点循环].轨道节点.移动状态=false
				轨道编号表[节点循环].轨道节点.局部位置=[轨道编号表[节点循环].轨道节点.position[0],轨道编号表[节点循环].轨道节点.position[1],轨道编号表[节点循环].轨道节点.position[2],轨道编号表[节点循环].轨道节点.rotation[0],轨道编号表[节点循环].轨道节点.rotation[1],轨道编号表[节点循环].轨道节点.rotation[2],轨道编号表[节点循环].轨道节点.scale[0],轨道编号表[节点循环].轨道节点.scale[1],轨道编号表[节点循环].轨道节点.scale[2]]
				break
		if 节点!=null:
			节点.rotation_order=欧拉角旋转顺序
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
func 轨道允许失误(轨道编号:int,允许失误:bool=false)->int:
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
func 更改摄像机状态(位置:Vector3=Vector3(0,0,0),旋转:Vector3=Vector3(0,0,0),欧拉角旋转顺序:int=EULER_ORDER_YXZ,视角大小:float=70.0,投影模式:int=0,保持长宽比:int=1,近平面:float=0.05,远平面:float=4000)->void:
	$/root/根场景/视角节点.position=位置
	$/root/根场景/视角节点.rotation=旋转
	$/root/根场景/视角节点.rotation_order=欧拉角旋转顺序
	$/root/根场景/视角节点/摄像机.keep_aspect=保持长宽比
	$/root/根场景/视角节点/摄像机.projection=投影模式
	$/root/根场景/视角节点/摄像机.near=近平面
	$/root/根场景/视角节点/摄像机.far=远平面
	match 投影模式:
		0:
			$/root/根场景/视角节点/摄像机.fov=视角大小
		1,2:
			$/root/根场景/视角节点/摄像机.size=视角大小
	pass
func 摄像机移动(位移表达式:Array=["0","0","0"],旋转表达式:Array=["0","0","0"],欧拉角旋转顺序:int=EULER_ORDER_YXZ)->int:
	var 状态:int=OK
	$/root/根场景/视角节点.移动状态=true
	$/root/根场景/视角节点.状态变更=false
	#位移
	for 循环 in 3:
		#未来添加语句检测，防止恶意代码注入以及语法错误的表达式
		$/root/根场景/视角节点.位移表达式[循环]=位移表达式[循环]
		$/root/根场景/视角节点.旋转表达式[循环]=旋转表达式[循环]
		$/root/根场景/视角节点.rotation_order=欧拉角旋转顺序
	return 状态
func 摄像机停止移动(位移:Array=["0","0","0"],旋转:Array=["0","0","0"],欧拉角旋转顺序:int=EULER_ORDER_YXZ)->int:
	var 状态:int=OK
	$/root/根场景/视角节点.移动状态=false
	$/root/根场景/视角节点.局部位置=[$/root/根场景/视角节点.position[0],$/root/根场景/视角节点.position[1],$/root/根场景/视角节点.position[2],$/root/根场景/视角节点.rotation[0],$/root/根场景/视角节点.rotation[1],$/root/根场景/视角节点.rotation[2],$/root/根场景/视角节点.scale[0],$/root/根场景/视角节点.scale[1],$/root/根场景/视角节点.scale[2]]
	for 循环 in 3:
		$/root/根场景/视角节点.位移表达式[循环]="0"
		$/root/根场景/视角节点.旋转表达式[循环]="0"
		#检测选择停止运动后运动状态是保持在原地还是指定位置，拉丁字母“s”表示保持原来状态
		if 位移[循环]!="s":
			$/root/根场景/视角节点.position[循环]=float(位移[循环])
		if 旋转[循环]!="s":
			$/root/根场景/视角节点.rotation[循环]=float(旋转[循环])
	return 状态
