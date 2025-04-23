extends Node3D
@onready var 黑块场景 = preload("res://scene/tiles.tscn")
@onready var 长块场景 = preload("res://scene/hold.tscn")
@onready var 有轨轨道场景 = preload("res://scene/有轨轨道.tscn")
func 清除物件():
	for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
		var 子节点 = $'/root/根场景/主场景/轨道'.get_child(子节点循环)
		for 子节点二循环 in get_node('/root/根场景/主场景/轨道/'+子节点.name+'/物件区').get_child_count():
			var 物件区子节点=get_node('/root/根场景/主场景/轨道/'+子节点.name+'/物件区').get_child(子节点二循环)
			物件区子节点.queue_free()
	pass
func _on_timer_timeout():
	if GlobalScript.游戏开始状态==false:
		var 黑块=黑块场景.instantiate()
		黑块.position=Vector3(0,40,0)
		音符生成(黑块)
	pass # Replace with function body.
func 开始按钮():
	$'../视角节点/背景音乐播放节点'.playing=true
	$'../视角节点/背景音乐播放节点'.set_pitch_scale(1)
	#$'../CameraLight/AudioStreamPlayer'.seek(30)
	$"开始按键".hide()
	末尾音符=true
	音符摆放=0
	谱面阶段=0
	谱面段落时间差=0.0
	pass
var 音符摆放=0
func _on_按键区域_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed == true:
			开始按钮()
	pass # Replace with function body.
var 末尾音符=true
var 完美判定=0
var 良好判定=0
var 较差判定=0
var 很差判定=0
var 漏击判定=0
var 失误判定=0
var 谱面阶段=0
var 谱面段落时间差=0.0
func _process(delta):
	if $"开始按键".visible==false && $'../视角节点/背景音乐播放节点'.playing==true:
		while $'../视角节点/背景音乐播放节点'.播放时间>=((GlobalScript.物件总时间[0][音符摆放]-GlobalScript.阶段时间位置[谱面阶段])*60/GlobalScript.谱面每分钟节拍[谱面阶段]/32)+谱面段落时间差:
			if 谱面阶段<GlobalScript.阶段时间位置.size()-1:
				if GlobalScript.阶段时间位置[谱面阶段+1]<=GlobalScript.物件总时间[0][音符摆放]:
					谱面段落时间差=((GlobalScript.物件总时间[0][音符摆放]-GlobalScript.阶段时间位置[谱面阶段])*60/GlobalScript.谱面每分钟节拍[谱面阶段]/32)+谱面段落时间差
					谱面阶段=谱面阶段+1
			var 黑块=黑块场景.instantiate()
			var 长块=长块场景.instantiate()
			var 物件
			$'/root/根场景/根界面/游戏界面/游戏界面速度/每分钟节拍速'.text=var_to_str(GlobalScript.谱面每分钟节拍[谱面阶段])
			$'/root/根场景/根界面/游戏界面/游戏界面速度/速度'.text="%.3f" %(float(GlobalScript.谱面每分钟节拍[谱面阶段]/(GlobalScript.谱面基础节拍[谱面阶段]*60)))
			if GlobalScript.物件类型[0][音符摆放]=="黑块":
				物件=黑块
			elif GlobalScript.物件类型[0][音符摆放]=="长块":
				物件=长块
				#长条尾位置布局
				物件.get_node("长条尾").position=Vector3(0,(GlobalScript.物件时长[0][音符摆放]/(GlobalScript.谱面基础节拍[谱面阶段]*32.0)-1)*3,0)
				物件.get_node("长条腰").scale=Vector3(1,GlobalScript.物件时长[0][音符摆放]/(GlobalScript.谱面基础节拍[谱面阶段]*32.0)-1,1)
				if GlobalScript.物件时长[0][音符摆放]/(GlobalScript.谱面基础节拍[谱面阶段]*32.0)-1>1:
					物件.get_node("长条腰").show()
			else:
				物件=黑块
			物件.谱面阶段=谱面阶段
			物件.position=Vector3(0,10,0)
			$'/root/根场景/根界面/游戏界面/游戏界面进度条'.value=(float(音符摆放)/float(GlobalScript.物件总时间[0].size()))*100
			var 音符时间=GlobalScript.物件总时间[0][音符摆放]*60/GlobalScript.谱面每分钟节拍[谱面阶段]/32
			物件.音符出现时间=(GlobalScript.物件总时间[0][音符摆放]-GlobalScript.阶段时间位置[谱面阶段])*60/GlobalScript.谱面每分钟节拍[谱面阶段]/32+谱面段落时间差
			if 音符摆放<GlobalScript.物件总时间[0].size()-1:
				音符摆放=音符摆放+1
				音符生成(物件)
			else:
				if 末尾音符==true:
					音符生成(物件)
					末尾音符=false
				while $'../视角节点/背景音乐播放节点'.播放时间>=((GlobalScript.物件总时间[0][音符摆放]-GlobalScript.阶段时间位置[谱面阶段])*60/GlobalScript.谱面每分钟节拍[谱面阶段]/32)+谱面段落时间差+GlobalScript.物件时长[0][音符摆放]*60/GlobalScript.谱面每分钟节拍[谱面阶段]/32+2:
					$'../视角节点/背景音乐播放节点'.playing=false
					get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/界面容器/得分").text = var_to_str(GlobalScript.游戏界面分数)
					get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/连击数/数值").text = var_to_str(GlobalScript.游戏界面连击数)
					get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/完美/数值").text=var_to_str(完美判定)
					get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/良好/数值").text=var_to_str(良好判定)
					get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/较差/数值").text=var_to_str(较差判定)
					get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/很差/数值").text=var_to_str(很差判定)
					get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/失误/数值").text=var_to_str(失误判定)
					get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/漏击/数值").text=var_to_str(漏击判定)
					$'/root/根场景/根界面/游戏界面'._on_退出_button_down()
					break
				break
#	print($'../CameraLight/AudioStreamPlayer'.time)
	pass
var 轨道旧位置=0
func 音符生成(物件):
	var 轨道位置=int(ceil(randf()*get_node("/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/轨道数量/滑块").value-1))
	#此循环保证物件不连续生成
	if $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/物件连续/选项勾选盒'.button_pressed==false:
		while 轨道位置==轨道旧位置:
			#如果轨道数为1时跳出死循环，不处理游戏会卡死!!!
			if get_node("/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/轨道数量/滑块").value==1.0:
				break
			else:
				轨道位置=int(ceil(randf()*get_node("/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/轨道数量/滑块").value-1))
	轨道旧位置=轨道位置
	get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(轨道位置+1)+"/物件区").add_child(物件)
	pass
var 按键组=[KEY_D,KEY_F,KEY_J,KEY_K]
func _ready():
	$'轨道/轨道根节点1'.键盘按键=按键组[0]
	$'轨道/轨道根节点2'.键盘按键=按键组[1]
	$'轨道/轨道根节点3'.键盘按键=按键组[2]
	$'轨道/轨道根节点4'.键盘按键=按键组[3]
	pass
#开始游戏事件
func _input(event):
	if event is InputEventKey:
		$"开始按键/键盘提示文字".show()
		match event.keycode:
			KEY_SPACE:
				if $"开始按键".visible==true&&$'../根界面/加载画面'.visible==false&& not event.pressed:
					开始按钮()
		pass
	else:
		$"开始按键/键盘提示文字".hide()
	pass
