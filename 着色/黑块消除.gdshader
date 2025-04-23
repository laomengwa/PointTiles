shader_type spatial;//着色器类型：模型
render_mode blend_mix,unshaded,cull_disabled,depth_draw_always,diffuse_toon,specular_toon;
uniform float alpha = 1.0;
uniform vec4 color : source_color;
uniform float time = 0.0;
//顶点着色器
void vertex(){
	VERTEX += (time * vec4(VERTEX, 1.0)).xyz;
}
//片段着色器
void fragment() {
	ALBEDO=color.rgb;
	ALPHA=alpha;
}
