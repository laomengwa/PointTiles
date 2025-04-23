extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for 音频输出设备列表 in AudioServer.get_output_device_list():
		$音频/其他/容器/输出设备/选项框.add_item(音频输出设备列表)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func 音频设备(index):
	AudioServer.set_output_device(AudioServer.get_output_device_list()[index])
	pass # Replace with function body.


func 声音字体文件选择():
	$'/root/根场景/根界面/窗口/打开声音字体文件'.show()
	$'/root/根场景/根界面/界面动画'.play("模态窗口遮挡打开")
	print($'/root/根场景/根界面/窗口/打开声音字体文件'.get_line_edit().get_tree_string())
	pass # Replace with function body.


func 打开声音字体文件对话框(path):
	$'/root/根场景/视角节点/MidiPlayer'.soundfont=path
	$'/root/根场景/根界面/设置/设置选项/音频/音频/其他/容器/音源字体文件/文件名'.text=path
	$'/root/根场景/根界面/窗口/打开声音字体文件'.hide()
	$'/root/根场景/根界面/界面动画'.play("模态窗口遮挡关闭")
	pass # Replace with function body.


func 模态窗口遮挡关闭():
	$'/root/根场景/根界面/界面动画'.play("模态窗口遮挡关闭")
	pass # Replace with function body.
