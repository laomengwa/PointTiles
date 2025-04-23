shader_type sky;
uniform sampler2D Texture;
void sky() {
	COLOR=texture(Texture,vec2(SKY_COORDS.x+TIME/100.0,SKY_COORDS.y)).rgb;
}