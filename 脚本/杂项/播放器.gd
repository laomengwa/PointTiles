extends BaseButton
var 数码乐谱变速记录:Array=[]
var 电池检测计时器:int=0
var 电池电量:int=100
func _ready():
	#创建音频总线
	AudioServer.add_bus(17)
	AudioServer.set_bus_name(17,"播放器音频")
	$"../界面音频/主音频".set_bus("播放器音频")
	pass

func _process(_帧处理):
	var 播放时间:float=0.0
	var 播放时长:float=0.0
	if $'/root/根场景/视角节点/MidiPlayer'.playing==false:
		播放时间=$'../界面音频/主音频'.get_playback_position()
		播放时长=$'../界面音频/主音频'.stream.get_length()
	else:
		播放时间=播放帧转时间()
		播放时长=播放帧转时间($'/root/根场景/视角节点/MidiPlayer'.track_status.events[len($'/root/根场景/视角节点/MidiPlayer'.track_status.events)-1].time)
	if 进度条拖拽检测==true:
		$播放器窗口/播放器/进度条.value=播放时间
	if 播放时间>=播放时长-0.01:
		$播放器窗口/播放器/上行/状态.text="播放"
		$'../界面音频/主音频'.stop()
	pass
	if $'/root/根场景/视角节点/MidiPlayer'.playing==true&&$'../界面音频/主音频'.playing==true:
		停止()
	$播放器窗口/播放器/进度条.max_value=播放时长
	$播放器窗口/播放器/上行/时间.text=("%02.0d" %floor(播放时间/60))+":"+("%02.0d" %floor(播放时间-(floor(播放时间/60))*60))
	$播放器窗口/播放器/上行/时长.text=("%02.0d" %floor(播放时长/60))+":"+("%02.0d" %floor(播放时长-(floor(播放时长/60))*60))
	pass
	
func 声道平衡设置(值:float)->void:
	var 总线编号=AudioServer.get_bus_index("播放器音频")
	if AudioServer.get_bus_effect(总线编号,1) is not AudioEffectPanner:
		var 音效=AudioEffectPanner.new()
		AudioServer.add_bus_effect(总线编号, 音效, 1)
	else:
		AudioServer.get_bus_effect(总线编号,1).pan=值
	pass
func 人声消除函数()->void:
	var 总线编号=AudioServer.get_bus_index("播放器音频")
	if AudioServer.get_bus_effect(总线编号,2) is not AudioEffectCapture:
		AudioServer.add_bus_effect(总线编号, AudioEffectCapture.new(), 2)
	else:
		var 音效=AudioServer.get_bus_effect(总线编号,2)
		$"../界面音频/主音频/人声消除".音效=音效
		$"../界面音频/主音频/人声消除".人声消除=!$播放器窗口/高级选项/滚动栏/容器/人声消除/人声消除.button_pressed
	pass
func 失真音效()->void:
	var 总线编号=AudioServer.get_bus_index("播放器音频")
	if AudioServer.get_bus_effect(总线编号,1) is not AudioEffectDistortion:
		var 音效=AudioEffectDistortion.new()
		AudioServer.add_bus_effect(总线编号, 音效, 1)
	pass

func 播放器窗口关闭():
	$'动画'.play("关闭")
	pass

func 播放器对话框():
	$'动画'.play("打开")
	pass

func 变速变调() -> void:
	var 总线编号=AudioServer.get_bus_index("播放器音频")
	if AudioServer.get_bus_effect(总线编号,0) is not AudioEffectPitchShift:
		var 音效=AudioEffectPitchShift.new()
		AudioServer.add_bus_effect(总线编号, 音效, 0)
	if $播放器窗口/高级选项/滚动栏/容器/标签/变速变调.button_pressed==true:
		$播放器窗口/高级选项/滚动栏/容器/声调改变.editable=true
		$播放器窗口/高级选项/滚动栏/容器/声调改变.value=1/$播放器窗口/高级选项/滚动栏/容器/歌曲速度.value
		if $播放器窗口/高级选项/滚动栏/容器/声调改变.value!=1.0:
			AudioServer.set_bus_effect_enabled(总线编号,0,true)
		else:
			AudioServer.set_bus_effect_enabled(总线编号,0,false)
		AudioServer.get_bus_effect(总线编号,0).set_pitch_scale(1/$播放器窗口/高级选项/滚动栏/容器/歌曲速度.value)
	else:
		$播放器窗口/高级选项/滚动栏/容器/声调改变.editable=false
		AudioServer.get_bus_effect(总线编号,0).set_pitch_scale(1)
		AudioServer.set_bus_effect_enabled(总线编号,0,false)
	pass # Replace with function body.
func 倍度播放(值):
	if $播放器窗口/高级选项/滚动栏/容器/标签/变速变调.button_pressed==false:
		var 总线编号=AudioServer.get_bus_index("播放器音频")
		if AudioServer.get_bus_effect(总线编号,0) is not AudioEffectPitchShift:
			var 音效=AudioEffectPitchShift.new()
			AudioServer.add_bus_effect(总线编号, 音效, 0)
		$播放器窗口/高级选项/滚动栏/容器/声调改变.value=1/值
		AudioServer.get_bus_effect(总线编号,0).set_pitch_scale(1/值)
	$"播放器窗口/高级选项/滚动栏/容器/标签/数值".text=var_to_str(值)
	$'../界面音频/主音频'.set_pitch_scale(值)
	pass

func 声调改变(值: float) -> void:
	if $播放器窗口/高级选项/滚动栏/容器/标签/变速变调.button_pressed==false:
		var 总线编号=AudioServer.get_bus_index("播放器音频")
		if AudioServer.get_bus_effect(总线编号,0) is not AudioEffectPitchShift:
			var 音效=AudioEffectPitchShift.new()
			AudioServer.add_bus_effect(总线编号, 音效, 0)
		if 值!=1.0:
			AudioServer.get_bus_effect(总线编号,0).set_pitch_scale(值)
			AudioServer.set_bus_effect_enabled(总线编号,0,true)
		else:
			AudioServer.set_bus_effect_enabled(总线编号,0,false)
	$"播放器窗口/高级选项/滚动栏/容器/标签4/数值".text=var_to_str(值)
	pass # Replace with function body.


func 高级选项返回():
	$'动画'.play("高级选项关闭")
	pass


func 高级选项打开():
	$'动画'.play("高级选项打开")
	pass
func 停止():
	if $'/root/根场景/视角节点/MidiPlayer'.playing==false:
		$'../界面音频/主音频'.stop()
		$播放器窗口/播放器/上行/状态.text="播放"
		$'../界面音频/主音频'.play()
		$'../界面音频/主音频'.set_stream_paused(true)
	else:
		$'/root/根场景/视角节点/MidiPlayer'.stop()
	pass


func 状态():
	if $'/root/根场景/视角节点/MidiPlayer'.playing==true:
		$'/root/根场景/视角节点/MidiPlayer'.stop()
		$播放器窗口/播放器/上行/状态.text="播放"
	else:
		if $'../界面音频/主音频'.playing==false:
			$播放器窗口/播放器/上行/状态.text="暂停"
			$'../界面音频/主音频'.play()
			$'../界面音频/主音频'.seek($播放器窗口/播放器/进度条.value)
			$'../界面音频/主音频'.set_stream_paused(false)
		else:
			$'../界面音频/主音频'.set_stream_paused(true)
			$播放器窗口/播放器/上行/状态.text="播放"
		pass

var 进度条拖拽检测=true
func 进度条(值):
	进度条拖拽检测=值
	if $'/root/根场景/视角节点/MidiPlayer'.playing==false:
		if $'../界面音频/主音频'.stream_paused==false:
			$'../界面音频/主音频'.seek($播放器窗口/播放器/进度条.value)
		else:
			$'../界面音频/主音频'.set_stream_paused(false)
			$'../界面音频/主音频'.seek($播放器窗口/播放器/进度条.value)
			$'../界面音频/主音频'.set_stream_paused(true)
	else:
		$'/root/根场景/视角节点/MidiPlayer'.seek(时间转播放帧($播放器窗口/播放器/进度条.value))
	pass

func 时间刷新():
	#获取系统时间
	$'播放器窗口/播放器/下行/时间'.text=Time.get_datetime_string_from_system(false,true)
	
	if 电池检测计时器>=60:
		电池检测计时器=0
	if 电池检测计时器==0:
		if OS.get_name()=="Android":
			#获取电池电量
			var 电池管理类=JavaClassWrapper.wrap("android.os.BatteryManager")
			if 电池管理类.EXTRA_PRESENT=="present":
				var 安卓电池电量=电池管理类.EXTRA_LEVEL
				$'播放器窗口/播放器/下行/设备电量/电池电量'.value=安卓电池电量
				电池电量=安卓电池电量
				$'播放器窗口/播放器/下行/设备电量'.show()
			else:
				$'播放器窗口/播放器/下行/设备电量'.hide()
			pass
		elif OS.get_name()=="Linux":
			var 脚本运行结果 = []
			OS.execute("ls",["/sys/class/power_supply"],脚本运行结果)
			if 脚本运行结果[0].find("BAT")==-1:
				$'播放器窗口/播放器/下行/设备电量'.hide()
			else:
				OS.execute("cat",["/sys/class/power_supply/BAT0/capacity"],脚本运行结果)
				$'播放器窗口/播放器/下行/设备电量/电池电量'.value=int(脚本运行结果[1])
				$'播放器窗口/播放器/下行/设备电量'.show()
				if 电池电量>=15 && int(脚本运行结果[1])<15:
					全局脚本.发送通知("设备电池电量提示","设备电池电量低于15%。")
				if 电池电量>=5 && int(脚本运行结果[1])<5:
					全局脚本.发送通知("设备电池电量警告","设备电池电量低于5%，你的游戏可能随时中断，请及时充电！")
				电池电量=int(脚本运行结果[1])
	电池检测计时器+=1
	pass

func 进度条开始拖拽():
	进度条拖拽检测=false
	pass

func 时间转播放帧(真实时间:float)->float:
	var 播放帧:float=0.0
	for 循环 in 数码乐谱变速记录.size():
		if 真实时间>=播放帧转时间(数码乐谱变速记录[循环].时刻):
			播放帧=(真实时间-数码乐谱变速记录[循环].变速差)*(1000000.0*$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase)/数码乐谱变速记录[循环].速度
			break
	return 播放帧
	
func 播放帧转时间(播放帧:float=$'/root/根场景/视角节点/MidiPlayer'.position)->float:
	var 真实时间:float=0.0
	for 变速循环 in 数码乐谱变速记录.size():
		if 播放帧>=数码乐谱变速记录[变速循环].时刻:
			真实时间=(播放帧*(float(数码乐谱变速记录[变速循环].速度)/(1000000.0*$'/root/根场景/视角节点/MidiPlayer'.smf_data.timebase)))-数码乐谱变速记录[变速循环].变速差
	return 真实时间
