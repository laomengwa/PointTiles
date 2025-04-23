extends ScrollContainer

var 声音字体文件路径:String="res://音乐/TimGM6mb.sf2"
var 音频设备编号:int=0
var 总音量数据:float=1.0
var 乐器音量数据:float=1.0
var 背景音乐数据:float=1.0


func _ready():
	for 音频输出设备列表 in AudioServer.get_output_device_list():
		$音频/其他/容器/输出设备/选项框.add_item(音频输出设备列表)
	pass

func 读取设置数据(配置文件路径):
	var 设置数据=ConfigFile.new()
	var 读取结果=设置数据.load(配置文件路径)
	if 读取结果==OK:
		if 设置数据.has_section("音频"):
			if 设置数据.has_section_key("音频","演奏模式"):
				$"/root/根场景/主场景".音符演奏方式=设置数据.get_value("音频","演奏模式")
			if 设置数据.has_section_key("音频","音频延迟"):
				全局脚本.音频延迟=设置数据.get_value("音频","音频延迟")
			if 设置数据.has_section_key("音频","音频设备"):
				音频设备编号=设置数据.get_value("音频","音频设备")
			if 设置数据.has_section_key("音频","总音量"):
				总音量数据=设置数据.get_value("音频","总音量")
			if 设置数据.has_section_key("音频","乐器音量"):
				乐器音量数据=设置数据.get_value("音频","乐器音量")
			if 设置数据.has_section_key("音频","背景音乐音量"):
				背景音乐数据=设置数据.get_value("音频","背景音乐音量")
			if 设置数据.has_section_key("音频","声音字体文件"):
				声音字体文件路径=设置数据.get_value("音频","声音字体文件")
func 保存设置数据(设置数据):
	设置数据.set_value("音频","演奏模式",$"/root/根场景/主场景".音符演奏方式)
	设置数据.set_value("音频","音频延迟",全局脚本.音频延迟)
	设置数据.set_value("音频","音频设备",音频设备编号)
	设置数据.set_value("音频","总音量",总音量数据)
	设置数据.set_value("音频","乐器音量",乐器音量数据)
	设置数据.set_value("音频","背景音乐音量",背景音乐数据)
	设置数据.set_value("音频","声音字体文件",声音字体文件路径)
func 设置应用():
	#总音量
	$'音频/音量/容器/总音量/滑块'.value=总音量数据
	$'音频/音量/容器/总音量/数值'.text=var_to_str(总音量数据*10)
	#背景音乐音量
	$'音频/音量/容器/背景音乐音量/滑块'.value=背景音乐数据
	$'音频/音量/容器/背景音乐音量/数值'.text=var_to_str(背景音乐数据*10)
	#乐器音效音量
	$'音频/音量/容器/乐器音效/滑块'.value=乐器音量数据
	$'音频/音量/容器/乐器音效/数值'.text=var_to_str(乐器音量数据*10)
	#输出设备
	$'音频/其他/容器/输出设备/选项框'.selected=音频设备编号
	#音频延迟
	$'音频/其他/容器/音频延迟/滑块'.value=全局脚本.音频延迟
	$'音频/其他/容器/音频延迟/数值'.text=var_to_str(int(全局脚本.音频延迟))
	#演奏模式
	$'音频/其他/容器/演奏方式/按钮'.selected=$"/root/根场景/主场景".音符演奏方式
	#音源字体文件
	$'音频/其他/容器/音源字体文件/文件名'.text=声音字体文件路径
	$"/root/根场景/视角节点/MidiPlayer".soundfont=声音字体文件路径
	pass
func 总音量调节(值):
	AudioServer.set_bus_volume_db(0,linear_to_db(值))
	$音频/音量/容器/总音量/数值.text=var_to_str(值*10)
	总音量数据=值
	pass

func 乐器音量调节(值):
	AudioServer.set_bus_volume_db(1,linear_to_db(值))
	$音频/音量/容器/乐器音效/数值.text=var_to_str(值*10)
	乐器音量数据=值
	pass

func 背景音乐音量(值):
	$'../../../界面音频/主音频'.volume_db=linear_to_db(值)
	$音频/音量/容器/背景音乐音量/数值.text=var_to_str(值*10)
	背景音乐数据=值
	pass

func 音频设备(编号):
	AudioServer.set_output_device(AudioServer.get_output_device_list()[编号])
	音频设备编号=编号
	pass


func 声音字体文件选择():
	$'/root/根场景/根界面/窗口/打开声音字体文件'.show()
	$'/root/根场景/根界面/界面动画'.play("模态窗口遮挡打开")
	#print($'/root/根场景/根界面/窗口/打开声音字体文件'.get_line_edit().get_tree_string())
	pass

func 打开声音字体文件对话框(路径):
	$'/root/根场景/视角节点/MidiPlayer'.soundfont=路径
	声音字体文件路径=路径
	$'/root/根场景/根界面/设置/设置选项/音频/音频/其他/容器/音源字体文件/文件名'.text=路径
	$'/root/根场景/根界面/窗口/打开声音字体文件'.hide()
	$'/root/根场景/根界面/界面动画'.play("模态窗口遮挡关闭")
	pass


func 模态窗口遮挡关闭():
	$'/root/根场景/根界面/界面动画'.play("模态窗口遮挡关闭")
	pass


func 音频延迟(值):
	全局脚本.音频延迟=值
	$'/root/根场景/根界面/设置/设置选项/音频/音频/其他/容器/音频延迟/数值'.text=var_to_str(int(值*1000))
	pass


func 音频延迟还原():
	全局脚本.音频延迟=0.0
	$'/root/根场景/根界面/设置/设置选项/音频/音频/其他/容器/音频延迟/滑块'.value=0.0
	$'/root/根场景/根界面/设置/设置选项/音频/音频/其他/容器/音频延迟/数值'.text=var_to_str(0)
	pass

func 物件演奏方式(选项):
	$"/root/根场景/主场景".音符演奏方式=选项
	pass

func 语音音量(值: float) -> void:
	$音频/音量/容器/语音/数值.text=var_to_str(值)+"%"
	pass
