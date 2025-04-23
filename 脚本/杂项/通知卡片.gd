extends Panel
func _ready():
	$"界面动画".play("推送通知")
	pass

func 关闭通知():
	$"界面动画".play("推送通知关闭")
	pass

func 删除通知(动画名):
	if 动画名=="推送通知关闭":
		self.queue_free()
	pass
