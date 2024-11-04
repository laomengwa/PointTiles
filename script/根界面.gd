extends Control
@onready var 歌曲卡片场景=preload('res://scene/歌曲卡片.tscn')
#这个变量检测界面是否处在竖屏状态，如果为真就是竖屏状态，否则为横屏状态
var 界面宽度检测 = false
#这个变量检测竖屏状态下详细页面的状态，如果为真就是详细页面，否则为选歌列表
var 竖屏界面布局检测 = false
var 对象谱面文件读取 = ""
var 谱面每分钟节拍:Array = []
var 谱面基础节拍:Array = []

var 数码乐谱文件路径:String=""
var 数码乐谱父文件夹路径:String=""

func _ready():
	#传统谱面列表读取
	if $'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.get_child_count() <= 1:
		#检测歌曲列表文件是否存在
		if FileAccess.file_exists("res://music/json_chart/csv_config/music_json")==true:
			$'../游戏菜单/界面左列表/容器/搜索栏/输入框'.editable=false
			$'../游戏菜单/界面左列表/容器/搜索栏/输入框'.placeholder_text="歌曲列表加载状态下不能搜索"
			$'../游戏菜单/界面左列表/容器/搜索栏/输入框'.tooltip_text="歌曲列表加载状态下不能搜索"
			#循环level文件
			for 循环 in GlobalScript.传统文件列表[1].size()-1:
				await get_tree().create_timer(0.0).timeout
				$'../游戏菜单/界面左列表/容器/旧式谱面列表/列表/加载提示标签/进度'.text=var_to_str(循环+1)+"/"+var_to_str(GlobalScript.传统文件列表[1].size())
				#循环music_json文件
				for 对象循环 in GlobalScript.传统文件列表[0].size()-1:
					if GlobalScript.传统文件列表[1][循环+1].Mid == GlobalScript.传统文件列表[0][对象循环].Mid:
						var 传统歌曲卡片=歌曲卡片场景.instantiate()
						传统歌曲卡片.get_node("容器/容器/歌曲名").text = GlobalScript.传统文件列表[0][对象循环].MusicJson
						传统歌曲卡片.get_node("容器/容器/艺术家").text = GlobalScript.传统文件列表[0][对象循环].Musician
						传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str(循环+1)
						var 准备按钮 = Button.new()
						准备按钮.text = "准备"
						准备按钮.custom_minimum_size=Vector2(100,0)
						var 封面歌曲名=GlobalScript.传统文件列表[0][对象循环].MusicJson
						var 封面艺术家=GlobalScript.传统文件列表[0][对象循环].Musician
						var 临时谱面歌曲速度=GlobalScript.传统文件列表[0]
						var 谱面歌曲速度循环=对象循环
						准备按钮.pressed.connect(歌曲卡片按钮按下.bind(封面歌曲名,封面艺术家,临时谱面歌曲速度,谱面歌曲速度循环))
						#设置卡片头纹理
						if GlobalScript.传统文件列表[1][循环+1].MusicCard!="":
							var 卡片头纹理路径:String="res://music/json_chart/card_image/"+GlobalScript.传统文件列表[1][循环+1].MusicCard+".png"
							if FileAccess.file_exists(卡片头纹理路径)==true:
								var 卡片头纹理=load(卡片头纹理路径)
								传统歌曲卡片.get_node("容器/卡片头").set_texture(卡片头纹理)
						传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
						$'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.add_child(传统歌曲卡片)
						传统歌曲卡片.get_node("容器/容器/成绩段位/收藏").pressed.connect(歌曲收藏按钮按下.bind(传统歌曲卡片,准备按钮,封面歌曲名,封面艺术家,临时谱面歌曲速度,谱面歌曲速度循环))
						break
					pass
				pass
			pass
			#删除正在加载歌曲的标签节点
			$'../游戏菜单/界面左列表/容器/搜索栏/输入框'.editable=true
			$'../游戏菜单/界面左列表/容器/搜索栏/输入框'.placeholder_text="输入歌曲名以搜索……"
			$'../游戏菜单/界面左列表/容器/搜索栏/输入框'.tooltip_text="输入歌曲名以搜索……"
			$'../游戏菜单/界面左列表/容器/旧式谱面列表/列表/加载提示标签'.queue_free()
		else:
			var 歌曲无文件提示=Label.new()
			歌曲无文件提示.text="糟糕，找不到歌曲……"
			歌曲无文件提示.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
			歌曲无文件提示.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
			歌曲无文件提示.anchors_preset=15
			$'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.add_child(歌曲无文件提示)
			print("无文件")
		pass
		var 数码乐谱文件路径="res://music/midi_chart/"
		for 文件循环 in DirAccess.get_files_at(数码乐谱文件路径).size():
			#var MIDI文件=FileAccess.open("res://music/midi_chart/"+DirAccess.get_files_at("res://music/midi_chart")[文件循环],FileAccess.READ_WRITE)
			var 传统歌曲卡片=歌曲卡片场景.instantiate()
			传统歌曲卡片.get_node("容器/容器/歌曲名").text = DirAccess.get_files_at(数码乐谱文件路径)[文件循环]
			传统歌曲卡片.get_node("容器/卡片头/编号").text = var_to_str(文件循环+1)
			var 准备按钮 = Button.new()
			准备按钮.text = "准备"
			准备按钮.custom_minimum_size=Vector2(100,0)
			var 封面歌曲名=DirAccess.get_files_at(数码乐谱文件路径)[文件循环]
			传统歌曲卡片.get_node("容器/容器/成绩段位").add_child(准备按钮)
			准备按钮.pressed.connect(数码曲谱卡片按下.bind(数码乐谱文件路径+DirAccess.get_files_at(数码乐谱文件路径)[文件循环],数码乐谱文件路径))
			$'../游戏菜单/界面左列表/容器/数码曲谱列表/列表'.add_child(传统歌曲卡片)
	pass

func _process(delta):
	#UI自适应
	#竖屏
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor:
		if 界面宽度检测 == false:
			$'界面动画'.play("界面缩放")
			界面宽度检测 = true
	#全横屏
	else:
		竖屏界面布局检测 = false
		$'歌曲信息'.offset_left=0
		if 界面宽度检测 == true:
			$'界面动画'.play("界面扩张")
			界面宽度检测 = false
		pass
	pass
func 歌曲收藏按钮按下(组件,按钮,封面歌曲名,封面艺术家,临时谱面歌曲速度,谱面歌曲速度循环):
	if 组件.get_node("容器/容器/成绩段位/收藏").button_pressed==true:
		var 组件复制=组件.duplicate()
		var 按钮复制=按钮.duplicate(DUPLICATE_SIGNALS)
		按钮复制.pressed.connect(歌曲卡片按钮按下.bind(封面歌曲名,封面艺术家,临时谱面歌曲速度,谱面歌曲速度循环))
		组件复制.get_node("容器/容器/成绩段位").add_child(按钮复制)
		$'../游戏菜单/界面左列表/容器/收藏列表/列表'.add_child(组件复制)
	else:
		for 循环 in $'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child_count():
			if $'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child(循环).get_node('容器/卡片头/编号').text==组件.get_node('容器/卡片头/编号').text&&$'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child(循环).get_node('容器/容器/歌曲名').text==组件.get_node('容器/容器/歌曲名').text&&$'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child(循环).get_node('容器/容器/艺术家').text==组件.get_node('容器/容器/艺术家').text:
				$'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child(循环).queue_free()
	pass
func 数码曲谱卡片按下(文件路径,父文件夹路径):
	var 文件大小=FileAccess.open(文件路径,FileAccess.READ).get_length()
	数码乐谱文件路径=文件路径
	数码乐谱父文件夹路径=父文件夹路径
	#检查文件大小
	#如果文件小于1MiB
	if 文件大小<=1048576:
		允许播放乐谱()
	#如果文件小于10MiB（小型黑乐谱）
	elif 文件大小<=10485760:
		$'../窗口/文件过大警告/容器/轻微'.show()
		$'../窗口/文件过大警告/容器/严重'.hide()
		$'../游戏菜单/界面左列表/界面动画'.play("警告窗口")
	#大型黑乐谱
	else:
		$'../窗口/文件过大警告/容器/轻微'.hide()
		$'../窗口/文件过大警告/容器/严重'.show()
		$'../游戏菜单/界面左列表/界面动画'.play("警告窗口")
	pass

func 歌曲卡片按钮按下(封面歌曲名,封面艺术家,临时谱面歌曲速度,谱面歌曲速度循环):
	$'/root/根场景/主场景'.歌曲类型格式=1
	if $'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text=="歌曲选项测试"||$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text=="艺术家测试":
		$'歌曲信息/界面动画'.stop()
		$'歌曲信息/界面动画'.play("文字提示关闭")
	谱面每分钟节拍 = []
	谱面基础节拍 = []
	$'../加载画面/封面/边框/容器/上容器/歌曲名称'.text = 封面歌曲名
	$'../加载画面/封面/边框/容器/下容器/艺术家名称'.text = 封面艺术家
	$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/歌曲名称'.text = 封面歌曲名
	$'../结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/容器/艺术家名称'.text = 封面艺术家
	$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text = 封面歌曲名
	$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text = 封面艺术家
	$'../游戏界面/歌曲信息/容器/歌曲名'.text=封面歌曲名
	$'../游戏界面/歌曲信息/容器/艺术家'.text=封面艺术家
	$'歌曲信息/歌曲信息/容器/详细/表格/容器/谱面类型/文字'.text = "下落式旧格式谱面"
#	var 对象谱面文件路径 = 'user://json_chart/'+封面歌曲名+'.json'
	var 对象谱面文件路径 = 'res://music/json_chart/'+封面歌曲名+'.json'
	#检测json文件是否存在
	if FileAccess.file_exists(对象谱面文件路径)==false:
		#json文件不存在
		$'歌曲信息/界面动画'.stop()
		$'歌曲信息/界面动画'.play("文本提示打开")
		$'歌曲信息/文本/文本提示'.text="糟糕，找不到谱面文件！\n请检查该文件是否存在？\n文件路径:"+对象谱面文件路径
	else:
		#json文件存在
		if $'歌曲信息/文本'.visible==true:
			$'歌曲信息/界面动画'.play("文字提示关闭")
		var 文件大小=FileAccess.open(对象谱面文件路径,FileAccess.READ).get_length()
		var 对象谱面文件 = JSON.parse_string(FileAccess.open(对象谱面文件路径,FileAccess.READ).get_as_text())
		if 对象谱面文件==null:
			#如果解析失败
			$'歌曲信息/界面动画'.stop()
			$'歌曲信息/界面动画'.play("文本提示打开")
			$'歌曲信息/文本/文本提示'.text="糟糕，谱面文件解析错误！\n请检查该文件格式是否正确？\n文件路径:"+对象谱面文件路径
		else:
			#解析成功
			#解析歌曲是否存在对应的音频文件
			var MP3音频文件路径 = 'res://music/json_chart/'+封面歌曲名+'.mp3'
			var WAV音频文件路径 = 'res://music/json_chart/'+封面歌曲名+'.wav'
			var OGG音频文件路径 = 'res://music/json_chart/'+封面歌曲名+'.ogg'
			if FileAccess.file_exists(MP3音频文件路径)==true:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=load(MP3音频文件路径)
			elif FileAccess.file_exists(WAV音频文件路径)==true:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=load(WAV音频文件路径)
			elif FileAccess.file_exists(OGG音频文件路径)==true:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=load(OGG音频文件路径)
			else:
				$'/root/根场景/视角节点/背景音乐播放节点'.stream=AudioStreamGenerator.new()
			对象谱面文件读取 = 对象谱面文件
			if 文件大小/1024 > pow(1024,2):
				$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = ("%.2f" %(float(文件大小)/pow(1024,3)))+"GiB"
			elif 文件大小/1024 > pow(1024,1):
				$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = ("%.2f" %(float(文件大小)/pow(1024,2)))+"MiB"
			elif 文件大小/1024 > pow(1024,0):
				$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = ("%.2f" %(float(文件大小)/1024.0))+"KiB"
			else:
				$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = var_to_str(文件大小)+"B"
			$'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = ""
			$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = ""
			$'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text = ""
			for 对象谱面阶段循环 in 对象谱面文件.musics.size():
				$'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text + var_to_str(对象谱面文件.musics[对象谱面阶段循环].baseBeats)+" "
				$'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text + ("%.3f" %(float(临时谱面歌曲速度[谱面歌曲速度循环+对象谱面阶段循环].BPM)/((对象谱面文件.musics[对象谱面阶段循环].baseBeats)*60)))+" "
				谱面每分钟节拍.push_back(float(临时谱面歌曲速度[谱面歌曲速度循环+对象谱面阶段循环].BPM))
				谱面基础节拍.push_back(对象谱面文件.musics[对象谱面阶段循环].baseBeats)
				#print(临时谱面歌曲速度[谱面歌曲速度循环+对象谱面阶段循环-1].BPM)
				$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text = $'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text +临时谱面歌曲速度[谱面歌曲速度循环+对象谱面阶段循环].BPM+" "
				#print(对象谱面文件.musics[对象谱面阶段循环].scores[0])
	#自适应界面
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor && 界面宽度检测 == true:
		$'界面动画'.play("详细界面扩张")
		竖屏界面布局检测 = true
	#对于挑战赛节拍速度为0时的处理
	for 循环 in 谱面每分钟节拍.size():
		if 谱面每分钟节拍[循环]==0:
			谱面每分钟节拍[循环]=谱面每分钟节拍[0]
	GlobalScript.谱面每分钟节拍=谱面每分钟节拍
	GlobalScript.谱面基础节拍=谱面基础节拍
	pass
const 乐器名称: = ["Acoustic Piano","Bright Piano","Electric Grand Piano","Honky-tonk Piano","Electric Piano","Electric Piano 2","Harpsichord","Clavi","Celesta","Glockenspiel","Musical box","Vibraphone","Marimba","Xylophone","Tubular Bell","Dulcimer","Drawbar Organ","Percussive Organ","Rock Organ","Church organ","Reed organ","Accordion","Harmonica","Tango Accordion","Nylon Guiter","Steel Guiter","Jazz Guiter","Clean Guiter","Muted Guiter","Overdriven Guitar","Distortion Guitar","Guitar harmonics","Acoustic Bass","Finger Bass","Pick Bass","Fretless Bass","Slap Bass 1","Slap Bass 2","Synth Bass 1","Synth Bass 2","Violin","Viola","Cello","Double bass","Tremolo Strings","Pizzicato Strings","Orchestral Harp","Timpani","Strings 1","Strings 2","Synth Strings 1","Synth Strings 2","Voice Aahs","Voice Oohs","Synth Voice","Orchestra Hit","Trumpet","Trombone","Tuba","Muted Trumpet","French horn","Brass Section","Synth Brass 1","Synth Brass 2","Soprano Sax","Alto Sax","Tenor Sax","Baritone Sax","Oboe","English Horn","Bassoon","Clarinet","Piccolo","Flute","Recorder","Pan Flute","Blown Bottle","Shakuhachi","Whistle","Ocarina","Square Lead","Sawtooth Lead","Calliope Lead","Chiff Lead","Charang Lead","Voice Lead","Fifth Lead","Bass & Lead","Fantasia Pad","Warm Pad","Polysynth Pad","Choir Pad","Bowed Pad","Metallic Pad","Halo Pad","Sweep Pad","Rain","Soundtrack","Crystal","Atmosphere","Brightness","Goblins","Echoes","Sci-Fi","Sitar","Banjo","Shamisen","Koto","Kalimba","Bagpipe","Fiddle","Shanai","Tinkle Bell","Agogo","Steel Drums","Woodblock","Taiko Drum","Melodic Tom","Synth Drum","Reverse Cymbal","Guitar Fret Noise","Breath Noise","Seashore","Bird Tweet","Telephone Ring","Helicopter","Applause","Gunshot"]
#开始游戏
func 开始按钮():
	$/root/根场景/视角节点/MidiPlayer.stop()
	$'/root/根场景/根界面/游戏界面/游戏界面进度条'.value=0
	$'/root/根场景/视角节点/背景音乐播放节点'.seek(0)
	$'/root/根场景/视角节点/背景音乐播放节点'.播放时间=0.0
	$'../加载画面/加载文字/进度条'.value=0
	$'../加载画面/加载背景动画'.play("加载谱面画面背景")
	$'../界面动画'.play("加载谱面画面")
	$'/root/根场景/根界面/游戏界面/歌曲循环次数'.hide()
	$'../加载画面/加载文字/进度条'.value=0
	$"/root/根场景/主场景".判定统计=[0,0,0,0,0,0]
	$"/root/根场景/主场景".游戏界面连击数 = 0
	$"/root/根场景/主场景".最大连击数 = 0
	$"/root/根场景/主场景".游戏界面分数 = 0
	$'/root/根场景/主场景/开始按键'.show()
	GlobalScript.游戏开始状态=true
	match $'/root/根场景/主场景'.歌曲类型格式:
		1:
			$"/root/根场景/主场景".谱面阶段=0
			$'/root/根场景/主场景'.声音数据集合=[]
			get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str($"/root/根场景/主场景".游戏界面连击数)
			get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str($"/root/根场景/主场景".游戏界面分数)
			$'../加载画面/加载文字/进度条'.value=5
			##代码逻辑混乱，未来会考虑重构
			var 轨道连接 = {}
			var 轨道物件长度连接 = {}
			var 物件类型 = {}
			var 乐谱声音 = {}
			var 乐器音色 = {}
			var 阶段时间位置=[]
			var 歌曲最大音轨数量 = 0
			#段落循环
			for 对象谱面阶段循环 in 对象谱面文件读取.musics.size():
				#轨道循环
				for 对象谱面音轨循环 in 对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
					#最大轨道数量检查
					if 歌曲最大音轨数量<对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
						歌曲最大音轨数量=对象谱面文件读取.musics[对象谱面阶段循环].scores.size()
			#段落循环
			for 对象谱面阶段循环 in 对象谱面文件读取.musics.size():
				#轨道循环
				var 乐器种类=[]
				for 对象谱面音轨循环 in 对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
					
					#判断轨道所使用的乐器
					#判断备选乐器
					if 对象谱面文件读取.musics[对象谱面阶段循环].has("alternatives"):
						#如果备选乐器为空则读取乐器属性
						if 对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环]==""||对象谱面文件读取.musics[对象谱面阶段循环].instruments[对象谱面音轨循环]!="":
							if 对象谱面文件读取.musics[对象谱面阶段循环].has("instruments"):
								if 乐器名称.has(对象谱面文件读取.musics[对象谱面阶段循环].instruments[对象谱面音轨循环])==true:
									乐器种类.push_back("0,"+var_to_str(乐器名称.find(对象谱面文件读取.musics[对象谱面阶段循环].instruments[对象谱面音轨循环])))
								else:
									match 对象谱面文件读取.musics[对象谱面阶段循环].instruments[对象谱面音轨循环]:
										"piano":
											乐器种类.push_back("0,0")
										"bass":
											乐器种类.push_back("0,32")
										"bass2":
											乐器种类.push_back("0,35")
										"drum":
											乐器种类.push_back("9,0")
										_:
											if 对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环]!="":
												if 乐器名称.has(对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环])==true:
													乐器种类.push_back("0,"+var_to_str(乐器名称.find(对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环])))
												else:
													match 对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环]:
														"piano":
															乐器种类.push_back("0,0")
														"bass":
															乐器种类.push_back("0,32")
														"bass2":
															乐器种类.push_back("0,35")
														"drum":
															乐器种类.push_back("9,0")
														#自定义情况
														_:
															乐器种类.push_back("0,0")
											else:
												乐器种类.push_back("0,0")
						else:
							if 乐器名称.has(对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环])==true:
								乐器种类.push_back("0,"+var_to_str(乐器名称.find(对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环])))
							else:
								match 对象谱面文件读取.musics[对象谱面阶段循环].alternatives[对象谱面音轨循环]:
										"piano":
											乐器种类.push_back("0,0")
										"bass":
											乐器种类.push_back("0,32")
										"bass2":
											乐器种类.push_back("0,35")
										"drum":
											乐器种类.push_back("9,0")
										#自定义情况
										_:
											乐器种类.push_back("0,0")
					else:
						乐器种类.push_back("0,0")
					if 对象谱面音轨循环==0:
						if 对象谱面阶段循环==0:
							阶段时间位置.push_back(0)
						else:
							阶段时间位置.push_back(轨道连接[0][轨道连接[0].size()-1]+轨道物件长度连接[0][轨道物件长度连接[0].size()-1])
					#处理字符串并转为数组
					var 物件 = 对象谱面文件读取.musics[对象谱面阶段循环].scores[对象谱面音轨循环]
					物件=物件.replace(";",",")
					物件=物件.split(",")
					#如果数组结尾不是空子集，则就创建
					if 物件[物件.size()-1]!="":
						物件.push_back("")
					var 物件时长存储=[]
					var 轨道时长积累=[]
					var 段落音符类型=[]
					var 段落乐谱声音=[]
					var 物件时间累积=0
					#轨道内物件循环
					for 物件时间循环 in 物件.size()-1:
						var 物件格式转换=物件[物件时间循环]
						var 物件格式时间计数 = 0
						#统计时间
						物件格式时间计数=物件格式转换.count('H')*256+物件格式转换.count('Q')*256+物件格式转换.count('I')*128+物件格式转换.count('R')*128+物件格式转换.count('J')*64+物件格式转换.count('S')*64+物件格式转换.count('K')*32+物件格式转换.count('T')*32+物件格式转换.count('L')*16+物件格式转换.count('U')*16+物件格式转换.count('M')*8+物件格式转换.count('V')*8+物件格式转换.count('N')*4+物件格式转换.count('W')*4+物件格式转换.count('O')*2+物件格式转换.count('X')*2+物件格式转换.count('P')+物件格式转换.count('Y')+物件格式转换.count('Z')*0
						物件时长存储.push_back(物件格式时间计数)
						物件时间累积 = 物件时间累积+物件格式时间计数
						轨道时长积累.push_back(物件时间累积-物件时长存储[物件时间循环])
						if 物件格式转换.count('(') > 0&&物件格式转换.count(')') > 0:
							段落乐谱声音.push_back(物件格式转换.substr(物件格式转换.find('(')+1,物件格式转换.find(')')-物件格式转换.find('(')-1))
						elif 物件格式转换.count('[') > 0&&物件格式转换.count(']') > 0:
							if 物件格式转换.find('<')<0:
								段落乐谱声音.push_back(物件格式转换.substr(0,物件格式转换.find('[')))
							else:
								段落乐谱声音.push_back(物件格式转换.substr(物件格式转换.find('<')+1,物件格式转换.find('[')-物件格式转换.find('<')-1))
						else:
							段落乐谱声音.push_back("空白")
						#物件类型检测
						if 物件格式转换.count('1<') > 0:
							段落音符类型.push_back("1")
						elif 物件格式转换.count('2<') > 0:
							段落音符类型.push_back("1")
						elif 物件格式转换.count('3<') > 0:
							if 物件格式转换.count('>') > 0:
								段落音符类型.push_back("3>")
							else:
								段落音符类型.push_back("3")
						elif 物件格式转换.count('5<') > 0:
							if 物件格式转换.count('>') > 0:
								段落音符类型.push_back("5>")
							else:
								段落音符类型.push_back("5")
						elif 物件格式转换.count('6<') > 0:
							if 物件格式转换.count('>') > 0:
								段落音符类型.push_back("6>")
							else:
								段落音符类型.push_back("6")
						elif 物件格式转换.count('7<') > 0:
							if 物件格式转换.count('>') > 0:
								段落音符类型.push_back("7>")
							else:
								段落音符类型.push_back("7")
						elif 物件格式转换.count('8<') > 0:
							if 物件格式转换.count('>') > 0:
								段落音符类型.push_back("8>")
							else:
								段落音符类型.push_back("8")
						elif 物件格式转换.count('9<') > 0:
							if 物件格式转换.count('>') > 0:
								段落音符类型.push_back("9>")
							else:
								段落音符类型.push_back("9")
						elif 物件格式转换.count('10<') > 0:
							段落音符类型.push_back("10")
						elif 物件格式转换.count('>') > 0:
							段落音符类型.push_back(">")
						else:
							if 物件格式时间计数>32*谱面基础节拍[对象谱面阶段循环]:
								段落音符类型.push_back("6>")
							else:
								段落音符类型.push_back("1")
					if 对象谱面阶段循环==0:
						轨道连接[对象谱面音轨循环]=轨道时长积累
						物件类型[对象谱面音轨循环]=段落音符类型
						轨道物件长度连接[对象谱面音轨循环]=物件时长存储
						乐谱声音[对象谱面音轨循环]=段落乐谱声音
						#对齐音轨数量，确保每个段落的音轨数量一致
						if 歌曲最大音轨数量>对象谱面文件读取.musics[对象谱面阶段循环].scores.size()&&对象谱面音轨循环==0:
							for 轨道填充循环 in 歌曲最大音轨数量-对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
								轨道连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道连接[0]
								物件类型[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=物件类型[0]
								轨道物件长度连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道物件长度连接[0]
								var 填充空白声音:Array=[]
								for 空白填充 in 乐谱声音[0].size():
									填充空白声音.push_back("空白")
								乐谱声音[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=填充空白声音
					#其他阶段
					else:
						for 轨道连接循环 in 轨道时长积累.size():
							轨道时长积累[轨道连接循环]=轨道连接[对象谱面音轨循环][轨道连接[对象谱面音轨循环].size()-1]+轨道物件长度连接[对象谱面音轨循环][轨道物件长度连接[对象谱面音轨循环].size()-1]+轨道时长积累[轨道连接循环]
						轨道连接[对象谱面音轨循环]=轨道连接[对象谱面音轨循环]+轨道时长积累
						物件类型[对象谱面音轨循环]=物件类型[对象谱面音轨循环]+段落音符类型
						轨道物件长度连接[对象谱面音轨循环]=轨道物件长度连接[对象谱面音轨循环]+物件时长存储
						乐谱声音[对象谱面音轨循环]=乐谱声音[对象谱面音轨循环]+段落乐谱声音
						#对齐音轨数量，确保每个段落的音轨数量一致
						if 歌曲最大音轨数量>对象谱面文件读取.musics[对象谱面阶段循环].scores.size()&&对象谱面音轨循环==0:
							for 轨道填充循环 in 歌曲最大音轨数量-对象谱面文件读取.musics[对象谱面阶段循环].scores.size():
								轨道连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+轨道连接[0]
								物件类型[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=物件类型[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+物件类型[0]
								轨道物件长度连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=轨道物件长度连接[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+轨道物件长度连接[0]
								var 填充空白声音:Array=[]
								for 空白填充 in 乐谱声音[0].size():
									填充空白声音.push_back("空白")
								乐谱声音[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]=乐谱声音[对象谱面文件读取.musics[对象谱面阶段循环].scores.size()+轨道填充循环]+填充空白声音
						if 对象谱面阶段循环==对象谱面文件读取.musics.size()-1 && 对象谱面音轨循环==0:
							阶段时间位置.push_back(轨道连接[0][轨道连接[0].size()-1]+轨道物件长度连接[0][轨道物件长度连接[0].size()-1])
					乐器音色[对象谱面阶段循环]=乐器种类
				pass
				$'../加载画面/加载文字/进度条'.value=(20*(对象谱面阶段循环/对象谱面文件读取.musics.size()))+5
			pass
			GlobalScript.乐器音色=乐器音色
			GlobalScript.物件总时间=轨道连接
			GlobalScript.物件时长=轨道物件长度连接
			GlobalScript.物件类型=物件类型
			GlobalScript.阶段时间位置=阶段时间位置
			GlobalScript.对象文件乐谱声音=乐谱声音
			for 子节点循环 in $'../游戏界面/星星皇冠显示'.get_child_count():
				var 子节点 = $'../游戏界面/星星皇冠显示'.get_child(子节点循环)
				子节点.queue_free()
			$'../游戏界面/星星皇冠显示'.size=Vector2(30*对象谱面文件读取.musics.size(),40)
			for 循环 in 对象谱面文件读取.musics.size():
				var 星星贴图=TextureRect.new()
				var 纹理=load("res://texture/gui/start_empty.svg")
				星星贴图.set_texture(纹理)
				星星贴图.size=Vector2(30,38)
				星星贴图.position=Vector2(循环*30,0)
				$'../游戏界面/星星皇冠显示'.add_child(星星贴图)
		0:
			$'/root/根场景/主场景'.音频延迟=0.0
			$'/root/根场景/主场景'.数码乐谱播放时间=0.0
			$'/root/根场景/主场景'.数码音符生成时间=0.0
			$'/root/根场景/主场景'.数码文件指针=[]
			$'/root/根场景/主场景'.音符生成指针=[]
			$'/root/根场景/主场景'.数码乐谱音色=[]
			for 循环 in GlobalScript.数码乐谱文件数据.tracks.size():
				$'/root/根场景/主场景'.数码文件指针.push_back(0)
				$'/root/根场景/主场景'.音符生成指针.push_back(0)
				$'/root/根场景/主场景'.数码乐谱音色.push_back(0)
			for 事件块 in GlobalScript.数码乐谱文件数据.tracks[0].events:
				var 通道组:Array[Dictionary] = []
				for 循环 in range(16):
					通道组.append({ "通道编号": 循环, "音色库": 0, })
				var 通道编号:int = 事件块.channel_number
				var 通道 = 通道组[通道编号]
				var 时间 = 事件块.time
				var 事件 = 事件块.event
				match 事件.type:
					SMF.MIDIEventType.system_event:
						match 事件.args.type:
							#乐器名称
							#SMF.MIDISystemEventType.instrument_name:
								#print(事件.args.text)
							#版权
							SMF.MIDISystemEventType.copyright:
								print(事件.args.text)
							#歌曲名称
							SMF.MIDISystemEventType.track_name:
								print(事件.args.text)
	$'../界面动画'.stop()
	$'../界面动画'.play("加载谱面画面关闭")
	$'/root/根场景/主场景'.清除物件()
	if $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/无限模式/选项勾选盒'.button_pressed==true:
		$'../游戏界面/历史成绩/标签/无限'.show()
	else:
		$'../游戏界面/历史成绩/标签/无限'.hide()
	if $'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/自动演奏/选项勾选盒'.button_pressed==true:
		$'../游戏界面/历史成绩/标签/自动'.show()
		$'/root/根场景/根界面/游戏界面/自动演奏时间轴'.show()
	else:
		$'../游戏界面/历史成绩/标签/自动'.hide()
		$'/root/根场景/根界面/游戏界面/自动演奏时间轴'.hide()
	pass # Replace with function body.

#返回键
func 菜单按钮按下():
	if 竖屏界面布局检测 == true:
		$'界面动画'.play("详细界面缩放")
		竖屏界面布局检测 = false
	else:
		$'../界面动画'.play('返回')
		get_node("/root/根场景/视角节点/三维动画节点").play("返回")
	pass # Replace with function body.
#歌曲搜索
func 歌曲搜索(new_text):
	#判断要搜索的地方是内置歌曲还是自定义歌曲
	if $'界面左列表/容器'.visible==true:
		for 菜单循环 in $'界面左列表/容器'.get_child_count()-1:
			var 菜单组建路径=$'界面左列表/容器'.get_child(菜单循环+1).get_path()
			if $'界面左列表/容器'.get_child(菜单循环+1).visible==true:
				for 子节点循环 in get_node(菜单组建路径).get_child(0).get_child_count():
					var 子节点 = get_node(菜单组建路径).get_child(0).get_child(子节点循环)
					var 文字歌曲搜索 = 子节点.get_node("容器/容器/歌曲名").text
					var 文字艺术家搜索 = 子节点.get_node("容器/容器/艺术家").text
					var 文字编号搜索 = 子节点.get_node("容器/卡片头/编号").text
					var 艺术家语言=TranslationServer.translate(文字艺术家搜索,"")
					var 歌曲名称语言=TranslationServer.translate(文字歌曲搜索,"")
					if $'界面左列表/容器/搜索栏/输入框'.text == "":
						子节点.visible=true
					else:
						if 歌曲名称语言.find($'界面左列表/容器/搜索栏/输入框'.text) >= 0 ||艺术家语言.find($'界面左列表/容器/搜索栏/输入框'.text) >= 0|| 文字编号搜索.find($'界面左列表/容器/搜索栏/输入框'.text) >= 0:
							子节点.visible=true
						else:
							子节点.visible=false
	#自定义歌曲项
	elif $'界面左列表/自定义'.visible==true:
		#判断当前状态下搜索的是封面还是歌曲
		if $'界面左列表/自定义/下拉框'.visible==false:
			#遍历自定义谱面的分类项
			for 菜单循环 in $'界面左列表/自定义/歌曲组表格/容器'.get_child_count():
				#遍历分类项内的封面
				for 菜单封面循环 in $'界面左列表/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child_count():
					var 子节点 =$'界面左列表/自定义/歌曲组表格/容器'.get_child(菜单循环).get_child(0).get_child(1).get_child(菜单封面循环)
					var 文字搜索 = 子节点.get_node("标签").text
					var 文字搜索语言=TranslationServer.translate(文字搜索,"")
					if $'界面左列表/自定义/搜索栏/输入框'.text == "":
						子节点.visible=true
					else:
						if 文字搜索语言.find($'界面左列表/自定义/搜索栏/输入框'.text) >= 0:
							子节点.visible=true
						else:
							子节点.visible=false
		#搜索自定义歌曲
		else:
			#遍历歌曲列表节点里的所有歌曲分类
			for 循环 in $'界面左列表/自定义/下拉框/歌曲列表'.get_child_count():
				#遍历歌曲列表
				for 子节点循环 in $'界面左列表/自定义/下拉框/歌曲列表'.get_child(循环).get_child(0).get_child_count():
					var 子节点 = $'界面左列表/自定义/下拉框/歌曲列表'.get_child(循环).get_child(0).get_child(子节点循环)
					var 文字歌曲搜索 = 子节点.get_node("容器/容器/歌曲名").text
					var 文字艺术家搜索 = 子节点.get_node("容器/容器/艺术家").text
					var 文字编号搜索 = 子节点.get_node("容器/卡片头/编号").text
					var 艺术家语言=TranslationServer.translate(文字艺术家搜索,"")
					var 歌曲名称语言=TranslationServer.translate(文字歌曲搜索,"")
					if $'界面左列表/自定义/搜索栏/输入框'.text == "":
						子节点.visible=true
					else:
						if 歌曲名称语言.find($'界面左列表/自定义/搜索栏/输入框'.text) >= 0 ||艺术家语言.find($'界面左列表/自定义/搜索栏/输入框'.text) >= 0|| 文字编号搜索.find($'界面左列表/自定义/搜索栏/输入框'.text) >= 0:
							子节点.visible=true
						else:
							子节点.visible=false
	pass # Replace with function body.

func 结算界面():
	$'../界面动画'.play("结算画面")
	$'../结算画面/左列表/结算/操作区/重试'.hide()
	$'../结算画面/左列表/结算/操作区/回放'.size_flags_horizontal=3
	pass # Replace with function body.


func 顶部选项卡(tab):
	#恢复搜索状态
	$'界面左列表/容器/搜索栏/输入框'.text=""
	for 菜单循环 in $'界面左列表/容器'.get_child_count()-1:
		var 菜单组建路径=$'界面左列表/容器'.get_child(菜单循环+1).get_path()
		if $'界面左列表/容器'.get_child(菜单循环+1).visible==true:
			for 子节点循环 in get_node(菜单组建路径).get_child(0).get_child_count():
				var 子节点 = get_node(菜单组建路径).get_child(0).get_child(子节点循环)
				子节点.visible=true
	#检查歌曲收藏状态
	for 卡片循环 in $'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child_count():
		if $'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child(卡片循环).get_node('容器/容器/成绩段位/收藏').button_pressed==false:
			for 循环 in $'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.get_child_count():
				if $'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.get_child(循环).has_node('容器/卡片头/编号'):
					if $'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.get_child(循环).get_node('容器/卡片头/编号').text==$'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child(卡片循环).get_node('容器/卡片头/编号').text&&$'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.get_child(循环).get_node('容器/容器/歌曲名').text==$'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child(卡片循环).get_node('容器/容器/歌曲名').text&&$'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.get_child(循环).get_node('容器/容器/艺术家').text==$'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child(卡片循环).get_node('容器/容器/艺术家').text:
						$'../游戏菜单/界面左列表/容器/旧式谱面列表/列表'.get_child(循环).get_node('容器/容器/成绩段位/收藏').button_pressed=false
						$'../游戏菜单/界面左列表/容器/收藏列表/列表'.get_child(卡片循环).queue_free()
	for 子节点循环 in $'/root/根场景/根界面/游戏菜单/界面左列表/容器'.get_child_count()-1:
		$'/root/根场景/根界面/游戏菜单/界面左列表/容器'.get_child(子节点循环+1).hide()
	$'/root/根场景/根界面/游戏菜单/界面左列表/容器'.get_child(tab+1).show()
	pass # Replace with function body.


func 隐藏分隔线():
	for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
		if $歌曲信息/歌曲信息/容器/隐藏分隔线/选项勾选盒.button_pressed == false:
			get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(子节点循环+1)+"/分隔线").hide()
		else:
			get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(子节点循环+1)+"/分隔线").show()
	pass # Replace with function body.


func 轨道数量滑块(值):
	$'../游戏界面/历史成绩/标签/键数'.text=var_to_str(int(值))+"键"
	$'/root/根场景/主场景'.物件位置占位=[]
	if 值==1.0:
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.disabled=true
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.button_pressed=true
	else:
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.disabled=false
		$歌曲信息/歌曲信息/容器/物件连续/选项勾选盒.button_pressed=false
	for 子节点循环 in $'/root/根场景/主场景/轨道'.get_child_count():
		get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(子节点循环+1)).hide()
	for 子节点循环 in 值:
		$'/root/根场景/主场景'.物件位置占位.push_back(0)
		get_node("/root/根场景/主场景/轨道/轨道根节点"+var_to_str(int(子节点循环+1))).show()
	$歌曲信息/歌曲信息/容器/轨道数量/数值.text=var_to_str(int(值))
	pass # Replace with function body.


func 允许播放乐谱():
	#自适应界面
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor && 界面宽度检测 == true:
		$'界面动画'.play("详细界面扩张")
		竖屏界面布局检测 = true
	var 文件大小=FileAccess.open(数码乐谱文件路径,FileAccess.READ).get_length()
	$'/root/根场景/主场景'.歌曲类型格式=0
	$'/root/根场景/视角节点/MidiPlayer'.stop()
	$'/root/根场景/视角节点/MidiPlayer'.file=数码乐谱文件路径
	$'/root/根场景/视角节点/MidiPlayer'.play()
	var 文件名称=数码乐谱文件路径.substr(数码乐谱父文件夹路径.split("", false).size(),数码乐谱文件路径.split("", false).size())
	if $'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text=="歌曲选项测试"||$'歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text=="艺术家测试":
		$'歌曲信息/界面动画'.stop()
		$'歌曲信息/界面动画'.play("文字提示关闭")
	$'/root/根场景/根界面/加载画面/封面/边框/容器/下容器/艺术家名称'.text = ""
	$'/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/容器/艺术家名称'.text = ""
	$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/容器/艺术家名称'.text = ""
	$'/root/根场景/根界面/游戏界面/歌曲信息/容器/艺术家'.text=""
	$'/root/根场景/根界面/加载画面/封面/边框/容器/上容器/歌曲名称'.text = 文件名称
	$'/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/歌曲名称'.text =文件名称
	$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text = 文件名称
	$'/root/根场景/根界面/游戏界面/歌曲信息/容器/歌曲名'.text=文件名称
	$'歌曲信息/歌曲信息/容器/详细/表格/容器/谱面类型/文字'.text = "多样式正式谱面"
	if 文件大小/1024 > pow(1024,2):
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = ("%.2f" %(float(文件大小)/pow(1024,3)))+"GiB"
	elif 文件大小/1024 > pow(1024,1):
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = ("%.2f" %(float(文件大小)/pow(1024,2)))+"MiB"
	elif 文件大小/1024 > pow(1024,0):
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = ("%.2f" %(float(文件大小)/1024.0))+"KiB"
	else:
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/文件大小/文字'.text = var_to_str(文件大小)+"B"
	var 每分钟节拍存储:Array=[]
	var 基础节拍存储:Array=[]
	for 事件块 in GlobalScript.数码乐谱文件数据.tracks[0].events:
		var 通道组:Array[Dictionary] = []
		for 循环 in range(16):
			通道组.append({ "通道编号": 循环, "音色库": 0, })
		var 通道编号:int = 事件块.channel_number
		var 通道 = 通道组[通道编号]
		var 时间 = 事件块.time
		var 事件 = 事件块.event
		match 事件.type:
			#SMF.MIDIEventType.program_change:
				#var 轨道乐器编号:int = 事件.number | ( 通道.音色库 << 7 )
				#print(轨道乐器编号,",",时间,",",通道编号)
			#系统事件
			SMF.MIDIEventType.system_event:
				match 事件.args.type:
					#乐器名称
					#SMF.MIDISystemEventType.instrument_name:
						#print(事件.args.text)
					#版权
					SMF.MIDISystemEventType.copyright:
						print(事件.args.text)
					#歌曲名称
					SMF.MIDISystemEventType.track_name:
						if 事件.args.text.find("�")==-1:
							$'/root/根场景/根界面/游戏界面/歌曲信息/容器/歌曲名'.text=事件.args.text
							$'/root/根场景/根界面/加载画面/封面/边框/容器/上容器/歌曲名称'.text = 事件.args.text
							$'/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/封面/边框/容器/容器/歌曲名称'.text =事件.args.text
							$'/root/根场景/根界面/游戏菜单/歌曲信息/歌曲信息/容器/封面/边框/容器/容器/歌曲名称'.text = 事件.args.text
					#歌词
					#SMF.MIDISystemEventType.lyric:
						#print(事件.args.text)
					#获取BPM的值
					SMF.MIDISystemEventType.set_tempo:
						每分钟节拍存储.push_back(60000000.0/float(事件.args.bpm))
					#获取基础节拍
					SMF.MIDISystemEventType.beat:
						基础节拍存储.push_back(4.0/float(事件.args.beat32))
	if 每分钟节拍存储.size()==1:
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text=var_to_str(每分钟节拍存储[0])
	else:
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/节拍速度/数值'.text=var_to_str(每分钟节拍存储.min())+"~"+var_to_str(每分钟节拍存储.max())
	if 基础节拍存储.size()==1:
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text=var_to_str(基础节拍存储[0])
	else:
		$'歌曲信息/歌曲信息/容器/详细/表格/容器/基础节拍/数值'.text=var_to_str(基础节拍存储.min())+"~"+var_to_str(基础节拍存储.max())
	$'歌曲信息/歌曲信息/容器/详细/表格/容器/歌曲速度/数值'.text = ("%.3f" %float(每分钟节拍存储.min()/(基础节拍存储.min()*60)))+"~"+("%.3f" %float(每分钟节拍存储.max()/(基础节拍存储.max()*60)))
	$'../游戏菜单/界面左列表/界面动画'.play("警告窗口关闭")
	pass # Replace with function body.
func 取消播放乐谱():
	$'../游戏菜单/界面左列表/界面动画'.play("警告窗口关闭")
	pass # Replace with function body.
