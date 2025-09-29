extends VBoxContainer

func 简体中文():
	TranslationServer.set_locale("zh_CN")
	$'/root/根场景/根界面/设置'.语言区域设置数据="zh_CN"
	pass

func 繁体中文():
	TranslationServer.set_locale("zh_TW")
	$'/root/根场景/根界面/设置'.语言区域设置数据="zh_TW"
	pass
