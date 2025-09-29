extends Control
var 竖屏左列表检测:bool = false
var 竖屏界面布局检测:bool = false
var 自动演奏拖拽状态:bool=false
var 暂停时间:int=0
var 游戏暂停设置窗口:bool = false
var 文件路径:String
var 当前歌曲名称:String
var 合辑名称:String="内置"
var 删除记录计时:bool=false
var 当前删除时间:int=0
var 顺序排名判定:bool=false
var 排名选择状态:bool=false
#0号元素表示要播放的音阶元素编号
var 删除记录音效:Array=[1,60,62,64,65,67,69,71,72]
func _process(_帧处理):
	if 删除记录计时==true:
		$"../窗口/清除本地记录/容器/表格/删除提示".value=float(Time.get_ticks_msec()-当前删除时间)/2000
		if Time.get_ticks_msec()-当前删除时间>250*(删除记录音效[0]):
			if 删除记录音效[0]<=8:
				var 按下=InputEventMIDI.new()
				按下.channel=0
				按下.pitch=删除记录音效[删除记录音效[0]]
				按下.velocity=127
				按下.instrument=0
				按下.message=MIDI_MESSAGE_NOTE_ON
				$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(按下)
			if 删除记录音效[0]>1:
				var 松开=InputEventMIDI.new()
				松开.channel=0
				松开.pitch=删除记录音效[删除记录音效[0]-1]
				松开.velocity=127
				松开.instrument=0
				松开.message=MIDI_MESSAGE_NOTE_OFF
				$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(松开)
			删除记录音效[0]+=1
		if Time.get_ticks_msec()-当前删除时间>2000:
			删除记录音效[0]=1
			结算记录(true)
			全局脚本.发送通知("删除记录成功","你的本地记录已经永久消失")
			var 松开=InputEventMIDI.new()
			松开.channel=0
			松开.pitch=删除记录音效[8]
			松开.velocity=127
			松开.instrument=0
			松开.message=MIDI_MESSAGE_NOTE_OFF
			删除记录计时=false
			$'../游戏菜单/界面左列表/界面动画'.play("警告窗口关闭")
			$'../游戏菜单'.读取成绩内容($"/root/根场景/主场景".歌曲类型格式,合辑名称,当前歌曲名称)
			$"../结算画面/右列表/底栏/滚动/表格/逆向排序".show()
			$"../结算画面/右列表/底栏/滚动/表格/筛选".show()
			$"../结算画面/右列表/底栏/滚动/表格/清除本地成绩".hide()
			$"../结算画面/右列表/底栏/滚动/表格/选择".text="选择"
			排名选择状态=false
			pass
		pass
	#UI自适应
	#竖屏
	if 全局脚本.游戏开始状态==true:
		if $'../设置/设置选项/界面/界面/界面调整/容器/隐藏界面/勾选盒'.button_pressed==false:
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

func 结算记录(删除记录:bool=false):
	var 成绩内容=JSON.parse_string(FileAccess.open(文件路径, FileAccess.READ).get_as_text())
	if 成绩内容!=null:
		if 成绩内容.has("正式歌曲成绩")==false:
			成绩内容.set("正式歌曲成绩",{})
		if 成绩内容.has("传统歌曲成绩")==false:
			成绩内容.set("传统歌曲成绩",{})
		if 成绩内容.has("特殊玩法成绩")==false:
			成绩内容.set("特殊玩法成绩",{})
		var 二级成绩内容:Dictionary
		match $"/root/根场景/主场景".歌曲类型格式:
			0:
				二级成绩内容=成绩内容.正式歌曲成绩
			1:
				二级成绩内容=成绩内容.传统歌曲成绩
		if 二级成绩内容.has(合辑名称)==false:
			二级成绩内容.set(合辑名称,{})
		if 二级成绩内容.get(合辑名称).has(当前歌曲名称)==false:
			二级成绩内容.get(合辑名称).set(当前歌曲名称,[])
		if 删除记录==false:
			if $"/root/根场景/主场景".自动模式==false&&$"/root/根场景/主场景".游戏界面分数!=0:
				var 详细内容:Dictionary={
					"分数":int($"/root/根场景/主场景".游戏界面分数),
					"精确度":$/root/根场景/主场景.精确度判定,
					"最大连击数":int($"/root/根场景/主场景".最大连击数),
					"判定详细":$"/root/根场景/主场景".判定统计,
					"最快手速":$"/root/根场景/主场景".最快手速,
					"无瑕度":$"/root/根场景/主场景".无瑕度,
					"获得段位":int(0),
					"全连击":true,
					"游玩输入设备":0,
					"歌曲循环次数":1,
					"等级评价":"甲级",
					"游玩时间":Time.get_unix_time_from_system()
				}
				二级成绩内容.get(合辑名称).get(当前歌曲名称).push_back(详细内容)
		else:
			#删除记录
			for 子节点循环 in $'../结算画面/右列表/本地排名/表格/容器/排名表'.get_child_count():
				var 子节点 = $'../结算画面/右列表/本地排名/表格/容器/排名表'.get_child(子节点循环)
				var 指针:int=0
				while 指针<二级成绩内容.get(合辑名称).get(当前歌曲名称).size():
					if 子节点.成绩数据==二级成绩内容.get(合辑名称).get(当前歌曲名称)[指针]&&子节点.被选择状态==true:
						二级成绩内容.get(合辑名称).get(当前歌曲名称).remove_at(指针)
					else:
						指针+=1
		match $"/root/根场景/主场景".歌曲类型格式:
			0:
				成绩内容.正式歌曲成绩=二级成绩内容
			1:
				成绩内容.传统歌曲成绩=二级成绩内容
		var 文件=FileAccess.open(文件路径, FileAccess.WRITE)
		文件.store_line(JSON.stringify(成绩内容))
		文件.close()
		pass
	else:
		保存记录失败()
		pass
func 保存记录失败()->void:
	全局脚本.发送通知("保存记录失败","请检查文件访问权限是否正确。")
	pass
func 暂停():
	if $"界面动画".is_playing()==false:
		$'/root/根场景/视角节点'.控制状态=false
		$游戏界面暂停键/视角控制.button_pressed=false
		$"倒计时/动画".stop()
		$"倒计时".hide()
		$"倒计时/计时器".stop()
		$'界面动画'.play("暂停窗口")
		if $'../../视角节点/背景音乐播放节点'.is_playing()==true:
			$'../../视角节点/背景音乐播放节点'.set_stream_paused(true)
			暂停时间=Time.get_ticks_usec()
			if $'/root/根场景/主场景/开始按键/背景音乐计时器'.is_stopped()==false:
				$'/root/根场景/主场景/开始按键/背景音乐计时器'.stop()
	pass

func 继续():
	$'界面动画'.play("暂停窗口关闭")
	if $'/root/根场景/主场景/开始按键'.visible==false:
		$"/root/根场景/主场景".音符输入事件(52,0,127,9,MIDI_MESSAGE_NOTE_ON)
		$"倒计时/动画".play("倒计时")
		$"倒计时/计时器".start(0)
	pass # Replace with function body.

func 重试():
	$"/root/根场景/视角节点".恢复摄像机状态()
	全局脚本.游戏开始状态=true
	暂停时间=0
	if $'../游戏菜单/歌曲信息/歌曲信息/容器/自动演奏/选项勾选盒'.button_pressed==true:
		$'../游戏界面/历史成绩/标签/自动'.show()
		$'../游戏界面/自动演奏时间轴'.show()
		全局脚本.发送通知("自动演奏已启用","本次游玩将不记录成绩。")
		$"游戏界面暂停键/视角控制".show()
	else:
		$"游戏界面暂停键/视角控制".hide()
	$"/root/根场景/主场景".开始按钮位置变更()
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
	get_node("/root/根场景/根界面/游戏界面/详细信息/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
	$'/root/根场景/根界面/游戏界面/状态信息/游戏界面进度条'.value=0
	$'/root/根场景/主场景'.清除物件()
	get_node("/root/根场景/根界面/游戏界面/状态信息/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
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
	for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
		var 子节点 = $'/root/根场景/主场景/轨道'.get_child(子节点循环)
		子节点.get_node("物件区").position[1]=0
	for 子节点循环 in $'/root/根场景/主场景/无轨'.get_child_count():
		var 子节点 = $'/root/根场景/主场景/无轨'.get_child(子节点循环)
		子节点.get_node("物件区").position[1]=0
	#重置
	for 循环 in $"/root/根场景/主场景/无轨".物件编号表.size():
		$"/root/根场景/主场景/无轨".物件编号表[循环].物件节点.音符消除状态=false
		$"/root/根场景/主场景/无轨".物件编号表[循环].物件节点.position[1]=100.0
	for 循环 in $"/root/根场景/主场景/无轨".轨道编号表.size()-1:
		if $"/root/根场景/主场景/无轨".轨道编号表[循环+1].轨道节点.get_parent()!=null:
			$"/root/根场景/主场景/无轨".remove_child($"/root/根场景/主场景/无轨".轨道编号表[循环+1].轨道节点)
	if $'/root/根场景/主场景'.歌曲类型格式==2:
		$'/root/根场景/主场景'.音频延迟=0.0
		$'/root/根场景/主场景'.数码乐谱播放时间=0.0
		$'/root/根场景/主场景/轨道'.初始化()
		pass
	$'/root/根场景/视角节点/背景音乐播放节点'.播放时间=0
	$'/root/根场景/视角节点/背景音乐播放节点'.自动位置偏差=0.0
	if $"/root/根场景/主场景".歌曲类型格式==0:
		$'/root/根场景/视角节点/MidiPlayer'._stop_all_notes()
		$"/root/根场景/主场景".时间跳转(0)
		$"/root/根场景/主场景".数码乐谱播放时间=0
		$"/root/根场景/主场景".数码事件指针=0
		$"/root/根场景/主场景".物件摆放历史=0
		$"/root/根场景/主场景".轨道摆放指针=0
		for 轨道循环 in $'/root/根场景/视角节点/MidiPlayer'.smf_data.tracks.size():
			$"/root/根场景/主场景".数码文件指针[轨道循环]=0
	pass # Replace with function body.

func 退出():
	$'/root/根场景/视角节点'.控制状态=false
	$游戏界面暂停键/视角控制.button_pressed=false
	$/root/根场景/视角节点/MidiPlayer.stop()
	游戏暂停设置窗口 = false
	全局脚本.游戏开始状态=false
	$'../界面动画'.play("结算画面")
	$"../结算画面/顶栏/节点/顶栏".text="结算"
	$'/root/根场景/主场景'.声音数据集合=[]
	var 无瑕度:float=0
	for 循环 in $"/root/根场景/主场景".无瑕度判定组.size():
		无瑕度+=absf($"/root/根场景/主场景".无瑕度判定组[循环])
		#print($"/root/根场景/主场景".无瑕度判定组[循环])
	无瑕度=无瑕度*1000/$"/root/根场景/主场景".无瑕度判定组.size()
	if is_nan(无瑕度):
		无瑕度=0.0
	$"/root/根场景/主场景".无瑕度=无瑕度
	$'/root/根场景/主场景'.清除物件()
	$'/root/根场景/主场景/开始按键'.hide()
	$"../窗口/调试窗口".hide()
	结算记录()
	$'../游戏菜单'.读取成绩内容($"/root/根场景/主场景".歌曲类型格式,合辑名称,当前歌曲名称)
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/界面容器/得分".text = var_to_str($"/root/根场景/主场景".游戏界面分数)
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/精确度/数值".text="%.2f" %float($/root/根场景/主场景.精确度判定)+"%"
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/连击数/数值".text = var_to_str($"/root/根场景/主场景".最大连击数)
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/完美/数值".text=var_to_str($"/root/根场景/主场景".判定统计[0])
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/良好/数值".text=var_to_str($"/root/根场景/主场景".判定统计[1])
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/较差/数值".text=var_to_str($"/root/根场景/主场景".判定统计[2])
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/很差/数值".text=var_to_str($"/root/根场景/主场景".判定统计[3])
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/失误/数值".text=var_to_str($"/root/根场景/主场景".判定统计[5])
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/漏击/数值".text=var_to_str($"/root/根场景/主场景".判定统计[4])
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/无瑕度/数值".text="%.2f" %float(无瑕度)
	$"/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/速度/数值".text="%.3f" %float($"/root/根场景/主场景".最快手速)
	#该代码用于轨道物件区节点进行归位处理
	for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
		var 子节点 = $'/root/根场景/主场景/轨道'.get_child(子节点循环)
		子节点.get_node("物件区").position[1]=0
	pass # Replace with function body.

func 设置():
	$'../设置/界面动画'.play('设置界面打开')
	if $'../结算画面'.visible==false:
		$'界面动画'.play("暂停窗口关闭")
		$'../设置/顶栏/顶栏/状态'.text = "游戏中"
	游戏暂停设置窗口 = true
	pass # Replace with function body.


func 返回():
	#更新成绩内容
	$"/root/根场景/视角节点".恢复摄像机状态()
	if $'../结算画面/右列表/底栏/滚动/表格/清除本地成绩'.visible==true:
		记录选择()
	$"../结算画面/顶栏/节点/顶栏".text="结算"
	$'../游戏菜单'.读取成绩内容($"/root/根场景/主场景".歌曲类型格式,合辑名称,当前歌曲名称)
	if 竖屏界面布局检测 == true:
		$'../结算画面/界面动画'.play("结算画面竖屏收缩")
		竖屏界面布局检测= false
	else:
		$'../界面动画'.play("结算画面返回")
		$'/root/根场景/主场景'.清除物件()
		$'../结算画面/左列表/结算/操作区/重试'.show()
		$'../结算画面/左列表/结算/操作区/回放'.size_flags_horizontal=1
		全局脚本.游戏开始状态=false
		print($"/root/根场景/主场景/无轨".轨道编号表)
		for 循环 in $"/root/根场景/主场景/无轨".轨道编号表.size()-1:
			if $"/root/根场景/主场景/无轨".轨道编号表[循环+1].轨道节点.get_parent()!=null:
				$"/root/根场景/主场景/无轨".remove_child($"/root/根场景/主场景/无轨".轨道编号表[循环+1].轨道节点)
		#游戏结束后重新播放音乐
		if $'/root/根场景/主场景'.歌曲类型格式==0&&$'/root/根场景/视角节点/MidiPlayer'.playing==false:
			$'/root/根场景/视角节点/MidiPlayer'.play()
	pass

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
		if $'/root/根场景/主场景'.歌曲类型格式==0:
			$'/root/根场景/主场景'.时间跳转(值)
	pass # Replace with function body.
func 时间轴开始拖拽():
	自动演奏拖拽状态=true
	pass # Replace with function body.
func 时间轴拖拽松开(_值):
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

func 删除记录按下()->void:
	删除记录计时=true
	当前删除时间=Time.get_ticks_msec()
	pass
func 即将清除成绩() -> void:
	$'../游戏菜单/界面左列表/界面动画'.play("删除记录警告窗口")
	pass
func 取消删除记录() -> void:
	删除记录计时=false
	if 删除记录音效[0]>1:
		var 松开=InputEventMIDI.new()
		松开.channel=0
		松开.pitch=删除记录音效[删除记录音效[0]-1]
		松开.velocity=127
		松开.instrument=0
		松开.message=MIDI_MESSAGE_NOTE_OFF
		$'/root/根场景/视角节点/MidiPlayer'.receive_raw_midi_message(松开)
	删除记录音效[0]=1
	$"../窗口/清除本地记录/容器/表格/删除提示".value=0
	pass
func 记录选择() -> void:
	if 排名选择状态==false:
		$"../结算画面/右列表/底栏/滚动/表格/逆向排序".hide()
		$"../结算画面/右列表/底栏/滚动/表格/筛选".hide()
		$"../结算画面/右列表/底栏/滚动/表格/清除本地成绩".show()
		$"../结算画面/右列表/底栏/滚动/表格/选择".text="取消"
		排名选择状态=true
	else:
		$"../结算画面/右列表/底栏/滚动/表格/逆向排序".show()
		$"../结算画面/右列表/底栏/滚动/表格/筛选".show()
		$"../结算画面/右列表/底栏/滚动/表格/清除本地成绩".hide()
		$"../结算画面/右列表/底栏/滚动/表格/选择".text="选择"
		排名选择状态=false
	for 子节点循环 in $'../结算画面/右列表/本地排名/表格/容器/排名表'.get_child_count():
		var 子节点 = $'../结算画面/右列表/本地排名/表格/容器/排名表'.get_child(子节点循环)
		子节点.get_node("卡片/选择框").visible=排名选择状态
	pass # Replace with function body.

func 排名更改(选项: int) -> void:
	$'../游戏菜单'.读取成绩内容($"/root/根场景/主场景".歌曲类型格式,合辑名称,当前歌曲名称,选项,顺序排名判定)
	pass # Replace with function body.

func 逆向排名排序() -> void:
	$"../结算画面/右列表/底栏/滚动/表格/选择".text="选择"
	排名选择状态=false
	if 顺序排名判定==false:
		顺序排名判定=true
		$"../结算画面/右列表/底栏/滚动/表格/逆向排序".text="顺序"
	else:
		顺序排名判定=false
		$"../结算画面/右列表/底栏/滚动/表格/逆向排序".text="逆序"
	$'../游戏菜单'.读取成绩内容($"/root/根场景/主场景".歌曲类型格式,合辑名称,当前歌曲名称,$"../结算画面/右列表/底栏/滚动/表格/筛选".selected,顺序排名判定)
	pass # Replace with function body.

func 本地排名() -> void:
	$'../结算画面/右列表/全球排名'.hide()
	$'../结算画面/右列表/地区排名'.hide()
	$'../结算画面/右列表/好友排名'.hide()
	$'../结算画面/右列表/本地排名'.show()
	$'../结算画面/右列表/底栏/滚动/表格/选择'.show()
	if $'../结算画面/右列表/底栏/滚动/表格/清除本地成绩'.visible==true:
		记录选择()
	pass # Replace with function body.

func 全球排名() -> void:
	$'../结算画面/右列表/本地排名'.hide()
	$'../结算画面/右列表/全球排名'.show()
	$'../结算画面/右列表/地区排名'.hide()
	$'../结算画面/右列表/好友排名'.hide()
	$'../结算画面/右列表/底栏/滚动/表格/选择'.hide()
	if $'../结算画面/右列表/底栏/滚动/表格/清除本地成绩'.visible==true:
		记录选择()
	pass # Replace with function body.

func 地区排名() -> void:
	$'../结算画面/右列表/本地排名'.hide()
	$'../结算画面/右列表/全球排名'.hide()
	$'../结算画面/右列表/地区排名'.show()
	$'../结算画面/右列表/好友排名'.hide()
	$'../结算画面/右列表/底栏/滚动/表格/选择'.hide()
	if $'../结算画面/右列表/底栏/滚动/表格/清除本地成绩'.visible==true:
		记录选择()
	pass # Replace with function body.

func 好友排名() -> void:
	$'../结算画面/右列表/本地排名'.hide()
	$'../结算画面/右列表/全球排名'.hide()
	$'../结算画面/右列表/地区排名'.hide()
	$'../结算画面/右列表/好友排名'.show()
	$'../结算画面/右列表/底栏/滚动/表格/选择'.hide()
	if $'../结算画面/右列表/底栏/滚动/表格/清除本地成绩'.visible==true:
		记录选择()
	pass

func 游戏失败检测(动画名: StringName) -> void:
	if 动画名=="游戏失败":
		$"/root/根场景/主场景".音符输入事件(48,0,127,0,MIDI_MESSAGE_NOTE_OFF)
		$"/root/根场景/主场景".音符输入事件(50,0,127,0,MIDI_MESSAGE_NOTE_OFF)
		$"/root/根场景/主场景".音符输入事件(52,0,127,0,MIDI_MESSAGE_NOTE_OFF)
		退出()
		pass
	pass


func 暂停倒计时结束(_动画名: StringName) -> void:
	$"倒计时/计时器".stop()
	$'/root/根场景/视角节点/背景音乐播放节点'.set_stream_paused(false)
	$'/root/根场景/视角节点/背景音乐播放节点'.真实播放时间=$'/root/根场景/视角节点/背景音乐播放节点'.真实播放时间+(Time.get_ticks_usec()-$'/root/根场景/根界面/游戏界面'.暂停时间)
	$"/root/根场景/主场景".音符输入事件(52,0,127,9,MIDI_MESSAGE_NOTE_OFF)
	pass # Replace with function body.

func 暂停倒计时音效() -> void:
	$"/root/根场景/主场景".音符输入事件(52,0,127,9,MIDI_MESSAGE_NOTE_OFF)
	$"/root/根场景/主场景".音符输入事件(52,0,127,9,MIDI_MESSAGE_NOTE_ON)
	pass # Replace with function body.
