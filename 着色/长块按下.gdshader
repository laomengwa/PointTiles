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
		VERTEX += (0.01 * vec4(VERTEX, 1.0)).xyz;
		VERTEX.y+=(time-1.0)*VERTEX.y-(0.01);
		//VERTEX.y += 0.25 + sin(TIME * 2.0) * rand(vec2(VERTEX.xz)) * 0.5;
		//VERTEX.y +=3.0* cos(VERTEX.z);
	}
}
//vec3 wave(vec2 uv){
	//return color*step(0.5-sin(uv.x+TIME),uv.y);
//}
void fragment() {
	if(state==true){
		ALBEDO=color;
		ALPHA=1.0;
		//vec3 wave=wave(UV);
		//COLOR.rgb=mix(color,wave,0.0).rgb;
	}else{
		ALPHA=0.0;
	}
}
