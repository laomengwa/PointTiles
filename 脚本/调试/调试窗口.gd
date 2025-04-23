extends Window
##测试用代码，游戏正式公布之后将会隐藏或者删除代码和调试窗口！
func 添加轨道():
	var 选项=$滚动栏/容器/添加轨道/选项.selected
	var 参数=$滚动栏/容器/添加轨道/参数.text
	var 欧拉角旋转顺序=$滚动栏/容器/添加轨道/旋转顺序.selected
	var 位置=Vector3(0,0,0)
	var 旋转=Vector3(0,0,0)
	var 缩放=Vector3(1,1,1)
	var 分割=参数.split(";")
	if 分割.size()==3:
		if 分割[0].split(",").size()==3:
			位置=Vector3(float(分割[0].split(",")[0]),float(分割[0].split(",")[1]),float(分割[0].split(",")[2]))
		if 分割[1].split(",").size()==3:
			旋转=Vector3(float(分割[1].split(",")[0]),float(分割[1].split(",")[1]),float(分割[1].split(",")[2]))
		if 分割[2].split(",").size()==3:
			缩放=Vector3(float(分割[2].split(",")[0]),float(分割[2].split(",")[1]),float(分割[2].split(",")[2]))
	get_node("/root/根场景/主场景/无轨").添加轨道(选项,位置,旋转,欧拉角旋转顺序,缩放)
	pass # Replace with function body.


func 轨道移动():
	var 参数=$滚动栏/容器/轨道移动/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/轨道移动/旋转顺序.selected
	var 平移
	var 旋转
	var 缩放
	if 分割.size()==3:
		平移=分割[0].split(",")
		旋转=分割[1].split(",")
		缩放=分割[2].split(",")
		get_node("/root/根场景/主场景/无轨").轨道移动($滚动栏/容器/轨道移动/编号.value,平移,旋转,欧拉角旋转顺序,缩放)
	pass

func 轨道移动停止():
	var 参数=$滚动栏/容器/轨道停止移动/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/轨道停止移动/旋转顺序.selected
	if 分割.size()==3:
		var 平移=分割[0].split(",")
		var 旋转=分割[1].split(",")
		var 缩放=分割[2].split(",")
		get_node("/root/根场景/主场景/无轨").轨道停止移动($滚动栏/容器/轨道停止移动/编号.value,平移,旋转,欧拉角旋转顺序,缩放)
	pass # Replace with function body.

func 游戏模式():
	get_node("/root/根场景/主场景/无轨").游戏模式($滚动栏/容器/游戏模式/选项.selected)
	pass # Replace with function body.

func 轨道显示隐藏():
	get_node("/root/根场景/主场景/无轨").轨道显示隐藏($滚动栏/容器/轨道显示隐藏/编号.value,$滚动栏/容器/轨道显示隐藏/参数.button_pressed)
	pass # Replace with function body.
	
func 轨道线条变更():
	var 参数=$滚动栏/容器/轨道线条变更/参数.text
	var 分割=参数.split(";")
	if 分割.size()==2:
		var 网格=分割[0].split(",")
		var 纹理=分割[1].split(",")
		if 网格.size()==3&&纹理.size()==4:
			get_node("/root/根场景/主场景/无轨").轨道线条变更($滚动栏/容器/轨道线条变更/编号.value,$滚动栏/容器/轨道线条变更/线条.value,网格,纹理)
	pass # Replace with function body.

func 线条停止变更():
	var 参数=$滚动栏/容器/线条停止变更/参数.text
	var 分割=参数.split(";")
	if 分割.size()==2:
		var 网格=分割[0].split(",")
		var 纹理=分割[1].split(",")
		if 网格.size()==3&&纹理.size()==4:
			get_node("/root/根场景/主场景/无轨").轨道线条变更($滚动栏/容器/线条停止变更/编号.value,$滚动栏/容器/线条停止变更/线条.value,网格,纹理)
	pass # Replace with function body.

func 轨道允许失误():
	get_node("/root/根场景/主场景/无轨").轨道允许失误($滚动栏/容器/允许触碰白块/编号.value,$滚动栏/容器/允许触碰白块/参数.button_pressed)
	pass # Replace with function body.

func 调试窗口关闭() -> void:
	if 全局脚本.游戏开始状态==false:
		self.hide()
		$"../../界面动画".play("结算画面返回")
		$"../../游戏界面".hide()
		$'/root/根场景/主场景'.清除物件()
		全局脚本.调试状态=false
	pass # Replace with function body.

func 修改摄像机() -> void:
	var 参数=$滚动栏/容器/修改摄像机/参数.text
	var 位置=Vector3(0,0,0)
	var 旋转=Vector3(0,0,0)
	var 分割=参数.split(";")
	if 分割.size()==2:
		if 分割[0].split(",").size()==3:
			位置=Vector3(float(分割[0].split(",")[0]),float(分割[0].split(",")[1]),float(分割[0].split(",")[2]))
		if 分割[1].split(",").size()==3:
			旋转=Vector3(float(分割[1].split(",")[0]),float(分割[1].split(",")[1]),float(分割[1].split(",")[2]))
	get_node("/root/根场景/主场景/无轨").更改摄像机状态(位置,旋转,$"滚动栏/容器/修改摄像机/旋转顺序".selected,$滚动栏/容器/修改摄像机/参数0.value,$滚动栏/容器/修改摄像机/视角.selected,$滚动栏/容器/修改摄像机/长宽比.selected,$滚动栏/容器/修改摄像机/参数1.value,$滚动栏/容器/修改摄像机/参数2.value)
	pass # Replace with function body.
func 摄像机移动():
	var 参数=$滚动栏/容器/移动摄像机/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/移动摄像机/旋转顺序.selected
	var 平移
	var 旋转
	if 分割.size()==2:
		平移=分割[0].split(",")
		旋转=分割[1].split(",")
		get_node("/root/根场景/主场景/无轨").摄像机移动(平移,旋转,欧拉角旋转顺序)
	pass

func 摄像机移动停止():
	var 参数=$滚动栏/容器/移动摄像机停止/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/移动摄像机停止/旋转顺序.selected
	if 分割.size()==2:
		var 平移=分割[0].split(",")
		var 旋转=分割[1].split(",")
		get_node("/root/根场景/主场景/无轨").摄像机停止移动(平移,旋转,欧拉角旋转顺序)
	pass # Replace with function body.
