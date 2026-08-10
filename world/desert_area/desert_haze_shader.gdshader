shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform bool disable = true;
uniform sampler2D distort_texture;

void fragment() {
	if (disable)
		COLOR.a = 0.0;
	else {
	vec2 distortedUV = SCREEN_UV + texture(distort_texture, UV).r * 0.003;
	vec4 screenColor = texture(SCREEN_TEXTURE, distortedUV);
	COLOR = screenColor; }
}