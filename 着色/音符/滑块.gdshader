shader_type spatial;//模型类型着色器
uniform sampler2D Texture;//引出纹理参数
uniform bool state;//颜色渐变方向
uniform vec3 color=vec3(1.0,0.0,0.4);
render_mode unshaded,cull_disabled,depth_draw_always,diffuse_toon;
//顶点着色器
void vertex() {
	//VERTEX=vec3(VERTEX.rgb);
}
//片段着色器
void fragment() {
	float v1=0.0;
	//状态决定渐变方向
	if(state==false){
		v1=(1.0-UV.x);
	}else{
		v1=UV.x;
	}
	ALBEDO=texture(Texture,UV).rgb*(1.0-v1)+(color)*v1;
}
