extends HBoxContainer
var 当前页面:int=1
var 总页面:int=0
var 自定义歌曲网格节点:Node=null
#因为自定义和默认歌曲选歌栏函数名参数调用不一致，为此用该变量作区分，后续调整
var 自定义歌曲引用:bool=false
var 文件路径:String=""
var 歌曲集合名称:String=""
var 被添加歌曲节点:Node=null
func _ready() -> void:
	刷新状态()
	pass
func _input(事件: InputEvent) -> void:
	if 事件 is InputEventKey:
		if 事件.is_pressed()==false:
			match 事件.keycode:
				KEY_PAGEUP:
					上一页()
				KEY_PAGEDOWN:
					下一页()
	pass
func 刷新状态():
	$"文字".text="第%d页/共%d页"%[当前页面,总页面]
	if 当前页面<=1:
		$上一页.set_disabled(true)
	else:
		$上一页.set_disabled(false)
	if 当前页面>=总页面:
		$下一页.set_disabled(true)
	else:
		$下一页.set_disabled(false)
	pass

func 上一页() -> void:
	if 当前页面>1:
		当前页面-=1
		$"文字".text="第%d页/共%d页"%[当前页面,总页面]
		if 自定义歌曲网格节点!=null:
			if 自定义歌曲网格节点.歌曲加载状态==false:
				if 自定义歌曲引用==false:
					自定义歌曲网格节点.添加指定传统歌曲(当前页面)
				else:
					自定义歌曲网格节点.添加指定传统歌曲(当前页面,文件路径,歌曲集合名称,被添加歌曲节点)
			else:
				自定义歌曲网格节点.歌曲待刷新状态.状态=true
				自定义歌曲网格节点.歌曲待刷新状态.页码=当前页面
	刷新状态()
	pass # Replace with function body.

func 下一页() -> void:
	if 当前页面<总页面:
		当前页面+=1
		$"文字".text="第%d页/共%d页"%[当前页面,总页面]
		if 自定义歌曲网格节点!=null:
			if 自定义歌曲网格节点.歌曲加载状态==false:
				if 自定义歌曲引用==false:
					自定义歌曲网格节点.添加指定传统歌曲(当前页面)
				else:
					自定义歌曲网格节点.添加指定传统歌曲(当前页面,文件路径,歌曲集合名称,被添加歌曲节点)
			else:
				自定义歌曲网格节点.歌曲待刷新状态.状态=true
				自定义歌曲网格节点.歌曲待刷新状态.页码=当前页面
	刷新状态()
	pass # Replace with function body.
