extends Node3D

var 游戏界面连击数 = 0
var 游戏界面分数 = 0
var 传统文件列表 = []
var 游戏开始状态=false
# Called when the node enters the scene tree for the first time.
func _ready():
	#var 文件路径 = ["user://json_chart/csv_config/music_json.csv","user://json_chart/csv_config/level.csv","user://json_chart/csv_config/language_music.csv"]
	var 文件路径 = ["res://music/json_chart/csv_config/music_json.cfg","res://music/json_chart/csv_config/level.cfg"]
	for 文件读取循环 in 文件路径.size():
		if FileAccess.file_exists(文件路径[文件读取循环])==true:
#			print(ProjectSettings.globalize_path(设置数据保存路径))
			var 传统谱面对象文件 = FileAccess.open(文件路径[文件读取循环],FileAccess.READ)
			var 传统谱面对象文件内容 = 传统谱面对象文件.get_csv_line(",")
			var 传统谱面对象文件标识 = 传统谱面对象文件内容
			var 传统谱面对象文件数组 = []
			while not 传统谱面对象文件.eof_reached():
			#如果读取的光标没有到文件尾部会一直循环，行循环
				传统谱面对象文件内容 = 传统谱面对象文件.get_csv_line(",")
				var 传统谱面对象文件对象 = {}
				for 循环 in 传统谱面对象文件内容.size():
					#列循环
					传统谱面对象文件对象[传统谱面对象文件标识[循环]] = 传统谱面对象文件内容[循环]
				传统谱面对象文件数组.push_back(传统谱面对象文件对象)
			传统文件列表.push_back(传统谱面对象文件数组)
		else:
			break
	pass # Replace with function body.

var 物件总时间 = {}
var 物件时长 = {}
var 物件类型 = {}
var 谱面每分钟节拍 = []
var 谱面基础节拍 = []
var 阶段时间位置 = []
# Called every frame. 'delta' is the elapsed time since the previous frame.
