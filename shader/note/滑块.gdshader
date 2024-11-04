shader_type spatial;
uniform sampler2D Texture;
render_mode unshaded,cull_disabled,depth_draw_always,diffuse_toon;
//#define A(x) sin(x)*0.5+0.5
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//ALBEDO=vec3(A(UV.x),A(UV.y),A(UV.x*UV.y));
	ALBEDO=texture(Texture,vec2(UV.rg)).rgb;
	//ALBEDO=vec3(UV.x,UV.y,0.0);
}
