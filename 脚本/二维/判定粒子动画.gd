extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position=$'../游戏界面精确判定'.position
	$判定背景.position=Vector2($'../游戏界面精确判定'.size[0]/2,$'../游戏界面精确判定'.size[1]/2)
	$粒子效果_左上.position=Vector2(0,0)
	$粒子效果_左下.position=Vector2(0,$'../游戏界面精确判定'.size[1])
	$粒子效果_右上.position=Vector2($'../游戏界面精确判定'.size[0],0)
	$粒子效果_右下.position=Vector2($'../游戏界面精确判定'.size[0],$'../游戏界面精确判定'.size[1])
	pass
