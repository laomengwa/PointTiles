extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/VBoxContainer/进度条.max_value=$'../界面音频/主音频'.stream.get_length()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var 播放时间显示 = ''
	var 播放时间显示分钟=""
	var 播放时间显示秒钟=""
	if floor($'../界面音频/主音频'.get_playback_position()/60)<10.0:
		播放时间显示分钟="0"+("%.0f" %floor($'../界面音频/主音频'.get_playback_position()/60))
	else:
		播放时间显示分钟=("%.0f" %floor($'../界面音频/主音频'.get_playback_position()/60))
	if floor($'../界面音频/主音频'.get_playback_position()-(floor($'../界面音频/主音频'.get_playback_position()/60))*60)<10.0:
		播放时间显示秒钟="0"+("%.0f" %floor($'../界面音频/主音频'.get_playback_position()-(floor($'../界面音频/主音频'.get_playback_position()/60))*60))
	else:
		播放时间显示秒钟=("%.0f" %floor($'../界面音频/主音频'.get_playback_position()-(floor($'../界面音频/主音频'.get_playback_position()/60))*60))
	播放时间显示=播放时间显示分钟+":"+ 播放时间显示秒钟
	$Panel/VBoxContainer/HBoxContainer/时间.text=播放时间显示
	if 进度条拖拽检测==true:
		$Panel/VBoxContainer/进度条.value=$'../界面音频/主音频'.get_playback_position()
	if $'../界面音频/主音频'.get_playback_position()>=$'../界面音频/主音频'.stream.get_length()-0.01:
		$Panel/VBoxContainer/HBoxContainer/状态.text="播放"
		$'../界面音频/主音频'.stop()
	pass


func _on_button_down():
	$'动画'.play("关闭")
	pass # Replace with function body.


func _on_播放器_button_down():
	$'动画'.play("打开")
	pass # Replace with function body.


func 倍度播放(value):
	$Panel/高级选项/标签/数值.text=var_to_str(value)
	$'../界面音频/主音频'.set_pitch_scale(value)
	pass # Replace with function body.


func 高级选项返回():
	$'动画'.play("高级选项关闭")
	pass # Replace with function body.


func 高级选项打开():
	$'动画'.play("高级选项打开")
	pass # Replace with function body.


var 播放停止状态=true
func 停止():
	$'../界面音频/主音频'.stop()
	$Panel/VBoxContainer/HBoxContainer/状态.text="播放"
	播放停止状态=true
	pass # Replace with function body.


func 状态():
	if $'../界面音频/主音频'.playing==false:
		$Panel/VBoxContainer/HBoxContainer/状态.text="暂停"
		if 播放停止状态==true:
			播放停止状态=false
			$'../界面音频/主音频'.play()
		else:
			$'../界面音频/主音频'.set_stream_paused(false)
	else:
		$'../界面音频/主音频'.set_stream_paused(true)
		$Panel/VBoxContainer/HBoxContainer/状态.text="播放"
	pass # Replace with function body.

var 进度条拖拽检测=true
func 进度条(value_changed):
	进度条拖拽检测=value_changed
	$'../界面音频/主音频'.seek($Panel/VBoxContainer/进度条.value)
	pass # Replace with function body.

func _on_timer_timeout():
	#获取系统时间
	$'Panel/VBoxContainer/HBoxContainer2/时间'.text=Time.get_datetime_string_from_system(false,true)
	pass # Replace with function bod


func 进度条开始拖拽():
	进度条拖拽检测=false
	pass # Replace with function body.
