extends Window
##测试用代码，游戏正式公布之后将成为谱面编辑器面板！
func 添加轨道():
	var 选项=$滚动栏/容器/添加轨道/选项.selected
	var 参数=$滚动栏/容器/添加轨道/参数.text
	var 欧拉角旋转顺序=$滚动栏/容器/添加轨道/旋转顺序.selected
	var 位置=Vector3(0,0,0)
	var 旋转=Vector3(0,0,0)
	var 缩放=Vector3(1,1,1)
	var 物件区:float=-4
	var 分割=参数.split(";")
	if 分割.size()==4:
		if 分割[0].split(",").size()==3:
			位置=Vector3(float(分割[0].split(",")[0]),float(分割[0].split(",")[1]),float(分割[0].split(",")[2]))
		if 分割[1].split(",").size()==3:
			旋转=Vector3(float(分割[1].split(",")[0]),float(分割[1].split(",")[1]),float(分割[1].split(",")[2]))
		if 分割[2].split(",").size()==3:
			缩放=Vector3(float(分割[2].split(",")[0]),float(分割[2].split(",")[1]),float(分割[2].split(",")[2]))
		物件区=float(分割[3])
	get_node("/root/根场景/主场景/无轨").添加轨道(true,$'/root/根场景/视角节点/背景音乐播放节点'.播放时间,选项,$滚动栏/容器/添加轨道/编号.value,$滚动栏/容器/添加轨道/参数2.selected-1,位置,旋转,欧拉角旋转顺序,物件区,缩放)
	pass
#事件类型为11，4位base64字符为事件类型，后面采用字典存储
#"I"表示轨道编号，“T”表示轨道类型（例如采用有轨或者无轨），"D"表示允许触碰白块，"P"表示轨道位置，“R”表示旋转（四个元素中第四个表示旋转方式，若第一个元素数值小于1则成为四元数的w值）,"S"表示缩放
#轨道编号里，单独的纯数字例如"4"表示只定义第四号轨道，"0～12"表示选择编号0到编号12的13个轨道，"0~12!3~5"表示剔除编号3到编号5的3个轨道定义
#json存储格式类似于：{"I":"0","T":0,"D":1,"P":[0,0,0],"R":[0,0,0,0],"S":[1,1,1]}
#后续考虑选择占用存储空间更少的存储方式，暂时性定义
func 添加轨道复制() -> void:
	#var 值=PI
	#print(全局脚本.浮点转六十四进制(值))
	#print(全局脚本.六十四进制转浮点(全局脚本.浮点转六十四进制(值)))
	#DisplayServer.clipboard_set(全局脚本.整数转六十四进制(事件编号,2)+var_to_str($滚动栏/容器/游戏模式/选项.selected))
	var 事件编号:int=11
	var 选项=$滚动栏/容器/添加轨道/选项.selected
	var 参数=$滚动栏/容器/添加轨道/参数.text
	var 欧拉角旋转顺序=$滚动栏/容器/添加轨道/旋转顺序.selected
	var 位置=Vector3(0,0,0)
	var 旋转=Vector3(0,0,0)
	var 缩放=Vector3(1,1,1)
	var 物件区:float=-4
	var 分割=参数.split(";")
	if 分割.size()==3:
		if 分割[0].split(",").size()==3:
			位置=Vector3(float(分割[0].split(",")[0]),float(分割[0].split(",")[1]),float(分割[0].split(",")[2]))
		if 分割[1].split(",").size()==3:
			旋转=Vector3(float(分割[1].split(",")[0]),float(分割[1].split(",")[1]),float(分割[1].split(",")[2]))
		if 分割[2].split(",").size()==3:
			缩放=Vector3(float(分割[2].split(",")[0]),float(分割[2].split(",")[1]),float(分割[2].split(",")[2]))
	物件区=float(分割[3])
	var 对象:Dictionary={"I":$滚动栏/容器/添加轨道/编号.value,"T":选项,"D":$滚动栏/容器/添加轨道/参数2.selected-1,"P":[位置[0],位置[1],位置[2]],"R":[旋转[0],旋转[1],旋转[2],var_to_str(欧拉角旋转顺序)],"N":物件区,"S":[缩放[0],缩放[1],缩放[2]]}
	print(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	DisplayServer.clipboard_set(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	pass


func 轨道移动():
	var 参数=$滚动栏/容器/轨道移动/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/轨道移动/旋转顺序.selected
	var 平移:Array
	var 旋转:Array
	var 缩放:Array
	var 物件区:String
	if 分割.size()==4:
		平移=分割[0].split(",")
		旋转=分割[1].split(",")
		缩放=分割[2].split(",")
		物件区=分割[3]
		get_node("/root/根场景/主场景/无轨").轨道移动($滚动栏/容器/轨道移动/编号.value,$'/root/根场景/视角节点/背景音乐播放节点'.播放时间,平移,旋转,欧拉角旋转顺序,物件区,缩放)
	pass
#事件类型为12，4位base64字符为事件类型，后面采用字典存储
#"I"表示轨道编号，"P"表示轨道位置公式，“R”表示旋转公式（四个元素中第四个表示旋转方式）,"S"表示缩放公式
#轨道编号里，单独的纯数字例如"4"表示只定义第四号轨道，"0～12"表示选择编号0到编号12的13个轨道，"0~12!3~5"表示剔除编号3到编号5的3个轨道定义
#json存储格式类似于：{"I":"0","T":0,"P":["s+t*0.02","s","s"],"R":[0,"tan(t)","s","s"],"S":["s+0.5*sin(t)","s","s"]}
#后续考虑选择占用存储空间更少的存储方式，暂时性定义
func 轨道移动复制() -> void:
	var 事件编号:int=12
	var 参数=$滚动栏/容器/轨道移动/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/轨道移动/旋转顺序.selected
	var 平移:Array
	var 旋转:Array
	var 缩放:Array
	var 物件区:String
	if 分割.size()==4:
		平移=分割[0].split(",")
		旋转=分割[1].split(",")
		缩放=分割[2].split(",")
		物件区=分割[3]
	旋转.push_back(欧拉角旋转顺序)
	var 对象:Dictionary={"I":$滚动栏/容器/添加轨道/编号.value,"P":平移,"R":旋转,"N":物件区,"S":缩放}
	print(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	DisplayServer.clipboard_set(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	pass

func 轨道移动停止():
	var 参数=$滚动栏/容器/轨道停止移动/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/轨道停止移动/旋转顺序.selected
	if 分割.size()==4:
		var 平移=分割[0].split(",")
		var 旋转=分割[1].split(",")
		var 缩放=分割[2].split(",")
		get_node("/root/根场景/主场景/无轨").轨道停止移动($滚动栏/容器/轨道停止移动/编号.value,平移,旋转,欧拉角旋转顺序,分割[3],缩放)
	pass
#事件类型为13，4位base64字符为事件类型，后面采用字典存储
#"I"表示轨道编号，"P"表示轨道位置公式，“R”表示旋转公式（四个元素中第四个表示旋转方式）,"S"表示缩放公式
#轨道编号里，单独的纯数字例如"4"表示只定义第四号轨道，"0～12"表示选择编号0到编号12的13个轨道，"0~12!3~5"表示剔除编号3到编号5的3个轨道定义
#json存储格式类似于：{"I":"0","T":0,"P":["s","s","s"],"R":[0,"s","s","s"],"S":["s","s","s"]}
#后续考虑选择占用存储空间更少的存储方式，暂时性定义
func 轨道停止复制() -> void:
	var 事件编号:int=13
	var 参数=$滚动栏/容器/轨道停止移动/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/轨道停止移动/旋转顺序.selected
	var 平移:Array
	var 旋转:Array
	var 缩放:Array
	if 分割.size()==4:
		平移=分割[0].split(",")
		旋转=分割[1].split(",")
		缩放=分割[2].split(",")
	旋转.push_back(欧拉角旋转顺序)
	var 对象:Dictionary={"I":$滚动栏/容器/轨道停止移动/编号.value,"P":平移,"R":旋转,"N":分割[3],"S":缩放}
	print(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	DisplayServer.clipboard_set(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	pass

func 游戏模式():
	get_node("/root/根场景/主场景/无轨").游戏模式($滚动栏/容器/游戏模式/选项.selected)
	pass
#事件类型为10，4位base64字符为事件类型
#json存储格式类似于：{"T":0}
func 游戏模式复制() -> void:
	var 事件编号:int=10
	var 对象:Dictionary={"T":$滚动栏/容器/游戏模式/选项.selected}
	print(全局脚本.整数转六十四进制(事件编号,2)+var_to_str($滚动栏/容器/游戏模式/选项.selected))
	DisplayServer.clipboard_set(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	pass

func 轨道显示隐藏():
	get_node("/root/根场景/主场景/无轨").轨道显示隐藏($滚动栏/容器/轨道显示隐藏/编号.value,$滚动栏/容器/轨道显示隐藏/参数.button_pressed)
	pass
#事件类型为14，4位base64字符为事件类型，后面采用字典存储
#"I"表示轨道编号，"V"表示显示状态
#轨道编号里，单独的纯数字例如"4"表示只定义第四号轨道，"0～12"表示选择编号0到编号12的13个轨道，"0~12!3~5"表示剔除编号3到编号5的3个轨道定义
#json存储格式类似于：{"I":0,"V":0}
#后续考虑选择占用存储空间更少的存储方式，暂时性定义
func 轨道显隐复制() -> void:
	var 事件编号:int=14
	var 对象:Dictionary={"I":$滚动栏/容器/轨道显示隐藏/编号.value,"V":$滚动栏/容器/轨道显示隐藏/参数.button_pressed}
	print(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	DisplayServer.clipboard_set(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	pass # Replace with function body.

func 轨道线条变更():
	var 参数=$滚动栏/容器/轨道线条变更/参数.text
	var 分割=参数.split(";")
	if 分割.size()==2:
		var 网格=分割[0].split(",")
		var 纹理=分割[1].split(",")
		if 网格.size()==3&&纹理.size()==4:
			get_node("/root/根场景/主场景/无轨").轨道线条变更($滚动栏/容器/轨道线条变更/编号.value,$滚动栏/容器/轨道线条变更/线条.value,网格,纹理)
	pass

func 线条停止变更():
	var 参数=$滚动栏/容器/线条停止变更/参数.text
	var 分割=参数.split(";")
	if 分割.size()==2:
		var 网格=分割[0].split(",")
		var 纹理=分割[1].split(",")
		if 网格.size()==3&&纹理.size()==4:
			get_node("/root/根场景/主场景/无轨").轨道线条变更($滚动栏/容器/线条停止变更/编号.value,$滚动栏/容器/线条停止变更/线条.value,网格,纹理)
	pass

func 轨道允许失误():
	get_node("/root/根场景/主场景/无轨").轨道允许失误($滚动栏/容器/允许触碰白块/编号.value,$滚动栏/容器/允许触碰白块/参数.selected-1)
	pass
#事件类型为15，4位base64字符为事件类型，后面采用字典存储
#"I"表示轨道编号，"T"表示处理方法
#轨道编号里，单独的纯数字例如"4"表示只定义第四号轨道，"0～12"表示选择编号0到编号12的13个轨道，"0~12!3~5"表示剔除编号3到编号5的3个轨道定义
#json存储格式类似于：{"I":0,"T":0}
#后续考虑选择占用存储空间更少的存储方式，暂时性定义
func 更改轨道触摸复制() -> void:
	var 事件编号:int=15
	var 对象:Dictionary={"I":$滚动栏/容器/允许触碰白块/编号.value,"T":$滚动栏/容器/允许触碰白块/参数.selected-1}
	print(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	DisplayServer.clipboard_set(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	pass # Replace with function body.

func 调试窗口关闭() -> void:
	if 全局脚本.游戏开始状态==false:
		self.hide()
		$"../../界面动画".play("结算画面返回")
		$"../../游戏界面".hide()
		$'/root/根场景/主场景'.清除物件()
		全局脚本.调试状态=false
	pass

func 修改摄像机() -> void:
	var 参数=$滚动栏/容器/移动摄像机停止/参数.text
	var 位置:Array=["s","s","s"]
	var 旋转:Array=["s","s","s"]
	var 视距:Array=["s","s","s"]
	var 视角偏移:Array=["s","s","s","s"]
	var 分割=参数.split(";")
	if 分割.size()==4:
		if 分割[0].split(",").size()==3:
			位置[0]=分割[0].split(",")[0]
			位置[1]=分割[0].split(",")[1]
			位置[2]=分割[0].split(",")[2]
		if 分割[1].split(",").size()==3:
			旋转[0]=分割[1].split(",")[0]
			旋转[1]=分割[1].split(",")[1]
			旋转[2]=分割[1].split(",")[2]
			#旋转[3]=(float($"滚动栏/容器/移动摄像机停止/旋转顺序".selected))
		if 分割[2].split(",").size()==3:
			视距[0]=分割[2].split(",")[0]
			视距[1]=分割[2].split(",")[1]
			视距[2]=分割[2].split(",")[2]
			pass
		if 分割[3].split(",").size()==4:
			视角偏移[0]=分割[3].split(",")[0]
			视角偏移[1]=分割[3].split(",")[1]
			视角偏移[2]=分割[3].split(",")[2]
			视角偏移[3]=分割[3].split(",")[3]
	#位移:Array=["0","0","0"],旋转:Array=["0","0","0"],欧拉角旋转顺序:float=1,投影模式:int=0,视距:Array=["s","s","s"],保持长宽比:int=1,视口偏移:Array=["s","s","s","s"]
	get_node("/root/根场景/主场景/无轨").摄像机停止移动(位置,旋转,$"滚动栏/容器/移动摄像机停止/旋转顺序".selected,$滚动栏/容器/移动摄像机停止/投影模式.selected,视距,$滚动栏/容器/移动摄像机停止/长宽比.selected,视角偏移)
	pass
#位移表达式:Array=["0","0","0"],旋转表达式:Array=["0","0","0"],欧拉角旋转顺序:float=1,投影模式:int=0,视距表达式:Array=["s","s","s"],长宽比:int=1,视口偏移表达式:Array=["s","s","s","s"]
func 摄像机移动():
	var 参数=$滚动栏/容器/移动摄像机/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/移动摄像机/旋转顺序.selected
	var 平移:Array
	var 旋转:Array
	var 视距:Array
	var 视角偏移:Array
	if 分割.size()==4:
		平移=分割[0].split(",")
		旋转=分割[1].split(",")
		视距=分割[2].split(",")
		视角偏移=分割[3].split(",")
		get_node("/root/根场景/主场景/无轨").摄像机移动(平移,旋转,欧拉角旋转顺序,$滚动栏/容器/移动摄像机/投影模式.selected,视距,$滚动栏/容器/移动摄像机/长宽比.selected,视角偏移)
	pass

func 移动摄像机复制() -> void:
	var 事件编号:int=9
	var 参数=$滚动栏/容器/移动摄像机/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/移动摄像机/旋转顺序.selected
	var 平移:Array=["0","0","0"]
	var 旋转:Array=["0","0","0"]
	var 视距:Array=["0","0","0"]
	var 视角偏移:Array=["0","0","0","0"]
	if 分割.size()==4:
		平移=分割[0].split(",")
		旋转=分割[1].split(",")
		旋转.push_back(float(欧拉角旋转顺序))
		视距=分割[2].split(",")
		视角偏移=分割[3].split(",")
	var 对象:Dictionary={"T":$滚动栏/容器/移动摄像机/投影模式.selected,"K":$滚动栏/容器/移动摄像机/长宽比.selected,"P":平移,"R":旋转,"O":视距,"E":视角偏移}
	print(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	DisplayServer.clipboard_set(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	pass # Replace with function body.

#事件类型为8，4位base64字符为事件类型，后面采用字典存储
#“T”表示摄像机投影模式，"P"表示轨道位置，“R”表示旋转（四个元素中第一个表示旋转方式，若第一个元素数值小于1则成为四元数的w值）,"K"表示投影长宽比，"O"表示其他参数（视野/投影大小，裁剪近视距，裁剪远视距），"E"表示投影偏移
#json存储格式类似于：{"T":0,"K":0,"P":[0,0,0],"R":[0,0,0,0],"O":[1,1,1],"E":[0,0,0,0]}
#后续考虑选择占用存储空间更少的存储方式，暂时性定义
func 修改摄像机复制() -> void:
	var 事件编号:int=8
	var 参数=$滚动栏/容器/移动摄像机停止/参数.text
	var 位置:Array=["s","s","s"]
	var 旋转:Array=["s","s","s",0.0]
	var 视距:Array=["s","s","s"]
	var 视角偏移:Array=["s","s","s","s"]
	var 分割=参数.split(";")
	if 分割.size()==4:
		if 分割[0].split(",").size()==3:
			位置[0]=分割[0].split(",")[0]
			位置[1]=分割[0].split(",")[1]
			位置[2]=分割[0].split(",")[2]
		if 分割[1].split(",").size()==3:
			旋转[0]=分割[1].split(",")[0]
			旋转[1]=分割[1].split(",")[1]
			旋转[2]=分割[1].split(",")[2]
			旋转[3]=(float($"滚动栏/容器/移动摄像机停止/旋转顺序".selected))
		if 分割[2].split(",").size()==3:
			视距[0]=分割[2].split(",")[0]
			视距[1]=分割[2].split(",")[1]
			视距[2]=分割[2].split(",")[2]
			pass
		if 分割[3].split(",").size()==4:
			视角偏移[0]=分割[3].split(",")[0]
			视角偏移[1]=分割[3].split(",")[1]
			视角偏移[2]=分割[3].split(",")[2]
			视角偏移[3]=分割[3].split(",")[3]
	var 对象:Dictionary={"T":$滚动栏/容器/移动摄像机停止/投影模式.selected,"K":$滚动栏/容器/移动摄像机停止/长宽比.selected,"P":位置,"R":旋转,"O":视距,"E":视角偏移}
	print(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	DisplayServer.clipboard_set(全局脚本.整数转六十四进制(事件编号,2)+var_to_str(对象))
	pass # Replace with function body.

func 添加物件() -> void:
	var 选项=$滚动栏/容器/添加物件/类型.selected
	var 参数=$滚动栏/容器/添加物件/参数.text
	var 欧拉角旋转顺序=$滚动栏/容器/添加物件/旋转顺序.selected
	var 轨道编号=$滚动栏/容器/添加物件/轨道编号.value
	var 位置=Vector3(0,0,0)
	var 旋转=Vector3(0,0,0)
	var 缩放=Vector3(1,1,1)
	var 分割=参数.split(";")
	var 默认移动方式=$滚动栏/容器/添加物件/参数2.button_pressed
	if 分割.size()==3:
		if 分割[0].split(",").size()==3:
			位置=Vector3(float(分割[0].split(",")[0]),float(分割[0].split(",")[1]),float(分割[0].split(",")[2]))
		if 分割[1].split(",").size()==3:
			旋转=Vector3(float(分割[1].split(",")[0]),float(分割[1].split(",")[1]),float(分割[1].split(",")[2]))
		if 分割[2].split(",").size()==3:
			缩放=Vector3(float(分割[2].split(",")[0]),float(分割[2].split(",")[1]),float(分割[2].split(",")[2]))
	get_node("/root/根场景/主场景/无轨").添加物件(选项,轨道编号,$滚动栏/容器/添加物件/编号.value,位置,旋转,欧拉角旋转顺序,缩放,默认移动方式)
	pass

func 删除轨道() -> void:
	get_node("/root/根场景/主场景/无轨").删除轨道($滚动栏/容器/删除轨道/参数.value)
	pass

func 移动物件() -> void:
	var 参数=$滚动栏/容器/移动物件/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/移动物件/旋转顺序.selected
	var 平移
	var 旋转
	var 缩放
	if 分割.size()==3:
		平移=分割[0].split(",")
		旋转=分割[1].split(",")
		缩放=分割[2].split(",")
		get_node("/root/根场景/主场景/无轨").物件移动($滚动栏/容器/移动物件/编号.value,平移,旋转,欧拉角旋转顺序,缩放)
	pass
func 移动物件停止():
	var 参数=$滚动栏/容器/移动物件停止/参数.text
	var 分割=参数.split(";")
	var 欧拉角旋转顺序=$滚动栏/容器/移动物件停止/旋转顺序.selected
	if 分割.size()==3:
		var 平移=分割[0].split(",")
		var 旋转=分割[1].split(",")
		var 缩放=分割[2].split(",")
		get_node("/root/根场景/主场景/无轨").物件停止移动($滚动栏/容器/移动物件停止/编号.value,平移,旋转,欧拉角旋转顺序,缩放)
	pass
func 删除物件() -> void:
	get_node("/root/根场景/主场景/无轨").删除物件($滚动栏/容器/删除物件/编号.value)
	pass
func 设置背景音频():
	get_node("/root/根场景/主场景/无轨").设置背景音频($滚动栏/容器/播放音频/空音频.button_pressed,$滚动栏/容器/播放音频/文件路径.text)
	pass
