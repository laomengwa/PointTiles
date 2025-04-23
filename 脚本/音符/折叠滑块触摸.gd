extends MeshInstance3D

func _ready():
	var 滑条材质=ShaderMaterial.new()
	滑条材质.shader=preload('res://着色/音符/滑块.gdshader')
	滑条材质.set_shader_parameter("Texture",load('res://模型/滑块.png'))
	滑条材质.next_pass=ShaderMaterial.new()
	滑条材质.next_pass.shader=preload('res://着色/物件边框.gdshader')
	滑条材质.next_pass.next_pass=ShaderMaterial.new()
	滑条材质.next_pass.next_pass.shader=preload('res://着色/长块按下.gdshader')
	self.set_surface_override_material(0,滑条材质)
	self.get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
	self.get_active_material(0).next_pass.next_pass.set_shader_parameter("color",Vector3(1.0,0.5,0.5))
	pass

func _process(帧处理):
	if $"../../".触摸输入事件 is InputEventScreenTouch&&$"../../".音符消除状态==false:
		if $"../../".触摸输入事件.pressed==true:
			滑条视觉效果($"../../".长条触摸位置[1]-4.5)
	pass

func 触摸事件(摄像机, 事件, 触摸点, 法向量, 网格编号):
	if 全局脚本.游戏开始状态==true:
		if 事件 is InputEventScreenDrag:
			滑条视觉效果(触摸点[1]-4.5)
		if 事件 is InputEventScreenTouch:
			if 事件.pressed==true:
				滑条视觉效果(触摸点[1]-4.5)
			else:
				#长条打击判定(触摸点位置[1]-6.0)
				$"/root/根场景/主场景".游戏界面连击数+=1
				get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
	#调试代码
	elif 全局脚本.游戏开始状态==false:
		if 事件 is InputEventScreenDrag:
			if self.get_node("模型").get_active_material(0).next_pass.next_pass.get_shader_parameter("state")==true and $"../../".触摸输入事件 is InputEventScreenTouch:
				if $"../../".触摸输入事件.index==事件.index:
					滑条视觉效果(触摸点[1]-4.5)
		if 事件 is InputEventScreenTouch:
			if 事件.pressed==true:
				滑条视觉效果(触摸点[1]-4.5)
			else:
				self.get_node("模型").get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
	
	
	#var 黑块材质=ShaderMaterial.new()
	#黑块材质.shader=preload('res://着色/黑块消除.gdshader')
	#黑块材质.next_pass=ShaderMaterial.new()
	#黑块材质.next_pass.shader=preload('res://着色/物件边框.gdshader')
	#self.set_surface_override_material(0,黑块材质)
	#$动画.play("音符消除")
	#
	#self.get_node('模型/触摸区域').hide()
	pass
func 滑条视觉效果(触摸点:float)->void:
	self.get_active_material(0).next_pass.next_pass.set_shader_parameter("state",true)
	self.get_active_material(0).next_pass.next_pass.set_shader_parameter("time",(((self.position[1]+$"../../".position[1]-触摸点+1.5)/-3)+2)/self.basis[1][1])
	pass
func _input(事件: InputEvent) -> void:
	#长条松开事件
	if 事件 is InputEventScreenTouch and $"../../".触摸输入事件 is InputEventScreenTouch:
		if 事件.get_index()==$"../../".触摸输入事件.get_index():
			self.get_active_material(0).next_pass.next_pass.set_shader_parameter("state",false)
		pass
	pass
