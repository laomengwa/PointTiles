extends Node3D
var 音符出现时间 = 0.0
# Called when the node enters the scene tree for the first time.
var 谱面阶段=0
func _ready():
	$"模型/触摸区域".父节点=self
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if GlobalScript.游戏开始状态==false:
		self.position=Vector3(self.position[0],self.position[1]-0.2,self.position[2]);
	else:
		self.position=Vector3(self.position[0],(1-(($'/root/根场景/视角节点/背景音乐播放节点'.播放时间-音符出现时间)))*3/GlobalScript.谱面基础节拍[谱面阶段]*(GlobalScript.谱面每分钟节拍[谱面阶段]/60),self.position[2]);
	pass


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed == true && GlobalScript.游戏开始状态==true:
			$'模型/触摸区域'.音符消除()
	pass # Replace with function body.
