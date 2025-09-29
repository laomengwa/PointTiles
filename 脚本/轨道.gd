#版权所有 萌娃是条咸鱼
#严禁注入破坏稳定性的脚本
#测试阶段脚本
extends Node3D
#@export var 音效:AudioStream=load("res://音乐/音效/点击.wav")
#var 分数:int=0
#var 死亡状态:bool=false
#@export var 关卡目标:int=15
#func _ready() -> void:
	#
	#pass
#
#func _process(帧处理: float) -> void:
	#if $"/root/根场景/主场景".歌曲类型格式==2:
		#$'/root/根场景/根界面/游戏界面/星星皇冠显示'.hide()
		#$'/root/根场景/根界面/游戏界面/状态信息/游戏界面血量条'.hide()
		#$'/root/根场景/根界面/游戏界面/详细信息/游戏界面分数'.hide()
		#$'/root/根场景/根界面/游戏界面/详细信息/游戏界面精确度'.hide()
		#$'/root/根场景/根界面/游戏界面/详细信息/游戏界面速度'.hide()
	#else:
		#$'/root/根场景/根界面/游戏界面/星星皇冠显示'.show()
		#$'/root/根场景/根界面/游戏界面/状态信息/游戏界面血量条'.show()
		#$'/root/根场景/根界面/游戏界面/详细信息/游戏界面分数'.show()
		#$'/root/根场景/根界面/游戏界面/详细信息/游戏界面精确度'.show()
		#$'/root/根场景/根界面/游戏界面/详细信息/游戏界面速度'.show()
	#$'/root/根场景/根界面/游戏界面/状态信息/游戏界面进度条'.value=(float(关卡目标)-$'/root/根场景/视角节点/背景音乐播放节点'.播放时间)/float(关卡目标)*100.0
	#if $'/root/根场景/视角节点/背景音乐播放节点'.播放时间>=float(关卡目标):
		#$'/root/根场景/视角节点/背景音乐播放节点'.stop()
		#$'/root/根场景/视角节点/背景音乐播放节点'.播放时间=0
		#$'/root/根场景/根界面/游戏界面'.退出()
	#pass
	#
#func 初始化() -> void:
	#if $"/root/根场景/主场景".歌曲类型格式==2:
		#分数=0
		#$'/root/根场景/根界面/游戏界面/状态信息/游戏界面进度条'.value=100
		#死亡状态=false
		#for 物件数量 in 25:
			#var 黑块:Node
			#黑块=$"/root/根场景/主场景".黑块场景.instantiate()
			#$"/root/根场景/主场景".音符位置确定()
			#黑块.position[1]=物件数量*3-3
			#黑块.物件编号=物件数量
			#$"/root/根场景/主场景".音符生成(黑块,0)
			#pass
		#pass
#func 失误()->void:
	#if $"/root/根场景/主场景/开始按键".visible==false:
		#死亡状态=true
		#$"/root/根场景/根界面/游戏界面/界面动画".play("游戏失败")
		#$'/root/根场景/视角节点/背景音乐播放节点'.stop()
		#音效=load("res://音乐/音效/失败.wav")
		#$"/root/根场景/根界面/界面音频/音效".set_stream(音效)
		#$"/root/根场景/根界面/界面音频/音效".play()
		#音效=load("res://音乐/音效/点击.wav")
		#pass
#func 黑块帧处理(物件:Node)->void:
	#pass
#func 黑块点击(物件:Node,输入事件:InputEvent)->void:
	#if !死亡状态 and 输入事件 is not InputEventMouse:
		#if 物件.物件编号==分数:
			#分数+=1
			#物件.get_parent().get_parent().键盘消除状态=true
			#for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
				#var 子节点 = $'/root/根场景/主场景/轨道'.get_child(子节点循环)
				#子节点.get_node("物件区").position[1]-=3
			#for 子节点循环 in $'/root/根场景/主场景/无轨'.get_child_count():
				#var 子节点 = $'/root/根场景/主场景/无轨'.get_child(子节点循环)
				#子节点.get_node("物件区").position[1]-=3
			#$"/root/根场景/根界面/界面音频/音效".set_stream(音效)
			#$"/root/根场景/根界面/界面音频/音效".play()
			#物件.音符消除()
			#生成黑块()
		#else:
			#if 输入事件 is not InputEventScreenDrag and 输入事件 is not InputEventScreenTouch:
				#物件.get_parent().get_parent().get_node("失误显示").position[1]=-3
				#物件.get_parent().get_parent().失误判定(true)
			#pass
#func 生成黑块()->void:
	#var 黑块:Node
	#黑块=$"/root/根场景/主场景".黑块场景.instantiate()
	#$"/root/根场景/主场景".音符位置确定()
	#黑块.position[1]=(25+分数)*3-6
	#黑块.物件编号=24+分数
	#$"/root/根场景/主场景".音符生成(黑块,0)
	#pass
