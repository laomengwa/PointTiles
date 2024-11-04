extends AnimationPlayer
func 动画播放结束(anim_name):
	$'/root/根场景/视角节点/摄像机'.current=true
	$'/root/根场景/视角节点'.show()
	$'/root/根场景/玩家编号'.show()
	$'/root/根场景/游戏启动'.queue_free()
	pass # Replace with function body.
