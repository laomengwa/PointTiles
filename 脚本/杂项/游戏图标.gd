extends Node3D
func _ready() -> void:
	#检测是繁体中文的状态下
	if TranslationServer.get_locale()=="zh_TW"||TranslationServer.get_locale()=="zh_HK"||TranslationServer.get_locale()=="zh_MO":
		$"块".hide()
		$"塊".show()
	else:
		#简体中文
		$"块".show()
		$"塊".hide()
	pass
