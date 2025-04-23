extends Control
var 竖屏左列表检测:bool = false
var 竖屏界面布局检测:bool = false
var 自动演奏拖拽状态:bool=false
var 暂停时间:int=0

func _process(delta):
	#UI自适应
	#竖屏
	if 全局脚本.游戏开始状态==true:
		if $'../设置/设置选项/视频/视频/界面调整/容器/隐藏界面/勾选盒'.button_pressed==false:
			self.modulate=Color(1,1,1,1)
		else:
			self.modulate=Color(1,1,1,0)
	#if $'/root/根场景/根界面'.size[0] <= 900 * 界面尺寸缩放:
	if 竖屏左列表检测 == false:
		$'../结算画面/界面动画'.play("结算画面收缩")
		竖屏左列表检测 = true
	#横屏（废弃）
	#else:
		#竖屏界面布局检测 = false
		#if 竖屏左列表检测 == true:
			#$'../结算画面/界面动画'.play("结算画面扩张")
			#竖屏左列表检测 = false
	#pass
func 暂停函数():
	$'/root/根场景/视角节点'.控制状态=false
	$游戏界面暂停键/视角控制.button_pressed=false
	$'界面动画'.play("暂停窗口")
	if $'../../视角节点/背景音乐播放节点'.is_playing()==true:
		$'../../视角节点/背景音乐播放节点'.set_stream_paused(true)
		暂停时间=Time.get_ticks_usec()
		if $'/root/根场景/主场景/开始按键/背景音乐计时器'.is_stopped()==false:
			$'/root/根场景/主场景/开始按键/背景音乐计时器'.stop()
	pass

func 继续():
	$'界面动画'.play("暂停窗口关闭")
	pass # Replace with function body.

func 重试():
	全局脚本.游戏开始状态=true
	暂停时间=0
	$/root/根场景/视角节点/MidiPlayer.stop()
	$'/root/根场景/视角节点/背景音乐播放节点'.seek(0)
	$'/root/根场景/视角节点/背景音乐播放节点'.播放时间=0.0
	$'../结算画面'.hide()
	$'../界面动画'.play("加载谱面画面")
	$'/root/根场景/根界面/游戏界面/歌曲循环次数'.hide()
	$"/root/根场景/主场景".游戏界面连击数 = 0
	$"/root/根场景/主场景".最大连击数 = 0
	$"/root/根场景/主场景".游戏界面分数 = 0
	$'/root/根场景/主场景'.声音数据集合=[]
	$"/root/根场景/主场景".判定统计=[0,0,0,0,0,0]
	get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
	$'/root/根场景/根界面/游戏界面/游戏界面进度条'.value=0
	$'/root/根场景/主场景'.清除物件()
	get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
	$"../../主场景/开始按键".show()
	$'../界面动画'.play("加载谱面画面关闭")
	$'../加载画面/加载文字/进度条'.value=100
	$'../游戏菜单'.hide()
	$'../窗口/暂停窗口'.hide()
	$'../窗口遮挡'.hide()
	for 子节点循环 in $'../游戏界面/星星皇冠显示'.get_child_count():
		var 子节点 = $'../游戏界面/星星皇冠显示'.get_child(子节点循环)
		子节点.queue_free()
	$'../游戏界面/星星皇冠显示'.size=Vector2(30*(全局脚本.阶段时间位置.size()-1),40)
	for 循环 in 全局脚本.阶段时间位置.size()-1:
		var 星星贴图=TextureRect.new()
		var 纹理=load("res://纹理/界面/空星.svg")
		星星贴图.set_texture(纹理)
		星星贴图.size=Vector2(30,38)
		星星贴图.position=Vector2(循环*30,0)
		$'../游戏界面/星星皇冠显示'.add_child(星星贴图)
	pass # Replace with function body.

var 游戏暂停设置窗口 = false
func 退出():
	$'/root/根场景/视角节点'.控制状态=false
	$游戏界面暂停键/视角控制.button_pressed=false
	$/root/根场景/视角节点/MidiPlayer.stop()
	游戏暂停设置窗口 = false
	全局脚本.游戏开始状态=false
	$'../界面动画'.play("结算画面")
	$'/root/根场景/主场景'.声音数据集合=[]
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/界面容器/得分").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/精确度/数值").text="%.2f" %float($/root/根场景/主场景.精确度判定)+"%"
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/连击数/数值").text = var_to_str($"/root/根场景/主场景".最大连击数)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/完美/数值").text=var_to_str($"/root/根场景/主场景".判定统计[0])
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/良好/数值").text=var_to_str($"/root/根场景/主场景".判定统计[1])
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/较差/数值").text=var_to_str($"/root/根场景/主场景".判定统计[2])
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/很差/数值").text=var_to_str($"/root/根场景/主场景".判定统计[3])
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/失误/数值").text=var_to_str($"/root/根场景/主场景".判定统计[5])
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/漏击/数值").text=var_to_str($"/root/根场景/主场景".判定统计[4])
	$'/root/根场景/主场景'.清除物件()
	$'/root/根场景/主场景/开始按键'.hide()
	$"调试窗口".hide()
	pass # Replace with function body.

func 设置():
	$'../设置/界面动画'.play('设置界面打开')
	if $'../结算画面'.visible==false:
		$'界面动画'.play("暂停窗口关闭")
		$'../设置/顶栏/顶栏/状态'.text = "游戏中"
	游戏暂停设置窗口 = true
	pass # Replace with function body.


func 返回():
	if 竖屏界面布局检测 == true:
		$'../结算画面/界面动画'.play("结算画面竖屏收缩")
		竖屏界面布局检测= false
	else:
		$'../界面动画'.play("结算画面返回")
		$'/root/根场景/主场景'.清除物件()
		$'../结算画面/左列表/结算/操作区/重试'.show()
		$'../结算画面/左列表/结算/操作区/回放'.size_flags_horizontal=1
		全局脚本.游戏开始状态=false
		#游戏结束后重新播放音乐
		if $'/root/根场景/主场景'.歌曲类型格式==0:
			$'/root/根场景/视角节点/MidiPlayer'.play()
	pass

func 结算排名(选项):
	$'../结算画面/右列表/本地排名'.hide()
	$'../结算画面/右列表/全球排名'.hide()
	$'../结算画面/右列表/地区排名'.hide()
	$'../结算画面/右列表/好友排名'.hide()
	match 选项:
		0:
			$'../结算画面/右列表/本地排名'.show()
		1:
			$'../结算画面/右列表/全球排名'.show()
		2:
			$'../结算画面/右列表/地区排名'.show()
		3:
			$'../结算画面/右列表/好友排名'.show()
	pass # Replace with function body.
func 查看排名按钮():
	$'../结算画面/界面动画'.play("结算画面竖屏扩张")
	竖屏界面布局检测=true
	pass # Replace with function body.
	
func 自动演奏时间轴拖拽(值):
	if 自动演奏拖拽状态==true:
		if $'/root/根场景/视角节点/背景音乐播放节点'.is_playing()==false&&$'/root/根场景/视角节点/背景音乐播放节点'.stream.to_string().find('MP3')>=0||$'/root/根场景/视角节点/背景音乐播放节点'.stream.to_string().find('WAV')>=0||$'/root/根场景/视角节点/背景音乐播放节点'.stream.to_string().find('Ogg')>=0:
			$'/root/根场景/视角节点/背景音乐播放节点'.seek(值)
			$'/root/根场景/视角节点/背景音乐播放节点'.播放时间=值
			$'/root/根场景/视角节点/背景音乐播放节点'.自动位置偏差=0.0
		else:
			$'/root/根场景/视角节点/背景音乐播放节点'.seek(值)
			$'/root/根场景/视角节点/背景音乐播放节点'.自动位置偏差=值
	pass # Replace with function body.
func 时间轴开始拖拽():
	自动演奏拖拽状态=true
	pass # Replace with function body.
func 时间轴拖拽松开(value_changed):
	自动演奏拖拽状态=false
	if $'/root/根场景/视角节点/背景音乐播放节点'.stream.to_string().find('AudioStreamGenerator')>=0:
		$'/root/根场景/视角节点/背景音乐播放节点'.play()
		$'/root/根场景/视角节点/背景音乐播放节点'.真实播放时间=$'/root/根场景/视角节点/背景音乐播放节点'.真实播放时间+(Time.get_ticks_usec()-暂停时间)
	pass # Replace with function body.

func 自动模式视角():
	$'/root/根场景/视角节点'.控制状态=!$'游戏界面暂停键/视角控制'.button_pressed
	$游戏界面暂停键/视角控制.button_pressed=true
	$游戏界面暂停键/视角控制.release_focus()
	pass # Replace with function body.
