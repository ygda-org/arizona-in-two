shader_type canvas_item;

uniform sampler2D noise : repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	// Called for every pixel the material is visible on.
	COLOR = texture(noise, UV / 3.0);
}