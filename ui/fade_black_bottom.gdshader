shader_type canvas_item;
void fragment() {
	COLOR.rgb = vec3(1.0 -UV.y) * (COLOR.rgb * 1.5);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
