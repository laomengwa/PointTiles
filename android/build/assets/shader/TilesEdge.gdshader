//渲染类型：3D渲染
shader_type spatial;
//渲染模式 忽略引擎内置光线处理器
render_mode unshaded;
//导出 
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
//导出 四维浮点型 外框线 资源颜色
uniform vec4 outline_color : source_color;
//赋值 描边线宽=2.0
uniform float outline_width = 2.0;
//声明
void fragment() {
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	ALBEDO = vec3(0,0,0);
	for(int x = -1 * int(outline_width);x <= 1 * int(outline_width); x++){
		for(int y = -1 * int(outline_width);y <= 1 * int(outline_width); y++){
			vec4 tex = texture(SCREEN_TEXTURE,SCREEN_UV+vec2(float(x),float(y))*pixel_size);
			if(tex.a==0.0){
				ALBEDO = outline_color.rbg;
			}
		}
	}
}