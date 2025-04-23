extends SubViewport

func _process(delta):
	#自适应画布（用于设置界面控制选项手柄模型的显示）
	size[0]=$'../../../../../../../../'.size[0]-30
	size[1]=size[0]*0.5
	scaling_3d_scale=get_tree().root.content_scale_factor
	pass
