shader_type canvas_item;
#include "includes/glint.gdshaderinc"

uniform vec2 noise0_offset;
uniform vec2 noise1_offset;
uniform vec2 noise0_speed = vec2(.1, 0.);
uniform vec2 noise1_speed = vec2(0.);
uniform float zoom : hint_range(0.1, 10.0, 0.001) = 1.0;
uniform bool apply_feedback = true;
uniform bool use_mix_fn = true;
uniform float mix_ratio : hint_range(-1.0, 2.0, 0.001) = 0.5;
uniform bool use_mix_noise = false;
uniform bool apply_subdistortion = false;
uniform bool subdistortion_locality = true;
uniform float subdistortion_locality_flicker : hint_range(0.0, 50, .001) = 0.0; 
uniform float subdistortion_strength : hint_range(0.0, .3, .001) = .1;
uniform int subdistortion_frames = 256;
uniform float subdistortion_fps = 24.;
uniform sampler2D noise0_texture : repeat_enable;
uniform sampler2D noise1_texture : repeat_enable;
uniform sampler2D noise1_dist1 : repeat_enable;
uniform sampler2D noise1_dist2 : repeat_enable;
uniform sampler2D noise0_gradient;
uniform sampler2D noise1_gradient;
uniform sampler2D noise0_curve : repeat_disable, filter_linear;
uniform sampler2D mix_noise_texture : repeat_enable;
uniform sampler2D mix_noise_curve : repeat_disable, filter_linear;

void fragment() {
	vec2 uv = UV * zoom;
	vec2 uv2 = uv;
	vec2 primary_speed = TIME * noise0_speed;
	if (apply_subdistortion) {
		float sub_clock = clock(TIME, float(subdistortion_frames), subdistortion_fps);
		uv2 = uv;
		vec2 offset1 = texture(noise1_dist1, uv2 + sub_clock + primary_speed).rb;
		vec2 offset2 = texture(noise1_dist2, uv2 + sub_clock + primary_speed).rb;
		uv2 += offset1 * offset2 * subdistortion_strength;
	}
	float noise_rng[2] = float[2] (
		texture(
			noise0_curve,
			vec2(texture(noise0_texture, uv + noise0_offset + primary_speed).r)
		).r,
		texture(noise1_texture, uv2 + noise1_offset + primary_speed + TIME * noise1_speed).r
	);
	if (apply_feedback) {
		noise_rng[1] *= noise_rng[0];
	}
	
	vec4 noise_color[2] = vec4[2] (
		texture(noise0_gradient, vec2(noise_rng[0])),
		texture(noise1_gradient, vec2(noise_rng[1]))
	);
	if (use_mix_fn) {
		float mix_v = mix_ratio;
		if (use_mix_noise) {
			mix_v = texture(mix_noise_texture, primary_speed).r;
			if (subdistortion_locality) {
				mix_v = texture(mix_noise_texture, uv + primary_speed).r * mix_v;
			}
			mix_v = texture(mix_noise_curve, vec2(mix_v, mix_v)).r;
		}
		COLOR = hdrout(mix(noise_color[0], noise_color[1], mix_v));
	} else {
		COLOR = hdrout(noise_color[0] * noise_color[1]);
	}
}