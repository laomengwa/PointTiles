extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func 简体中文():
	TranslationServer.set_locale("zh_CN")
	$'/root/根场景/根界面/设置'.语言区域设置数据="zh_CN"
	pass # Replace with function body.


func 繁体中文():
	TranslationServer.set_locale("zh_TW")
	$'/root/根场景/根界面/设置'.语言区域设置数据="zh_TW"
	pass # Replace with function body.
