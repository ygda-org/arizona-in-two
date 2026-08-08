shader_type canvas_item;

void vertex() {
	VERTEX.y += sin(TIME)*2.0;
}

void fragment() {
	if ((COLOR.b > 0.1 && COLOR.r < 0.8) || (UV.x > 0.857 || UV.x < 0.143 || UV.y > 0.833 || UV.y < 0.15) || (UV.x > 0.70 && UV.y > 0.80))
	{
		COLOR.a = 0.0;
	}
}
