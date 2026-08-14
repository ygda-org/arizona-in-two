shader_type canvas_item;

uniform sampler2D noise : repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	// Called for every pixel the material is visible on.
	COLOR = texture(noise, UV / 3.0 + vec2(TIME * -0.1, 0.0) / 3.0);
	//COLOR = texture(noise, (UV + sin(TIME * 0.1) + 1.0) / 3.0);
}