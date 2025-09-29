shader_type spatial;
render_mode unshaded,cull_disabled,depth_draw_always;
//长条按下时间
uniform float time = 0.0;
//按下区域颜色
uniform vec3 color=vec3(0.4,0.7,1.0);
//按下状态
uniform bool state = false;
void vertex() {
	if(state==true){
		//着色片段扩大一圈
		VERTEX += (0.01 * vec4(VERTEX, 1.0)).xyz;
		if(time>1.0){
			VERTEX.y=1.01*VERTEX.y;
		}else if(time<0.0){
			VERTEX.y=0.0;
		}else{
			VERTEX.y+=(time-1.0)*VERTEX.y-(0.01);
		}
	}
}
void fragment() {
	if(state==true){
		ALBEDO=color;
		ALPHA=1.0;
	}else{
		ALPHA=0.0;
	}
}
