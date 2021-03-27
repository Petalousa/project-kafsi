shader_type canvas_item;

uniform float alpha = 1.0;
uniform vec3 input_color = vec3(1.0, 0.0, 0.0);

void fragment(){
	vec2 pos = vec2(0.5, 0.5);
	float centre_dist = distance(UV, pos);
	COLOR = vec4(input_color, centre_dist * 0.2 * alpha);
}