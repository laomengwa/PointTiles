extends Button
var 请求引用节点:Node=null
var 文件路径:String=""
var 歌曲集合名称:String=""
var 被添加歌曲节点:Node=null
func 按钮按下() -> void:
	if 请求引用节点!=null:
		$/root/根场景/根界面/游戏菜单/界面左列表/界面动画.play("加载窗口")
		请求引用节点.添加指定传统歌曲(1,文件路径,歌曲集合名称,被添加歌曲节点)
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/翻页栏".当前页面=1
	$"/root/根场景/根界面/游戏菜单/界面左列表/自定义/下拉框/翻页栏/当前页".text="1"
	self.hide()
	if $'/root/根场景/根界面'.size[0] <= 760 * get_tree().root.content_scale_factor && $/root/根场景/根界面/游戏菜单.界面宽度检测 == true:
		$'/root/根场景/根界面/游戏菜单/界面动画'.play("详细界面缩放")
		$/root/根场景/根界面/游戏菜单.竖屏界面布局检测 = true
	pass # Replace with function body.
