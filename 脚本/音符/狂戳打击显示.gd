extends MeshInstance3D
var 提示显示方向=false
var 音符出现时间=0.0
var 显示编号=0
func _ready():
	$'标签'.text=var_to_str(显示编号)
	pass
func _process(_帧处理):
	#print($'/root/根场景/视角节点/背景音乐播放节点'.播放时间-音符出现时间)
	match 提示显示方向:
		true:
			self.position=Vector3(($'/root/根场景/视角节点/背景音乐播放节点'.播放时间-音符出现时间-1.5)*8,self.position[1],self.position[2]);
			if self.position[0]>=0:
				self.queue_free()
		false:
			self.position=Vector3((-$'/root/根场景/视角节点/背景音乐播放节点'.播放时间+音符出现时间+1.5)*8,self.position[1],self.position[2]);
			if self.position[0]<=0:
				self.queue_free()
	pass
