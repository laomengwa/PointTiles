shader_type spatial;
render_mode unshaded,cull_disabled,depth_draw_always,diffuse_toon,specular_toon;
uniform float alpha = 1.0;
uniform vec4 color : source_color;
uniform float time = 0.0;
void vertex(){
	VERTEX += (time * vec4(VERTEX, 1.0)).xyz;
}
void fragment() {
	ALBEDO=color.rgb;
	ALPHA=alpha;
}
