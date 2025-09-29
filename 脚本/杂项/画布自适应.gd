extends SubViewport

func _process(_帧处理):
	#自适应画布（用于设置界面控制选项手柄模型的显示）
	self.size[0]=$'../../../../../../../../'.size[0]-30
	self.size[1]=int(self.size[0]*0.5)
	scaling_3d_scale=get_tree().root.content_scale_factor
	$"节点/手柄模型".visible=$'../../../../../../../../../'.visible
	pass
