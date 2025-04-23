extends MeshInstance3D
#这个数组表示模型的变更状态
@export var 网格变更状态:bool=false
@export var 纹理变更状态:bool=false
@export var 网格表达式:Array=["s","s","s"]
@export var 纹理表达式:Array=["s","s","s","s"]
var 静止时刻:Array=[0.0,0.0]
#这个数组用来防止创建脚本的代码每帧都执行，0元素表示网格变更，1元素表示纹理变更
var 状态变更:Array=[false,false]
var 当前网格状态:Array=[0.1,200.0,0.1]
var 当前纹理状态:Color=Color(1,1,1,1)
var 脚本:Array=[Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new(),Object.new()]
func _process(帧处理):
	if 全局脚本.游戏开始状态==false:
		静止时刻=[0.0,0.0]
		网格变更状态=false
		纹理变更状态=false
	if 全局脚本.游戏开始状态==true:
		if 网格变更状态==false:
			静止时刻[0]=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间
			当前网格状态=[self.mesh.size[0],self.mesh.size[1],self.mesh.size[2]]
		elif 网格变更状态==true:
			var 运动时间=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间-静止时刻[0]
			for 循环 in 网格表达式.size():
				#检测表达式变更，以防止代码重复执行
				if 状态变更[0]==false:
					var 公式脚本=GDScript.new()
					#字符串转可执行代码
					公式脚本.set_source_code("extends Object\nfunc 函数(t:float=0):\n\tvar s:float="+var_to_str(当前网格状态[循环])+"\n\treturn("+网格表达式[循环]+")")
					var 公式错误检测=公式脚本.reload()
					if 公式错误检测==OK:
						#检测是否为空实例
						脚本[循环].set_script(公式脚本)
					else:
						print("错误")
				if 脚本[循环].get_script()!=null:
					self.mesh.size[循环]=脚本[循环].函数(运动时间)
				pass
			if 状态变更[0]==false:
				状态变更[0]=true
		if 纹理变更状态==false:
			静止时刻[1]=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间
			当前纹理状态=Color(self.get_material_override().albedo_color.r,self.get_material_override().albedo_color.g,self.get_material_override().albedo_color.b,self.get_material_override().albedo_color.a)
		elif 纹理变更状态==true:
			var 运动时间=$'/root/根场景/视角节点/背景音乐播放节点'.播放时间-静止时刻[1]
			for 循环 in 纹理表达式.size():
				#检测表达式变更，以防止代码重复执行
				if 状态变更[1]==false:
					var 公式脚本=GDScript.new()
					#字符串转可执行代码
					公式脚本.set_source_code("extends Object\nfunc 函数(t:float=0):\n\tvar s:float="+var_to_str(当前纹理状态[循环])+"\n\treturn("+纹理表达式[循环]+")")
					var 公式错误检测=公式脚本.reload()
					if 公式错误检测==OK:
						#检测是否为空实例
						脚本[循环+3].set_script(公式脚本)
					else:
						print("错误")
				if 脚本[循环+3].get_script()!=null:
					self.get_material_override().albedo_color[循环]=脚本[循环+3].函数(运动时间)
				pass
			if 状态变更[1]==false:
				状态变更[1]=true
	pass
