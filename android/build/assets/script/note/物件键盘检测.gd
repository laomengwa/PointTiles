extends Area3D
var 父节点
var 音符消除状态=false
func 音符消除():
	音符消除状态=true
	#创建动画
#	var 动画=Animation.new()
#	var 轨道值 = 动画.add_track(Animation.TYPE_VALUE)
#	动画.track_set_path(轨道值, "../../block2:visible")
#	动画.track_insert_key(轨道值, 0.0, true)
#	动画.track_insert_key(轨道值, 0.3, false)
#	动画.length = 0.3
#	$'动画'.play("物件消除")
	GlobalScript.游戏界面连击数 = GlobalScript.游戏界面连击数 + 1
	get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str(GlobalScript.游戏界面连击数)
	if 父节点.position[1] > -6.5 && 父节点.position[1] < -4.5:
		GlobalScript.游戏界面分数 = GlobalScript.游戏界面分数 + 32
		get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str(GlobalScript.游戏界面分数)
		$"/root/根场景/根界面/游戏界面/判定动画".stop()
		$"/root/根场景/根界面/游戏界面/判定动画".play("完美")
		$"/root/根场景/主场景".完美判定=$"/root/根场景/主场景".完美判定+1
	elif 父节点.position[1] > -4.5 && 父节点.position[1] < -2.5 || 父节点.position[1] > -8.5 && 父节点.position[1] < -6.5:
		GlobalScript.游戏界面分数 = GlobalScript.游戏界面分数 + 16
		get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str(GlobalScript.游戏界面分数)
		$"/root/根场景/根界面/游戏界面/判定动画".stop()
		$"/root/根场景/根界面/游戏界面/判定动画".play("良好")
		$"/root/根场景/主场景".良好判定=$"/root/根场景/主场景".良好判定+1
	elif 父节点.position[1] > -2.5 && 父节点.position[1] < -0.5 || 父节点.position[1] > -10 && 父节点.position[1] < -8.5:
		GlobalScript.游戏界面分数 = GlobalScript.游戏界面分数 + 8
		get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str(GlobalScript.游戏界面分数)
		$"/root/根场景/根界面/游戏界面/判定动画".stop()
		$"/root/根场景/根界面/游戏界面/判定动画".play("较差")
		$"/root/根场景/主场景".较差判定=$"/root/根场景/主场景".较差判定+1
	else:
		GlobalScript.游戏界面分数 = GlobalScript.游戏界面分数 + 2
		get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str(GlobalScript.游戏界面分数)
		$"/root/根场景/根界面/游戏界面/判定动画".stop()
		$"/root/根场景/根界面/游戏界面/判定动画".play("很差")
		$"/root/根场景/主场景".很差判定=$"/root/根场景/主场景".很差判定+1
	父节点.queue_free()
	pass
func _process(delta):
	#检测物件是否为长块
	if 父节点.get_node('长条尾')==null:
		if 父节点.position[1]<=-12:
			父节点.queue_free()
	else:
		if 父节点.get_node('长条尾').position[1]<=-12:
			父节点.queue_free()
		if 音符消除状态==false:
			GlobalScript.游戏界面连击数 = 0
			get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str(GlobalScript.游戏界面连击数)
			if GlobalScript.游戏界面分数 - 32 > 0:
				GlobalScript.游戏界面分数 = GlobalScript.游戏界面分数 - 32
			else:
				GlobalScript.游戏界面分数 = 0
			get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str(GlobalScript.游戏界面分数)
			$"/root/根场景/根界面/游戏界面/判定动画".stop()
			$"/root/根场景/根界面/游戏界面/判定动画".play("漏击")
			$"/root/根场景/主场景".漏击判定=$"/root/根场景/主场景".漏击判定+1
			pass
		pass
	pass
