shader_type canvas_item;

uniform bool enabled = false;
uniform vec4 color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(enabled){
		if(COLOR.a != 0.0){
			COLOR = color;
		}
	}
}
