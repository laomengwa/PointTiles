extends BaseButton

func _ready():
	#创建音频总线
	AudioServer.add_bus(17)
	AudioServer.set_bus_name(17,"播放器音频")
	$"../界面音频/主音频".set_bus("播放器音频")
	pass

func _process(帧处理):
	$播放器窗口/播放器/进度条.max_value=$'../界面音频/主音频'.stream.get_length()
	var 播放时间显示 = ''
	var 播放时长显示 = ''
	var 播放时间显示分钟=""
	var 播放时间显示秒钟=""
	var 播放时长显示分钟=""
	var 播放时长显示秒钟=""
	播放时间显示分钟=("%02.0d" %floor($'../界面音频/主音频'.get_playback_position()/60))
	播放时间显示秒钟=("%02.0d" %floor($'../界面音频/主音频'.get_playback_position()-(floor($'../界面音频/主音频'.get_playback_position()/60))*60))
	播放时长显示分钟=("%02.0d" %floor($'../界面音频/主音频'.stream.get_length()/60))
	播放时长显示秒钟=("%02.0d" %floor($'../界面音频/主音频'.stream.get_length()-(floor($'../界面音频/主音频'.stream.get_length()/60))*60))
	播放时间显示=播放时间显示分钟+":"+ 播放时间显示秒钟
	播放时长显示=播放时长显示分钟+":"+ 播放时长显示秒钟
	$播放器窗口/播放器/上行/时间.text=播放时间显示
	$播放器窗口/播放器/上行/时长.text=播放时长显示
	if 进度条拖拽检测==true:
		$播放器窗口/播放器/进度条.value=$'../界面音频/主音频'.get_playback_position()
	if $'../界面音频/主音频'.get_playback_position()>=$'../界面音频/主音频'.stream.get_length()-0.01:
		$播放器窗口/播放器/上行/状态.text="播放"
		$'../界面音频/主音频'.stop()
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
	$'../界面音频/主音频'.stop()
	$播放器窗口/播放器/上行/状态.text="播放"
	$'../界面音频/主音频'.play()
	$'../界面音频/主音频'.set_stream_paused(true)
	pass


func 状态():
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
	if $'../界面音频/主音频'.stream_paused==false:
		$'../界面音频/主音频'.seek($播放器窗口/播放器/进度条.value)
	else:
		$'../界面音频/主音频'.set_stream_paused(false)
		$'../界面音频/主音频'.seek($播放器窗口/播放器/进度条.value)
		$'../界面音频/主音频'.set_stream_paused(true)
	pass

func 时间刷新():
	#获取系统时间
	$'播放器窗口/播放器/下行/时间'.text=Time.get_datetime_string_from_system(false,true)
	pass


func 进度条开始拖拽():
	进度条拖拽检测=false
	pass
