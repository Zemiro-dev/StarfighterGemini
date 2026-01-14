shader_type canvas_item;
//https://godotshaders.com/shader/starfield/
uniform sampler2D gradient_texture_low;
uniform sampler2D gradient_texture_high;
uniform float progress : hint_range(0.0, 1.0, 0.001) = 0.0;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 out_color = vec4(
		mix(
			texture(gradient_texture_low, vec2(texture_color.r, texture_color.r)).rgb,
			texture(gradient_texture_high, vec2(texture_color.r, texture_color.r)).rgb,
			progress
		),
		texture_color.a
	);
	COLOR = out_color;
}
