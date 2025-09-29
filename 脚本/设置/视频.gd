extends ScrollContainer

var 垂直同步数据:int=0
var 帧率设置数据:int=60
var 采样抗锯齿数据:int=0
var 空间抗锯齿数据:bool=false
var 渲染精度数据:float=1.0

func 读取设置数据(配置文件路径):
	var 设置数据=ConfigFile.new()
	var 读取结果=设置数据.load(配置文件路径)
	if 读取结果==OK:
		if 设置数据.has_section("视频"):
			if 设置数据.has_section_key("视频","垂直同步"):
				垂直同步数据=设置数据.get_value("视频","垂直同步")
			if 设置数据.has_section_key("视频","帧率设置"):
				帧率设置数据=设置数据.get_value("视频","帧率设置")
			if 设置数据.has_section_key("视频","多重采样抗锯齿"):
				采样抗锯齿数据=设置数据.get_value("视频","多重采样抗锯齿")
			if 设置数据.has_section_key("视频","快速近似抗锯齿"):
				空间抗锯齿数据=设置数据.get_value("视频","快速近似抗锯齿")
			if 设置数据.has_section_key("视频","渲染精度"):
				渲染精度数据=设置数据.get_value("视频","渲染精度")
func 保存设置数据(设置数据):
	设置数据.set_value("视频","垂直同步",垂直同步数据)
	设置数据.set_value("视频","多重采样抗锯齿",采样抗锯齿数据)
	设置数据.set_value("视频","快速近似抗锯齿",空间抗锯齿数据)
	设置数据.set_value("视频","渲染精度",渲染精度数据)
	设置数据.set_value("视频","帧率设置",帧率设置数据)
func 设置应用():
	#垂直同步状态
	DisplayServer.window_set_vsync_mode(垂直同步数据)
	$'视频/画质/容器/垂直同步/选项'.selected=垂直同步数据
	#帧率限制设置
	Engine.set_max_fps(帧率设置数据)
	$'视频/画质/容器/帧率设置/滑块'.value=帧率设置数据
	#MSAA设置
	get_viewport().msaa_3d=采样抗锯齿数据
	get_viewport().msaa_2d=采样抗锯齿数据
	$'视频/画质/容器/多重采样抗锯齿/选项'.selected=采样抗锯齿数据
	#FXAA设置
	get_viewport().screen_space_aa=空间抗锯齿数据 as int
	$'视频/画质/容器/快速近似抗锯齿/选项'.button_pressed=空间抗锯齿数据
	#渲染精度设置
	get_viewport().set_scaling_3d_scale(渲染精度数据)
	$'视频/画质/容器/渲染精度/滑块'.value=渲染精度数据
	pass
	
func 渲染精度(值):
	渲染精度数据=值
	$视频/画质/容器/渲染精度/数值.text=var_to_str(值)
	get_viewport().set_scaling_3d_scale(值)
	pass # Replace with function body.

func 渲染精度重置():
	$视频/画质/容器/渲染精度/滑块.value=1
	$视频/画质/容器/渲染精度/数值.text="1.0"
	pass # Replace with function body.

func 时间抗锯齿():
	if $视频/画质/容器/时间抗锯齿/选项.button_pressed==true:
		get_viewport().use_taa=1
	else:
		get_viewport().use_taa=0
	pass # Replace with function body.

func 空间抗锯齿(选项):
	match 选项:
		0:
			空间抗锯齿数据=false
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		1:
			空间抗锯齿数据=true
			get_viewport().screen_space_aa=Viewport.SCREEN_SPACE_AA_FXAA
	pass # Replace with function body.

func 多重采样抗锯齿(值):
	采样抗锯齿数据=值
	get_viewport().msaa_3d=值
	get_viewport().msaa_2d=值
	pass

func 帧率设置(值):
	帧率设置数据=值
	if 值<135.0:
		$'视频/画质/容器/帧率设置/数值'.text=var_to_str(int(值))
		Engine.set_max_fps(值)
	else:
		$'视频/画质/容器/帧率设置/数值'.text="无限帧"
		Engine.set_max_fps(0)
	pass # Replace with function body.


func 垂直同步(值):
	垂直同步数据=值
	match 值:
		0:
			DisplayServer.window_set_vsync_mode(0)
		1:
			DisplayServer.window_set_vsync_mode(1)
		2:
			DisplayServer.window_set_vsync_mode(2)
		3:
			DisplayServer.window_set_vsync_mode(3)
	pass # Replace with function body.

func 阴影像素(选项):
	match 选项:
		0:#极低
			RenderingServer.directional_shadow_atlas_set_size(1024, true)
			get_viewport().positional_shadow_atlas_size = 1024
		1:#低
			RenderingServer.directional_shadow_atlas_set_size(2048, true)
			get_viewport().positional_shadow_atlas_size = 2048
		2:#中
			RenderingServer.directional_shadow_atlas_set_size(4096, true)
			get_viewport().positional_shadow_atlas_size = 4096
		3:#高
			RenderingServer.directional_shadow_atlas_set_size(8192, true)
			get_viewport().positional_shadow_atlas_size = 8192
		4:#极高
			RenderingServer.directional_shadow_atlas_set_size(16384, true)
			get_viewport().positional_shadow_atlas_size = 16384
	pass

func 阴影质量(选项):
	match 选项:
		0:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
		1:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		2:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		3:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		4:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		5:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
	pass

func 网格精度(选项):
	match 选项:
		0:
			get_viewport().mesh_lod_threshold = 8.0
		1:
			get_viewport().mesh_lod_threshold = 4.0
		2:
			get_viewport().mesh_lod_threshold = 2.0
		3:
			get_viewport().mesh_lod_threshold = 1.0
		4:
			get_viewport().mesh_lod_threshold = 0.0
	pass

func 全局光照(选项):
	match 选项:
		0:
			$'/root/根场景/天空盒'.environment.sdfgi_enabled = false
		1:
			$'/root/根场景/天空盒'.environment.sdfgi_enabled = true
			RenderingServer.gi_set_use_half_resolution(true)
		2:
			$'/root/根场景/天空盒'.environment.sdfgi_enabled = true
			RenderingServer.gi_set_use_half_resolution(false)
	pass

func 泛光效果(选项):
	match 选项:
		0:
			$'/root/根场景/天空盒'.environment.glow_enabled = false
		1:
			$'/root/根场景/天空盒'.environment.glow_enabled = true
	pass

func 环境光遮蔽(选项):
	match 选项:
		0:
			$'/root/根场景/天空盒'.environment.ssao_enabled = false
		1:
			$'/root/根场景/天空盒'.environment.ssao_enabled = true
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_VERY_LOW, true, 0.5, 2, 50, 300)
		2:
			$'/root/根场景/天空盒'.environment.ssao_enabled = true
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_LOW, true, 0.5, 2, 50, 300)
		3:
			$'/root/根场景/天空盒'.environment.ssao_enabled = true
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_MEDIUM, true, 0.5, 2, 50, 300)
		4:
			$'/root/根场景/天空盒'.environment.ssao_enabled = true
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_HIGH, true, 0.5, 2, 50, 300)
		5:
			$'/root/根场景/天空盒'.environment.ssao_enabled = true
			RenderingServer.environment_set_ssao_quality(RenderingServer.ENV_SSAO_QUALITY_ULTRA, true, 0.5, 2, 50, 300)
	pass

func 屏幕空间反射(选项):
	match 选项:
		0:
			$'/root/根场景/天空盒'.environment.set_ssr_enabled(false)
		1:
			$'/root/根场景/天空盒'.environment.set_ssr_enabled(true)
			$'/root/根场景/天空盒'.environment.set_ssr_max_steps(8)
		2:
			$'/root/根场景/天空盒'.environment.set_ssr_enabled(true)
			$'/root/根场景/天空盒'.environment.set_ssr_max_steps(32)
		3:
			$'/root/根场景/天空盒'.environment.set_ssr_enabled(true)
			$'/root/根场景/天空盒'.environment.set_ssr_max_steps(56)
	pass

func 间接照明(选项):
	match 选项:
		0:
			$'/root/根场景/天空盒'.environment.ssil_enabled = false
		1:
			$'/root/根场景/天空盒'.environment.ssil_enabled = true
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_VERY_LOW, true, 0.5, 4, 50, 300)
		2:
			$'/root/根场景/天空盒'.environment.ssil_enabled = true
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_LOW, true, 0.5, 4, 50, 300)
		3:
			$'/root/根场景/天空盒'.environment.ssil_enabled = true
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_MEDIUM, true, 0.5, 4, 50, 300)
		4:
			$'/root/根场景/天空盒'.environment.ssil_enabled = true
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_HIGH, true, 0.5, 4, 50, 300)
		5:
			$'/root/根场景/天空盒'.environment.ssil_enabled = true
			RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_ULTRA, true, 0.5, 4, 50, 300)
	pass

func 体积雾(选项):
	match 选项:
		0:
			$'/root/根场景/天空盒'.environment.volumetric_fog_enabled = false
		1: # Low
			$'/root/根场景/天空盒'.environment.volumetric_fog_enabled = true
			RenderingServer.environment_set_volumetric_fog_filter_active(false)
		2: # High
			$'/root/根场景/天空盒'.environment.volumetric_fog_enabled = true
			RenderingServer.environment_set_volumetric_fog_filter_active(true)
	pass
