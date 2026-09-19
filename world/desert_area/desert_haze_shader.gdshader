shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform bool enabled = false;
uniform sampler2D distort_texture;

void fragment() {
	vec2 distortedUV = SCREEN_UV + texture(distort_texture, UV).r * 0.003;
	vec4 screenColor = texture(SCREEN_TEXTURE, distortedUV);
	COLOR = screenColor * float(enabled);
	//COLOR = vec4(UV.x,UV.y,0,1);
}