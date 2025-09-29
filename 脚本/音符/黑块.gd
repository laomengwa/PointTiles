extends Node3D
class_name 物件类
##物件节点专用类型
@export var 调试模式:bool=false
var 音符出现时间:float = 0.0
var 音符长度:float = 0.0
var 谱面阶段:int=0
var 音符消除状态:bool=false
var 音符序列:Array
var 判定偏移:float
@export var 物件编号:int=-1
#狂戳定义
var 狂戳模式状态:bool=false
var 狂戳轨道提示:Array=[0]
var 狂戳叠加量:int=0
var 狂戳节奏模式:bool=false
var 粉块放置数量:int=0

var 长条按下事件:bool=false
var 长条触摸位置:Vector3=Vector3.ZERO
var 连击加分:int=0
var 触摸输入事件:InputEvent
#MIDI模式
var 数码乐谱节拍速度:float=1
var 数码乐谱基础节拍:float=1
var 数码乐谱音高:int=0
var 默认移动方式:bool=true
#这个变量告诉物件清除器是否为该物件进行释放内存处理
var 物件暂存模式:bool=false
#这个变量记录物件开始运动时的时间
var 静止时刻:float=0.0
var 局部位置:Array=[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
#物件自定义移动
@export var 移动状态:bool=false
@export var 位移表达式:Array=["0","0","0"]
@export var 旋转表达式:Array=["0","0","0"]
@export var 缩放表达式:Array=["0","0","0"]
var 脚本:Array=[Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new()]
#这个变量用来防止创建脚本的代码每帧都执行
var 状态变更:bool=false

func _input(事件: InputEvent) -> void:
	#长条松开事件
	if 事件 is InputEventScreenTouch and 触摸输入事件 is InputEventScreenTouch:
		if 事件.get_index()==触摸输入事件.get_index():
			音符松开触发()
		pass
	pass

func _ready():
	match $'/root/根场景/主场景'.歌曲类型格式:
		0:
			if 全局脚本.游戏开始状态==true:
				判定偏移=(1-(20*(4/float($'/root/根场景/主场景'.每节节拍))*($"../../判定线".position[1]-0.5))/(60000000.0/float($'/root/根场景/主场景'.微秒每拍)))+全局脚本.判定偏移
		1:
			if 全局脚本.游戏开始状态==true:
				判定偏移=(1-(20*全局脚本.谱面基础节拍[谱面阶段]*($"../../判定线".position[1]-0.5))/全局脚本.谱面每分钟节拍[谱面阶段])+全局脚本.判定偏移
	#给滑条添加着色器
	if self.has_node('折叠滑条')==true||self.has_node('弯曲滑块')==true:
		var 滑条材质=ShaderMaterial.new()
		滑条材质.shader=preload('res://着色/音符/滑块.gdshader')
		滑条材质.set_shader_parameter("Texture",load('res://模型/滑块.png'))
		滑条材质.next_pass=ShaderMaterial.new()
		滑条材质.next_pass.shader=preload('res://着色/物件边框.gdshader')
		滑条材质.next_pass.next_pass=ShaderMaterial.new()
		滑条材质.next_pass.next_pass.shader=preload('res://着色/长块按下.gdshader')
		get_node("模型").set_surface_override_material(0,滑条材质)
		self.get_node("模型").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
		self.get_node("模型").get_active_material(0).next_pass.next_pass.set_shader_parameter("color",Vector3(1.0,0.5,0.5))
		pass
	#给长条添加着色器
	if self.has_node('模型/长条尾')==true:
		#定义触摸区域
		var 触摸区域形状=ConvexPolygonShape3D.new()
		var 形状点位=PackedVector3Array([Vector3(-1, -3, 0),Vector3(1, -3, 0),Vector3(-1, 0, -1),Vector3(-1, 0, 1),Vector3(1, 0, -1),Vector3(1, 0, 1)])
		#求出长条尾的y轴位置
		var 高度轴点位=self.get_node('模型/长条尾').position[1]+6.0
		形状点位.append_array(PackedVector3Array([Vector3(-1, 高度轴点位, -1),Vector3(-1, 高度轴点位, 1),Vector3(1, 高度轴点位, -1),Vector3(1, 高度轴点位, 1)]))
		触摸区域形状.set_points(形状点位)
		self.get_node('模型/长条头/触摸区域/形状').set_shape(触摸区域形状)
		var 长条头材质=StandardMaterial3D.new()
		var 长条腰材质=StandardMaterial3D.new()
		var 长条尾材质=StandardMaterial3D.new()
		长条头材质.albedo_texture=preload('res://模型/长条头.png')
		长条腰材质.albedo_texture=preload('res://模型/长条腰.png')
		长条尾材质.albedo_texture=preload('res://模型/长条尾.png')
		长条头材质.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
		长条腰材质.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
		长条尾材质.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
		长条头材质.diffuse_mode=BaseMaterial3D.DIFFUSE_TOON
		长条腰材质.diffuse_mode=BaseMaterial3D.DIFFUSE_TOON
		长条尾材质.diffuse_mode=BaseMaterial3D.DIFFUSE_TOON
		长条头材质.specular_mode=BaseMaterial3D.SPECULAR_TOON
		长条腰材质.specular_mode=BaseMaterial3D.SPECULAR_TOON
		长条尾材质.specular_mode=BaseMaterial3D.SPECULAR_TOON
		长条头材质.next_pass=ShaderMaterial.new()
		长条腰材质.next_pass=ShaderMaterial.new()
		长条尾材质.next_pass=ShaderMaterial.new()
		长条头材质.next_pass.shader=preload('res://着色/物件边框.gdshader')
		长条腰材质.next_pass.shader=preload('res://着色/物件边框.gdshader')
		长条尾材质.next_pass.shader=preload('res://着色/物件边框.gdshader')
		长条头材质.next_pass.next_pass=ShaderMaterial.new()
		长条腰材质.next_pass.next_pass=ShaderMaterial.new()
		长条尾材质.next_pass.next_pass=ShaderMaterial.new()
		长条头材质.next_pass.next_pass.shader=preload('res://着色/长块按下.gdshader')
		长条腰材质.next_pass.next_pass.shader=preload('res://着色/长块按下.gdshader')
		长条尾材质.next_pass.next_pass.shader=preload('res://着色/长块按下.gdshader')
		get_node("模型/长条头").set_surface_override_material(0,长条头材质)
		get_node("模型/长条腰").set_surface_override_material(0,长条腰材质)
		get_node("模型/长条尾").set_surface_override_material(0,长条尾材质)
		self.get_node("模型/长条头").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
		self.get_node("模型/长条腰").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
		self.get_node("模型/长条尾").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
	pass
func _process(_帧处理):
	if 全局脚本.游戏开始状态==false:
		if 调试模式==false:
			self.position=Vector3(self.position[0],self.position[1]-0.2,self.position[2]);
			#清除装饰
			if self.position[1]<=-20:
				if 物件暂存模式==true:
					$"../".remove_child(self)
				else:
					销毁物件()
		else:
			self.position[1]=-2
	else:
		if (触摸输入事件 is InputEventScreenTouch||($"../..".键盘消除状态==true&&长条按下事件==true))&&音符消除状态==false:
			音符按下触发()
		#物件编号显示
		self.get_node("音符调试编号").text=var_to_str(物件编号)
		self.get_node("音符调试编号").visible=全局脚本.物件轨道编号显示
		match $'/root/根场景/主场景'.歌曲类型格式:
			1:
				#狂戳
				if self.has_node('模型/打击判定轨道')==true:
					self.get_node('进度条/幕布/进度条').value=($'/root/根场景/视角节点/背景音乐播放节点'.播放时间-(狂戳轨道提示[0]+判定偏移))/(狂戳轨道提示[狂戳轨道提示.size()-1]-狂戳轨道提示[0])*100
					#判断出现时间
					if 狂戳轨道提示[粉块放置数量]-判定偏移<=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间:
						if 狂戳节奏模式==true:
							if 粉块放置数量<狂戳轨道提示.size()-1:
								var 粉块:Node
								粉块=$'/root/根场景/主场景'.狂戳打击显示.instantiate()
								粉块.显示编号=狂戳轨道提示.size()-粉块放置数量
								粉块.音符出现时间 = 狂戳轨道提示[粉块放置数量-1]
								if 粉块放置数量%2==0:
									粉块.提示显示方向=true
								else:
									粉块.提示显示方向=false
								self.get_node('模型/打击判定轨道/节奏打击提示轨道').add_child(粉块)
								粉块放置数量+=1
						else:
							self.get_node('模型/打击判定轨道').hide()
						if 狂戳轨道提示[狂戳轨道提示.size()-1]+判定偏移<=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间:
							if 狂戳节奏模式==true&&狂戳叠加量>0:
								$"../..".失误判定(false)
							if 物件暂存模式==true:
								$"../".remove_child(self)
							else:
								销毁物件()
				if 狂戳模式状态==false:
					#物件位移代码
					self.position=Vector3(self.position[0],(1-$'/root/根场景/视角节点/背景音乐播放节点'.播放时间+音符出现时间)*3/全局脚本.谱面基础节拍[谱面阶段]*(全局脚本.谱面每分钟节拍[谱面阶段]/60),self.position[2]);
				#检测物件是否为长块
				if has_node('模型/长条尾')==false:
					if has_node('标签')==true:
						if self.get_node('标签').position[1]+self.position[1]<=-12:
							漏击判定()
					else:
						if self.position[1]<=-12:
							漏击判定()
				else:
					if self.get_node('模型/长条尾').position[1]+self.position[1]<=-12:
						漏击判定()
					pass
				#自动模式
				if 音符消除状态==false&&$"/root/根场景/主场景".自动模式==true&&$'/root/根场景/视角节点/背景音乐播放节点'.播放时间>=音符出现时间+判定偏移:
					音符消除()
			#终止声音播放
				for 声音数据集合循环 in 音符序列.size():
					if 音符消除状态==true||长条按下事件==true||self.has_node('模型/打击判定轨道')==true:
						if ((音符序列[声音数据集合循环].出现时间-全局脚本.阶段时间位置[$/root/根场景/主场景.谱面阶段])*60/全局脚本.谱面每分钟节拍[$/root/根场景/主场景.谱面阶段]/32)+$/root/根场景/主场景.谱面段落时间差+$/root/根场景/主场景.音频延迟<=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间:
							if 音符序列[声音数据集合循环].播放状态==0:
								音符序列[声音数据集合循环].播放状态=1
								var 半音=$/root/根场景/主场景.对象文件声音数组[音符序列[声音数据集合循环].声音]
								#print(半音)
								var 乐器=音符序列[声音数据集合循环].音色
								var 力度=100
								var 通道=音符序列[声音数据集合循环].通道
								var 状态=MIDI_MESSAGE_NOTE_ON
								音符输入事件(半音,乐器,力度,通道,状态)
					
					if (((音符序列[声音数据集合循环].出现时间+音符序列[声音数据集合循环].时长)-全局脚本.阶段时间位置[谱面阶段])*60/全局脚本.谱面每分钟节拍[谱面阶段]/32)+$"/root/根场景/主场景".谱面段落时间差+$"/root/根场景/主场景".音频延迟<=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间:
						if 音符序列[声音数据集合循环].播放状态==1:
							音符序列[声音数据集合循环].播放状态=2
							var 半音休止=$"/root/根场景/主场景".对象文件声音数组[音符序列[声音数据集合循环].声音]
							#print(半音)
							var 乐器休止=音符序列[声音数据集合循环].音色
							var 力度休止=100
							var 通道休止=音符序列[声音数据集合循环].通道
							var 状态休止=MIDI_MESSAGE_NOTE_OFF
							音符输入事件(半音休止,乐器休止,力度休止,通道休止,状态休止)
			0:
				if 默认移动方式==true:
					self.position=Vector3(self.position[0],(1-$'/root/根场景/视角节点/背景音乐播放节点'.播放时间+音符出现时间)*3/数码乐谱基础节拍*(数码乐谱节拍速度/60),self.position[2]);
					#检测物件是否为长块
					if has_node('模型/长条尾')==false:
						if has_node('标签')==true:
							if self.get_node('标签').position[1]+self.position[1]<=-12:
								漏击判定()
						else:
							if self.position[1]<=-12:
								漏击判定()
					else:
						if self.get_node('模型/长条尾').position[1]+self.position[1]<=-12:
							漏击判定()
						pass
				else:
					#物件自定义移动
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
										printerr("错误")
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
										printerr("错误")
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
										printerr("错误")
								if 脚本[循环+6].get_script()!=null:
									self.scale[循环]=脚本[循环+6].函数(运动时间)
								pass
							if 状态变更==false:
								状态变更=true
			2:
				#传统模式自定义脚本行为
				$'/root/根场景/主场景/轨道'.黑块帧处理(self)
				pass
func 音符输入事件(半音,乐器,力度,通道,状态):
	var 输入事件=InputEventMIDI.new()
	输入事件.channel=通道
	输入事件.pitch=半音
	输入事件.velocity=力度
	输入事件.instrument=乐器
	输入事件.message=状态
	$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(输入事件)
func 音符消除():
	#狂戳
	if self.has_node('模型/打击判定轨道')==true:
		狂戳模式状态=true
		if 狂戳节奏模式==true:
			if 狂戳叠加量>1:
				狂戳叠加量=狂戳叠加量-1
				self.get_node('模型/标签').text=var_to_str(狂戳叠加量)
			else:
				音符消除状态=true
				var 黑块材质=ShaderMaterial.new()
				黑块材质.shader=preload('res://着色/黑块消除.gdshader')
				黑块材质.next_pass=ShaderMaterial.new()
				黑块材质.next_pass.shader=preload('res://着色/物件边框.gdshader')
				get_node("模型").set_surface_override_material(0,黑块材质)
				$动画.play("音符消除")
				self.get_node('模型/触摸区域').hide()
				狂戳模式状态=false
		else:
			狂戳叠加量=狂戳叠加量+1
			self.get_node('模型/标签').text="x"+var_to_str(狂戳叠加量)
	#爆裂块
	elif self.has_node('模型/爆裂粒子')==true:
		get_node("动画").play('音符消除')
		音符消除状态=true
		self.get_node('模型/触摸区域').hide()
	elif self.has_node('折叠滑条')==true:
		self.get_node('模型/触摸区域').hide()
	#长块
	elif self.has_node('模型/长条尾')==true:
		if 长条按下事件==false&&$"/root/根场景/主场景".自动模式==true:
			音符消除状态=true
			self.get_node('模型/长条头/触摸区域').hide()
	#黑块
	else:
		音符消除状态=true
		var 黑块材质=ShaderMaterial.new()
		黑块材质.shader=preload('res://着色/黑块消除.gdshader')
		黑块材质.next_pass=ShaderMaterial.new()
		黑块材质.next_pass.shader=preload('res://着色/物件边框.gdshader')
		get_node("模型").set_surface_override_material(0,黑块材质)
		$动画.play("音符消除")
		self.get_node('模型/触摸区域').hide()
	$"/root/根场景/主场景".游戏界面连击数 = $"/root/根场景/主场景".游戏界面连击数 + 1
	if $"/root/根场景/主场景".最大连击数 <= $"/root/根场景/主场景".游戏界面连击数:
		$"/root/根场景/主场景".最大连击数=$"/root/根场景/主场景".游戏界面连击数
	get_node("/root/根场景/根界面/游戏界面/状态信息/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
	打击判定(false)
	#手机振动
	if $/root/根场景/根界面/设置/设置选项/控制/控制/其他/容器/手机振动/勾选盒.button_pressed==true:
		Input.vibrate_handheld(100)
	pass
func 漏击判定():
	if $"/root/根场景/主场景".自动模式==false||$"../".visible==true:
		if 音符消除状态==false:
			$"/root/根场景/主场景".游戏界面连击数 = 0
			get_node("/root/根场景/根界面/游戏界面/状态信息/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
			if $"/root/根场景/主场景".游戏界面分数 - 32 > 0:
				$"/root/根场景/主场景".游戏界面分数 = $"/root/根场景/主场景".游戏界面分数 - 32
			else:
				$"/root/根场景/主场景".游戏界面分数 = 0
			get_node("/root/根场景/根界面/游戏界面/详细信息/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
			$"/root/根场景/根界面/游戏界面/判定动画".stop()
			$"/root/根场景/根界面/游戏界面/判定动画".play("漏击")
			$"/root/根场景/主场景".丢失生命值()
			$"/root/根场景/主场景".判定统计[4]=$"/root/根场景/主场景".判定统计[4]+1
			$/root/根场景/主场景.精确度判定组.push_back(0)
			$/root/根场景/主场景.精确度判定=0.0
			#统计精确度
			for 循环 in $/root/根场景/主场景.精确度判定组.size():
				$/root/根场景/主场景.精确度判定=$/root/根场景/主场景.精确度判定+($/root/根场景/主场景.精确度判定组[循环]/floor($/root/根场景/主场景.精确度判定组.size()))
			$/root/根场景/根界面/游戏界面/详细信息/游戏界面精确度.text="%02.2f" %float($/root/根场景/主场景.精确度判定)+"%"
			if 物件暂存模式==true:
				$"../".remove_child(self)
			else:
				销毁物件()
			pass
		else:
			if 物件暂存模式==true:
				$"../".remove_child(self)
			else:
				销毁物件()
	else:
		if 物件暂存模式==true:
			$"../".remove_child(self)
		else:
			销毁物件()
	pass
func 点击事件(_摄像机节点, 事件, 触摸点位置, _法向量, _形状网格):
	match $'/root/根场景/主场景'.歌曲类型格式:
		0,1:
			if 音符消除状态==false:
				#滑条
				if self.has_node('折叠滑条')==true||self.has_node('弯曲滑块')==true:
					#滑条按下时的视觉印记
					if 全局脚本.游戏开始状态==true:
						if 事件 is InputEventScreenDrag:
							if self.get_node("模型").get_active_material(0).next_pass.next_pass.get_shader_parameter("state")==true and 触摸输入事件 is InputEventScreenTouch:
								if 触摸输入事件.index==事件.index:
									滑条视觉效果(触摸点位置[1]/self.get_node("模型").basis[1][1]-4.5)
						if 事件 is InputEventScreenTouch:
							if 事件.pressed==true:
								长条按下事件==true
								滑条视觉效果(触摸点位置[1]/self.get_node("模型").basis[1][1]-4.5)
								长条触摸位置=触摸点位置
							else:
								触摸输入事件=null
								self.get_node("模型").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
								#长条打击判定(触摸点位置[1]-6.0)
								打击判定(false)
								$"/root/根场景/主场景".游戏界面连击数+=1
								get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
					#调试代码
					elif 全局脚本.游戏开始状态==false&&调试模式==true:
							if 事件 is InputEventScreenDrag:
								if self.get_node("模型").get_active_material(0).next_pass.next_pass.get_shader_parameter("state")==true and 触摸输入事件 is InputEventScreenTouch:
									if 触摸输入事件.index==事件.index:
										滑条视觉效果(触摸点位置[1]/self.get_node("模型").basis[1][1]-4.5)
							if 事件 is InputEventScreenTouch:
								if 事件.pressed==true:
									滑条视觉效果(触摸点位置[1]/self.get_node("模型").basis[1][1]-4.5)
								else:
									self.get_node("模型").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
				#长条
				if self.has_node('模型/长条尾')==true:
					#长条按下时的视觉印记
					if 全局脚本.游戏开始状态==true:
						if 事件 is InputEventScreenDrag:
							if self.get_node("模型/长条头").get_active_material(0).next_pass.next_pass.get_shader_parameter("state")==true and 触摸输入事件 is InputEventScreenTouch:
								if 触摸输入事件.index==事件.index:
									长条视觉效果(触摸点位置[1]-6.0)
						if 事件 is InputEventScreenTouch:
							if 事件.pressed==true:
								长条按下事件==true
								长条视觉效果(触摸点位置[1]-6.0)
								长条触摸位置=触摸点位置
							else:
								触摸输入事件=null
								#长条打击判定(触摸点位置[1]-6.0)
								打击判定(false)
								$"/root/根场景/主场景".游戏界面连击数+=1
								get_node("/root/根场景/根界面/游戏界面/状态信息/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
					#调试代码
					elif 全局脚本.游戏开始状态==false&&调试模式==true:
						if 事件 is InputEventScreenDrag:
							if self.get_node("模型/长条头").get_active_material(0).next_pass.next_pass.get_shader_parameter("state")==true and 触摸输入事件 is InputEventScreenTouch:
								if 触摸输入事件.index==事件.index:
									长条视觉效果(触摸点位置[1]-6.0)
						if 事件 is InputEventScreenTouch:
							if 事件.pressed==true:
								长条视觉效果(触摸点位置[1]-6.0)
							else:
								self.get_node("模型/长条头").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
								self.get_node("模型/长条腰").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
								self.get_node("模型/长条尾").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
			if 事件 is InputEventScreenTouch&&音符消除状态==false:
				#其他物件
				触摸输入事件=事件
				if 事件.pressed == true && 全局脚本.游戏开始状态==true:
					#暂停状态下取消暂停背景音乐
					if $'/root/根场景/视角节点/背景音乐播放节点'.get_stream_paused()==true:
						$"/root/根场景/根界面/游戏界面/倒计时/计时器".stop()
						$"/root/根场景/根界面/游戏界面/倒计时/动画".stop()
						$"/root/根场景/根界面/游戏界面/倒计时".hide()
						$'/root/根场景/视角节点/背景音乐播放节点'.set_stream_paused(false)
						$'/root/根场景/视角节点/背景音乐播放节点'.真实播放时间=$'/root/根场景/视角节点/背景音乐播放节点'.真实播放时间+(Time.get_ticks_usec()-$'/root/根场景/根界面/游戏界面'.暂停时间)
					音符消除()
			pass
		2:
			$'/root/根场景/主场景/轨道'.黑块点击(self,事件)
			pass
func 打击判定(尾判:bool):
	#print(音符序列)
	var 精确度:float=0
	var 时间判定:float
	var 位置判定:float
	if 尾判==false:
		时间判定=音符出现时间
		位置判定=self.position[1]
	else:
		时间判定=音符长度+音符出现时间
		print(时间判定)
		if self.has_node('模型/长条尾')==true:
			位置判定=self.position[1]+self.get_node('模型/长条尾').position[1]
		else:
			位置判定=self.position[1]
	#设定完美打击判定为±80ms
	if $'/root/根场景/视角节点/背景音乐播放节点'.播放时间<=时间判定+判定偏移+0.08 && $'/root/根场景/视角节点/背景音乐播放节点'.播放时间>=音符出现时间+判定偏移-0.08:
		$"/root/根场景/主场景".游戏界面分数 = $"/root/根场景/主场景".游戏界面分数 + 32
		get_node("/root/根场景/根界面/游戏界面/详细信息/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
		$"/root/根场景/根界面/游戏界面/判定动画".stop()
		if $"/root/根场景/主场景".自动模式==false:
			$"/root/根场景/根界面/游戏界面/判定动画".play("完美")
		else:
			$"/root/根场景/根界面/游戏界面/判定动画".play("自动")
		$"/root/根场景/主场景".判定统计[0]=$"/root/根场景/主场景".判定统计[0]+1
		精确度=100.0
		$"/root/根场景/主场景".添加生命值(0.5)
	#设定良好打击判定为±240ms
	elif $'/root/根场景/视角节点/背景音乐播放节点'.播放时间<=时间判定+判定偏移+0.24 && $'/root/根场景/视角节点/背景音乐播放节点'.播放时间>=音符出现时间+判定偏移-0.24:
		$"/root/根场景/主场景".游戏界面分数 = $"/root/根场景/主场景".游戏界面分数 + 16
		get_node("/root/根场景/根界面/游戏界面/详细信息/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
		$"/root/根场景/根界面/游戏界面/判定动画".stop()
		if $"/root/根场景/主场景".自动模式==false:
			$"/root/根场景/根界面/游戏界面/判定动画".play("良好")
		else:
			$"/root/根场景/根界面/游戏界面/判定动画".play("自动")
		$"/root/根场景/主场景".判定统计[1]=$"/root/根场景/主场景".判定统计[1]+1
		精确度=75.0
		$"/root/根场景/主场景".添加生命值(0.2)
	#设定较差打击判定为空间判定，判定区间为物件自身y轴坐标+判定偏移坐标是否大于或小于判定线坐标±4.5
	elif 位置判定+(全局脚本.判定偏移/0.375) >= $"../../判定线".position[1]-4.5 && 位置判定+(全局脚本.判定偏移/0.375) <= $"../../判定线".position[1]+4.5:
		$"/root/根场景/主场景".游戏界面分数 = $"/root/根场景/主场景".游戏界面分数 + 8
		get_node("/root/根场景/根界面/游戏界面/详细信息/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
		$"/root/根场景/根界面/游戏界面/判定动画".stop()
		if $"/root/根场景/主场景".自动模式==false:
			$"/root/根场景/根界面/游戏界面/判定动画".play("较差")
		else:
			$"/root/根场景/根界面/游戏界面/判定动画".play("自动")
		$"/root/根场景/主场景".判定统计[2]=$"/root/根场景/主场景".判定统计[2]+1
		精确度=50.0
		$"/root/根场景/主场景".添加生命值(0.1)
	#其余都判定为很差
	else:
		$"/root/根场景/主场景".游戏界面分数 = $"/root/根场景/主场景".游戏界面分数 + 2
		get_node("/root/根场景/根界面/游戏界面/详细信息/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
		$"/root/根场景/根界面/游戏界面/判定动画".stop()
		if $"/root/根场景/主场景".自动模式==false:
			$"/root/根场景/根界面/游戏界面/判定动画".play("很差")
		else:
			$"/root/根场景/根界面/游戏界面/判定动画".play("自动")
		$"/root/根场景/主场景".判定统计[3]=$"/root/根场景/主场景".判定统计[3]+1
		精确度=25.0
	$/root/根场景/主场景.精确度判定组.push_back(精确度)
	$/root/根场景/主场景.精确度判定=0.0
	$/root/根场景/主场景.无瑕度判定组.push_back($'/root/根场景/视角节点/背景音乐播放节点'.播放时间-时间判定-判定偏移)
	#统计精确度
	for 循环 in $/root/根场景/主场景.精确度判定组.size():
		$/root/根场景/主场景.精确度判定=$/root/根场景/主场景.精确度判定+($/root/根场景/主场景.精确度判定组[循环]/floor($/root/根场景/主场景.精确度判定组.size()))
	$/root/根场景/根界面/游戏界面/详细信息/游戏界面精确度.text="%.2f" %float($/root/根场景/主场景.精确度判定)+"%"
	pass
#在键盘按下或者手指离开音符碰撞体积外且没有松开手指的时候触发
func 音符按下触发()->void:
	if self.has_node('折叠滑条')==true:
		if 触摸输入事件 is InputEventScreenTouch:
			if 触摸输入事件.pressed==true:
				滑条视觉效果(长条触摸位置[1]/self.get_node("模型").basis[1][1]-4.5)
		else:
			滑条视觉效果(长条触摸位置[1]/self.get_node("模型").basis[1][1]-4.5)
	if self.has_node('模型/长条尾')==true:
		if 触摸输入事件 is InputEventScreenTouch:
			if 触摸输入事件.pressed==true:
				长条视觉效果(长条触摸位置[1]-6.0)
		else:
			长条视觉效果(长条触摸位置[1]-6.0)
	pass

func 音符松开触发()->void:
	if self.has_node('折叠滑条')==true:
		触摸输入事件=null
		if 调试模式==false:
			长条打击判定(长条触摸位置[1]-4.5)
			$"/root/根场景/主场景".游戏界面连击数+=1
			get_node("/root/根场景/根界面/游戏界面/状态信息/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
		else:
			self.get_node("模型").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
	if self.has_node('模型/长条尾')==true:
		触摸输入事件=null
		if 调试模式==false:
			长条打击判定(长条触摸位置[1]-6.0)
			$"/root/根场景/主场景".游戏界面连击数+=1
			get_node("/root/根场景/根界面/游戏界面/状态信息/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
		else:
			self.get_node("模型/长条头").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
			self.get_node("模型/长条腰").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
			self.get_node("模型/长条尾").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
	pass
func 滑条视觉效果(触摸点:float)->void:
	self.get_node("模型").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",true)
	self.get_node("模型").get_active_material(0).next_pass.next_pass.set_shader_parameter("time",(((self.position[1]-触摸点+1.5)/-3)+2)/self.get_node("模型").basis[1][1])
	pass
func 长条视觉效果(触摸点:float)->void:
	self.get_node("模型/长条头").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",true)
	self.get_node("模型/长条腰").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",true)
	self.get_node("模型/长条尾").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",true)
	self.get_node("模型/长条腰").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",true)
	self.get_node("模型/长条腰").get_active_material(0).next_pass.next_pass.set_shader_parameter("time",(((self.position[1]-触摸点+1.5)/-3)+2)/self.get_node("模型/长条腰").scale[1])
	self.get_node("模型/长条头").get_active_material(0).next_pass.next_pass.set_shader_parameter("time",((self.position[1]-触摸点)/-3)+2)
	self.get_node("模型/长条尾").get_active_material(0).next_pass.next_pass.set_shader_parameter("time",((self.position[1]+self.get_node("模型/长条尾").position[1]-触摸点)/-3)+1.5)
	pass
func 长条打击判定(触摸点:float):
	if 音符消除状态==false:
		if self.has_node('模型/长条尾')==true:
			if -(self.position[1]-触摸点)+2<self.get_node('模型/长条尾').position[1]+(全局脚本.判定偏移/0.375)-3||-(self.position[1]-触摸点)+2>self.get_node('模型/长条尾').position[1]+(全局脚本.判定偏移/0.375)+3:
				$"../..".失误判定(false)
			else:
				打击判定(true)
				$"/root/根场景/主场景".游戏界面连击数 = $"/root/根场景/主场景".游戏界面连击数 + 连击加分
				get_node("/root/根场景/根界面/游戏界面/状态信息/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
				$动画.play("音符消除")
		else:
			打击判定(true)
			$"/root/根场景/主场景".游戏界面连击数 = $"/root/根场景/主场景".游戏界面连击数 + 连击加分
			get_node("/root/根场景/根界面/游戏界面/状态信息/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
			$动画.play("音符消除")
		#$"../..".失误判定(false)
		音符消除状态=true
	#self.queue_free()
	pass
func 销毁物件()->void:
	for 循环 in 脚本:
		循环.free()
	脚本.clear()
	位移表达式.clear()
	旋转表达式.clear()
	缩放表达式.clear()
	局部位置.clear()
	音符序列.clear()
	self.queue_free()
	pass
