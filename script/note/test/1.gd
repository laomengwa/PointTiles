extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_按钮_pressed():
	$/root/根场景/视角节点/MidiPlayer.stop()
	$'/root/根场景/根界面/加载画面/加载背景动画'.play("加载谱面画面背景")
	$'/root/根场景/根界面/界面动画'.play("加载谱面画面")
	await get_tree().create_timer(1).timeout
	$'/root/根场景/根界面/界面动画'.play("加载谱面画面关闭")
	pass # Replace with function body.
