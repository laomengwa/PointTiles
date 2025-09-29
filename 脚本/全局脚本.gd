extends Node3D
var 音频延迟:float=0
var 判定偏移:float=0
var 游戏开始状态:bool=false
var 调试状态:bool=false
var 挑战赛加速度=[0,0,false]
#该变量用于判定MIDI歌曲是否需要重复加载
var 数码乐谱文件数据:SMF.SMFData
var 物件轨道编号显示:bool=false
#下面变量在重构程序时删除
var 乐器音色:Dictionary={}
var 物件总时间:Dictionary = {}
var 物件时长:Dictionary = {}
var 物件类型:Dictionary = {}   
var 对象文件乐谱声音:Dictionary={}                                                                                             
var 谱面每分钟节拍:Array = []
var 谱面基础节拍:Array = []
var 阶段时间位置:Array = []
var 传统文件列表:Array = []
var 存储单位判断:bool=false
#
#var 线程组:Array[Thread]
#var 互斥锁:Mutex=Mutex.new()
#var 多线程信号量:Semaphore=Semaphore.new()
@onready var 通知节点=preload("res://场景/通知卡片.tscn")
func _ready() -> void:
	get_viewport().files_dropped.connect(文件接收)
	#for 创建进程 in OS.get_processor_count()*2-1:
		#var 新线程:Thread=Thread.new()
		#线程组.push_back(新线程)
	pass
func 存储单位转换(文件大小:int)->String:
	var 字符串:String
	#单位用于判断是以十进制计算或者二进制计算
	if 存储单位判断==false:
			字符串 = String.humanize_size(文件大小)
	else:
		#if 文件大小 >= 1000000000000000000000000000000000000000:
			#字符串 = ("%.2f XB" %(float(文件大小)/1000000000000000000000000000000000000000))
		#elif 文件大小 >= 1000000000000000000000000000000000000:
			#字符串 = ("%.2f CB" %(float(文件大小)/1000000000000000000000000000000000000))
		#elif 文件大小 >= 1000000000000000000000000000000000:
			#字符串 = ("%.2f DB" %(float(文件大小)/1000000000000000000000000000000000))
		#elif 文件大小 >= 1000000000000000000000000000000:
			#字符串 = ("%.2f NB" %(float(文件大小)/1000000000000000000000000000000))
		#elif 文件大小 >= 1000000000000000000000000000:
			#字符串 = ("%.2f BB" %(float(文件大小)/1000000000000000000000000000))
		#elif 文件大小 >= 1000000000000000000000000:
			#字符串 = ("%.2f YB" %(float(文件大小)/1000000000000000000000000))
		#elif 文件大小 >= 1000000000000000000000:
			#字符串 = ("%.2f ZB" %(float(文件大小)/1000000000000000000000))
		if 文件大小 >= 1000000000000000000:
			字符串 = ("%.2f EB" %(float(文件大小)/1000000000000000000))
		elif 文件大小 >= 1000000000000000:
			字符串 = ("%.2f PB" %(float(文件大小)/1000000000000000))
		elif 文件大小 >= 1000000000000:
			字符串 = ("%.2f TB" %(float(文件大小)/1000000000000))
		elif 文件大小 >= 1000000000:
			字符串 = ("%.2f GB" %(float(文件大小)/1000000000))
		elif 文件大小 >= 1000000:
			字符串 = ("%.2f MB" %(float(文件大小)/1000000))
		elif 文件大小 >= 1000:
			字符串= ("%.2f kB" %(float(文件大小)/1000))
		else:
			字符串 = "%d B" %文件大小
	return 字符串
#文件拖拽到游戏窗口时发出
func 文件接收(文件:PackedStringArray)->void:
	match 文件.size():
		1:
			var 读取结果 = FileAccess.open(文件[0], FileAccess.READ )
			if 读取结果!=null:
				if 读取结果.get_error() == OK:
					var 文件流:StreamPeerBuffer = StreamPeerBuffer.new( )
					文件流.set_data_array(读取结果.get_buffer( 读取结果.get_length( ) ) )
					文件流.big_endian = false
					var 数据块 = SoundFont.SoundFontChunk.new( )
					数据块.header = 文件流.get_string(4)
					match 数据块.header:
						#声音字体
						"RIFF":
							#从流中获取有符号 32 位值
							文件流.get_32()
							#二次确认
							if 文件流.get_string(4)=="sfbk":
								$"/root/根场景/视角节点/MidiPlayer".soundfont=文件[0]
								$'/root/根场景/根界面/设置/设置选项/音频'.声音字体文件路径=文件[0]
								$'/root/根场景/根界面/设置/设置选项/音频/音频/其他/容器/音源字体文件/文件名'.text=文件[0]
								$'/root/根场景/根界面/设置/设置选项/音频'.设置应用()
								发送通知("声音字体已加载","音色已成功切换。\n文件路径：%s"%文件[0])
							pass
					
	pass
func 发送通知(标题:String,详细内容:String="")->void:
	var 通知=通知节点.instantiate()
	通知.get_node("控件/标题").text=标题
	通知.get_node("控件/内容").text=详细内容
	$'/root/根场景/根界面/通知栏'.add_child(通知)
	pass
func 整数转六十四进制(值:int,位元:int=0)->String:
	var 紧凑字节:PackedByteArray=[]
	match 位元:
		1:
			紧凑字节=[值&0xFF,(值>>8)&0xFF,(值>>16)&0xFF,(值>>24)&0xFF]
			pass
			#32位
		2:
			紧凑字节=[值&0xFF,(值>>8)&0xFF]
			pass
			#16位
		3:
			紧凑字节=[值&0xFF]
			pass
			#8位
		0,_:
			for 循环 in range(8):
				紧凑字节.push_back((值>>(8*循环))&0xFF)
			#64位
	return Marshalls.raw_to_base64(紧凑字节)
func 六十四进制转整数(文本:String,位元:int=0)->int:
	var 紧凑字节:PackedByteArray=Marshalls.base64_to_raw(文本)
	match 位元:
		0:
			return 紧凑字节.decode_s64(0)
		2:
			return 紧凑字节.decode_s32(0)
		3:
			return 紧凑字节.decode_u32(0)
		4:
			return 紧凑字节.decode_s16(0)
		5:
			return 紧凑字节.decode_u16(0)
		6:
			return 紧凑字节.decode_s8(0)
		7:
			return 紧凑字节.decode_u8(0)
		1,_:
			return 紧凑字节.decode_u64(0)
func 浮点转六十四进制(值:float,位元:int=0)->String:
	var 紧凑字节:PackedByteArray
	match 位元:
		1:
			#32位
			紧凑字节.resize(4)
			紧凑字节.encode_float(0,值)
		2:
			#16位
			紧凑字节.resize(2)
			紧凑字节.encode_half(0,值)
		0,_:
			#64位
			紧凑字节.resize(8)
			紧凑字节.encode_double(0,值)
	return Marshalls.raw_to_base64(紧凑字节)
func 六十四进制转浮点(文本:String)->float:
	var 紧凑字节:PackedByteArray=Marshalls.base64_to_raw(文本)
	match 紧凑字节.size():
		2:
			return 紧凑字节.decode_half(0)
		4:
			return 紧凑字节.decode_float(0)
		8:
			return 紧凑字节.decode_double(0)
		_:
			return 0
