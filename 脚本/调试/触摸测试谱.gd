extends Label
#调试使用
@onready var 长块场景 = preload("res://场景/音符/长块.tscn")
@onready var 滑条场景 = preload("res://场景/音符/滑块.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_按钮_pressed():
	全局脚本.调试状态=true
	$/root/根场景/音符/视角节点/MidiPlayer.stop()
	$'/root/根场景/音符/根界面/加载画面/加载背景动画'.play("加载谱面画面背景")
	$'/root/根场景/音符/根界面/界面动画'.play("加载谱面画面")
	await get_tree().create_timer(1).timeout
	$'/root/根场景/音符/根界面/界面动画'.play("加载谱面画面关闭")
	$"../../../../../../游戏界面/调试窗口".show()
	var 测试用音符甲=长块场景.instantiate()
	var 测试用音符乙=滑条场景.instantiate()
	var 测试用音符丙=长块场景.instantiate()
	var 测试用音符丁=滑条场景.instantiate()
	#var 测试用音符戊=滑条场景.instantiate()
	测试用音符甲.调试模式=true
	测试用音符乙.调试模式=true
	测试用音符丙.调试模式=true
	测试用音符丁.调试模式=true
	#测试用音符戊.调试模式=true
	$/root/根场景/音符/主场景/音符/轨道/轨道根节点1.add_child(测试用音符甲)
	$/root/根场景/音符/主场景/音符/轨道/轨道根节点2.add_child(测试用音符乙)
	$/root/根场景/音符/主场景/音符/轨道/轨道根节点3.add_child(测试用音符丙)
	$/root/根场景/音符/主场景/音符/轨道/轨道根节点4.add_child(测试用音符丁)
	#$/root/根场景/音符/主场景/音符/轨道/轨道根节点1.add_child(测试用音符戊)
	测试用音符甲.position[1]=-2
	测试用音符乙.position[1]=-2
	测试用音符丙.position[1]=-2
	测试用音符丁.position[1]=-2
	#测试用音符戊.position[1]=1
	pass # Replace with function body.
