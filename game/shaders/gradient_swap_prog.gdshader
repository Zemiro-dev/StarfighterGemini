shader_type canvas_item;
#include "includes/glint.gdshaderinc"
//https://godotshaders.com/shader/starfield/
uniform sampler2D gradient_texture_low;
uniform sampler2D gradient_texture_high;
uniform float progress : hint_range(0.0, 1.0, 0.001) = 0.0;

uniform bool use_distortion = false;
uniform sampler2D wibbly_noise1 : repeat_enable;
uniform sampler2D wibbly_noise2 : repeat_enable;
uniform float strength;
uniform float fps;
uniform int frames = 256;

void fragment() {
	vec2 uv = UV;

	if (use_distortion) {
		float c = clock(TIME, float(frames), fps); //Get clock frame
		vec4 offset1 = texture(wibbly_noise1, uv+c); //Get offset
		vec4 offset2 = texture(wibbly_noise2,uv+c);
		vec4 offset = offset1*offset2*strength;
		uv += offset.xy - vec2(.5) * strength;
	}


	vec4 texture_color = texture(TEXTURE, uv);
	vec4 out_color = vec4(
		mix(
			texture(gradient_texture_low, vec2(texture_color.r, texture_color.r)).rgb,
			texture(gradient_texture_high, vec2(texture_color.r, texture_color.r)).rgb,
			progress
		),
		texture_color.a
	);
	COLOR = hdrout(out_color);
}
