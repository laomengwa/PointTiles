//渲染类型：3D渲染
shader_type spatial;
//渲染模式 忽略引擎内置光线处理器
render_mode unshaded;
//屏幕纹理
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
//导出 四维浮点型 外框线 资源颜色
uniform vec4 outline_color : source_color;
//赋值 描边线宽=2.0
uniform float outline_width = 2.0;
uniform float alpha = 1.0;
//片段着色器
void fragment() {
	//屏幕纹理
	vec4 WenLi=texture(SCREEN_TEXTURE,SCREEN_UV);
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	ALBEDO = WenLi.rgb;
	for(int y = -1 * int(outline_width);y <= 1 * int(outline_width); y++){
		for(int x = -1 * int(outline_width);x <= 1 * int(outline_width); x++){
			vec4 tex = texture(SCREEN_TEXTURE,SCREEN_UV+vec2(float(y),float(x))*pixel_size);
			if(tex.a==0.0){
				ALPHA=alpha;
				ALBEDO = outline_color.rgb;
			}
		}
	}
}