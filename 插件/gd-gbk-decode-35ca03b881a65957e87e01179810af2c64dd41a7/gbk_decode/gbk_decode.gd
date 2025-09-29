@tool
extends EditorPlugin

const AUTOLOAD_NAME = "GbkDecodePlugin";

func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/gbk_decode/gbk_decode_util.gd");


func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME);
