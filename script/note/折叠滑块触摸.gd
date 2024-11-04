extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func 触摸事件(camera, event, event_position, normal, shape_idx):
	var 黑块材质=ShaderMaterial.new()
	黑块材质.shader=preload('res://shader/黑块消除.gdshader')
	黑块材质.next_pass=ShaderMaterial.new()
	黑块材质.next_pass.shader=preload('res://shader/物件边框.gdshader')
	self.set_surface_override_material(0,黑块材质)
	#$动画.play("音符消除")
	#
	#self.get_node('模型/触摸区域').hide()
	pass # Replace with function body.
