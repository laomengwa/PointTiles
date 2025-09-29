extends MeshInstance3D
@export var 顶点:PackedVector3Array
func _ready():
	# 创建ArrayMesh实例
	var 网格 = ArrayMesh.new()
	# 定义顶点数组
	顶点 = PackedVector3Array([
		Vector3(-1, 0, -1), Vector3(-1, 0, 1), Vector3(1, 0, -1), Vector3(1, 0, 1),
		Vector3(-1, 2, -1), Vector3(-1, 2, 1), Vector3(1, 2, -1), Vector3(1, 2, 1),
		Vector3(-2, 5, -1), Vector3(-2, 5, 1), Vector3(0, 5, -1), Vector3(0, 5, 1),
		Vector3(-4, 7, -1), Vector3(-4, 7, 1), Vector3(-2, 7, -1), Vector3(-2, 7, 1),
		Vector3(-4, 10, -1), Vector3(-4, 10, 1), Vector3(-2, 10, -1), Vector3(-2, 10, 1)
	])
	# 生成索引数组（每4个顶点生成6个索引）
	#确认顶点数量是否为4的倍数
	if 顶点.size()%4!=0:
		顶点.resize((顶点.size()/4)*4)
	var 顶点索引 = PackedInt32Array()
	#创建底面
	顶点索引.append_array([
		0,1,3,
		0,3,2
	])
	#创建顶面
	var 末尾索引=range(0, 顶点.size(), 4)[range(0, 顶点.size(), 4).size()-1]
	顶点索引.append_array([
		末尾索引,末尾索引+1,末尾索引+3,
		末尾索引,末尾索引+3,末尾索引+2
	])
	#创建侧面
	for 顶点组 in range(0, 顶点.size()-4, 4):
		顶点索引.append_array([
			顶点组, 顶点组+1, 顶点组+4,
			顶点组+1, 顶点组+4, 顶点组+5,
			
			顶点组, 顶点组+2, 顶点组+6,
			顶点组, 顶点组+4, 顶点组+6,
			
			顶点组+2, 顶点组+3, 顶点组+7,
			顶点组+2, 顶点组+6, 顶点组+7,
			
			顶点组+3, 顶点组+1, 顶点组+7,
			顶点组+1, 顶点组+5, 顶点组+7,
		])
	#配置UV坐标
	var 贴图网格坐标 = PackedVector2Array()
	for 顶点组 in range(0, 顶点.size(), 4):
		贴图网格坐标.append_array([
			Vector2(0, 0.25),   # 左上角
			Vector2(1, 0),   # 右下角
			Vector2(1, 0.25),    # 右上角
			Vector2(0, 0)   # 左下角
		])
	# 定义法线数组（所有法线朝上）
	var 法向量 = PackedVector3Array()
	法向量.resize(顶点.size())
	for 循环 in 法向量.size():
		法向量[循环] = Vector3(0,1,0)
	# 配置表面数据
	var 模型面组 = []
	模型面组.resize(ArrayMesh.ARRAY_MAX)
	模型面组[ArrayMesh.ARRAY_VERTEX] = 顶点
	模型面组[ArrayMesh.ARRAY_INDEX] = 顶点索引
	模型面组[ArrayMesh.ARRAY_NORMAL] = 法向量
	模型面组[ArrayMesh.ARRAY_TEX_UV] = 贴图网格坐标
	#同步模型和碰撞箱形状
	var 碰撞箱面组 = PackedVector3Array()
	for 循环 in 顶点索引.size():
		碰撞箱面组.push_back(顶点[顶点索引[循环]])
	$'../触摸区域/碰撞箱'.shape.set_faces(碰撞箱面组)
	# 添加表面到ArrayMesh
	网格.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, 模型面组)
	# 将ArrayMesh赋给当前节点
	self.mesh = 网格
