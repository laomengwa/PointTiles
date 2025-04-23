extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var 界面尺寸缩放 = ProjectSettings.get_setting('display/window/stretch/scale')
var 竖屏左列表检测 = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#UI自适应
	#竖屏
	if $'/root/根场景/根界面'.size[0] <= 900 * 界面尺寸缩放:
		if 竖屏左列表检测 == false:
			$'../结算画面/界面动画'.play("结算画面收缩")
			竖屏左列表检测 = true
	#横屏
	else:
		if 竖屏左列表检测 == true:
			$'../结算画面/界面动画'.play("结算画面扩张")
			竖屏左列表检测 = false
	pass
func 暂停函数():
	$'界面动画'.play("暂停窗口")
	$'../../视角节点/背景音乐播放节点'.set_stream_paused(true)
	pass


func _on_pause_button_down():
	暂停函数()
	pass # Replace with function body.


func _on_继续_button_down():
	$'界面动画'.play("暂停窗口关闭")
	$'../../视角节点/背景音乐播放节点'.set_stream_paused(false)
	pass # Replace with function body.


func _on_重试_button_down():
	$'../结算画面'.hide()
	$'../界面动画'.play("加载谱面画面")
	GlobalScript.游戏界面连击数 = 0
	GlobalScript.游戏界面分数 = 0
	$"/root/根场景/主场景".完美判定=0
	$"/root/根场景/主场景".良好判定=0
	$"/root/根场景/主场景".较差判定=0
	$"/root/根场景/主场景".很差判定=0
	$"/root/根场景/主场景".失误判定=0
	$"/root/根场景/主场景".漏击判定=0
	get_node("/root/根场景/根界面/游戏界面/游戏界面分数").text = var_to_str(GlobalScript.游戏界面分数)
	$'/root/根场景/根界面/游戏界面/游戏界面进度条'.value=0
	$'/root/根场景/主场景'.清除物件()
	get_node("/root/根场景/根界面/游戏界面/游戏界面连击数").text = var_to_str(GlobalScript.游戏界面连击数)
	$"../../主场景/开始按键".show()
	$'../界面动画'.play("加载谱面画面关闭")
	$'../加载画面/加载文字/进度条'.value=100
	$'../游戏菜单'.hide()
	$'../窗口/暂停窗口'.hide()
	$'../窗口遮挡'.hide()
	pass # Replace with function body.


var 游戏暂停设置窗口 = false
func _on_退出_button_down():
	游戏暂停设置窗口 = false
	$'../界面动画'.play("结算画面")
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/界面容器/得分").text = var_to_str(GlobalScript.游戏界面分数)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/连击数/数值").text = var_to_str(GlobalScript.游戏界面连击数)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/详细信息/容器/判定统计列表/连击数/数值").text = var_to_str(GlobalScript.游戏界面连击数)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/完美/数值").text=var_to_str($"/root/根场景/主场景".完美判定)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/良好/数值").text=var_to_str($"/root/根场景/主场景".良好判定)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/较差/数值").text=var_to_str($"/root/根场景/主场景".较差判定)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/很差/数值").text=var_to_str($"/root/根场景/主场景".很差判定)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/失误/数值").text=var_to_str($"/root/根场景/主场景".失误判定)
	get_node("/root/根场景/根界面/结算画面/左列表/结算/界面容器/界面容器/判定统计/容器/判定统计列表/漏击/数值").text=var_to_str($"/root/根场景/主场景".漏击判定)
	$'/root/根场景/主场景'.清除物件()
	$'/root/根场景/主场景/开始按键'.hide()
	pass # Replace with function body.

func _on_设置_button_down():
	$'../设置/界面动画'.play('设置界面打开')
	if $'../结算画面'.visible==false:
		$'界面动画'.play("暂停窗口关闭")
		$'../设置/顶栏/顶栏/状态'.text = "（游戏中）"
	游戏暂停设置窗口 = true
	pass # Replace with function body.


func _on_返回_button_down():
	$'../界面动画'.play("结算画面返回")
	$'/root/根场景/主场景'.清除物件()
	$'../结算画面/左列表/结算/操作区/重试'.show()
	$'../结算画面/左列表/结算/操作区/回放'.size_flags_horizontal=1
	GlobalScript.游戏开始状态=false
	pass # Replace with function body.


func 结算排名(tab):
	$'../结算画面/右列表/本地排名'.hide()
	$'../结算画面/右列表/全球排名'.hide()
	$'../结算画面/右列表/地区排名'.hide()
	$'../结算画面/右列表/好友排名'.hide()
	match tab:
		0:
			$'../结算画面/右列表/本地排名'.show()
		1:
			$'../结算画面/右列表/全球排名'.show()
		2:
			$'../结算画面/右列表/地区排名'.show()
		3:
			$'../结算画面/右列表/好友排名'.show()
	pass # Replace with function body.
