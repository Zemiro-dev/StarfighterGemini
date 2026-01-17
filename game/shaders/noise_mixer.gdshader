shader_type canvas_item;
#include "includes/glint.gdshaderinc"


uniform vec2 noise0_offset;
uniform vec2 noise1_offset;
uniform vec2 noise0_speed = vec2(.1, 0.);
uniform vec2 noise1_speed = vec2(-.1, 0.);
uniform float zoom : hint_range(0.1, 10.0, 0.001) = 1.0;
uniform bool apply_feedback = true;
uniform bool use_mix_fn = true;
uniform float mix_ratio : hint_range(-1.0, 2.0, 0.001) = 0.5;
uniform sampler2D noise0_texture : repeat_enable;
uniform sampler2D noise1_texture : repeat_enable;
uniform sampler2D noise0_gradient;
uniform sampler2D noise1_gradient;

void fragment() {
	vec2 uv = UV * zoom;
	float noise_rng[2] = float[2] (
		texture(noise0_texture, uv + noise0_offset + TIME * noise0_speed).r,
		texture(noise1_texture, uv + noise1_offset + TIME * noise1_speed).r
	);
	if (apply_feedback) {
		noise_rng[0] *= noise_rng[1];
	}
	
	vec4 noise_color[2] = vec4[2] (
		texture(noise0_gradient, vec2(noise_rng[0])),
		texture(noise1_gradient, vec2(noise_rng[1]))
	);
	if (use_mix_fn) {
		COLOR = hdrout(mix(noise_color[0], noise_color[1], mix_ratio));
	} else {
		COLOR = hdrout(noise_color[0] * noise_color[1]);
	}
}

//
	//float noise1_strength = texture(_noise1, UV + scroll1 * TIME * .1).r;
	//float noise2_strength = texture(_noise2, UV + scroll1 * TIME * .3).r;
	//float strength = noise1_strength * noise2_strength;
	//vec4 top_light = smoothstep(light_start, light_end, strength) * top_color;
	//strength = .5 + (strength - .5) * .3;
	//COLOR = mix(PURPLE_BLACK, PURPLE, strength) + top_light;