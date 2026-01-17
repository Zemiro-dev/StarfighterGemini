// Port of Stars Shader by gerardogc2378
// https://godotshaders.com/shader/stars-shader/
// LICENSE: CC0
shader_type canvas_item;

#include "includes/glint.gdshaderinc"

uniform sampler2D star_noise : repeat_enable;
uniform float star_noise_resolution : hint_range(2., 1028., 1.) = 256.;
uniform float star_noise_boost : hint_range(1.0, 2.0, .01) = 1.5;
uniform vec4 bg_color: source_color = vec4(0.0);
uniform sampler2D star_gradient;
uniform float cell_size = 64.0;
uniform float star_cutoff : hint_range(0.0, 1.0, 0.01) = .85;
uniform vec2 px_offset = vec2(-256.);
/* Scroll Speed */
uniform vec2 speed = vec2(100., 0.);
uniform float star_size : hint_range(0.0, 1.5, .01) = 1.0;
uniform float margin_value : hint_range(0.0, 1.0, .01) = .85;
uniform float rotation_mod : hint_range(0.0, 1.0, .1) = 1.0;
uniform float min_star_size_and_bright : hint_range(0.0, 1.0, .01) = 0.31;
uniform float star_blink_mod : hint_range(0.0, 100.0, 1.0) = 10.0;
uniform float star_blink_variance : hint_range (0.0, 1.0, 0.01) = .03;
uniform float base_star_bright_min : hint_range(0.0, 5.0, 0.01) = 1.5;
uniform float base_star_bright_max : hint_range(0.0, 5.0, 0.01) = 1.7;

float random(vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// SCREEN_PIXEL_SIZE is the SIZE of a pixel. Typically way less than 1.
// FRAGCOORD is the REAL pixel position. So 1920x1080 kinda values
// 1 / SCREEN_PIXEL_SIZE gives the resolution as wxh
void fragment() {
	vec2 current_offset = px_offset + TIME * speed;
	vec2 resolution = vec2(1.0 / min(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)); //Gets a box based on widest side
	vec2 px = (FRAGCOORD.xy + current_offset) / resolution;
	px *= resolution.x / cell_size;
	px.x += step(1., mod(px.y,2.0)) * (.25);
	px.x += step(1., mod(px.y,3.0)) * (.1);
	px.x += step(1., mod(px.y,4.0)) * (.12);
	//_st.x += step(1., mod(_st.y,2.0)) * 0.1;
	vec2 cell_index = floor(px);
	vec2 cell_uv = fract(px);
	vec4 out_color = bg_color;
	//float star_power = random(cell_index);
	float star_power = min(texture(star_noise, fract(cell_index / star_noise_resolution) ).r * star_noise_boost, 1.0);
	if (star_power > star_cutoff) {
		float star_norm = (star_power - star_cutoff) / (1.0 - star_cutoff);
		float bright = base_star_bright_min + (base_star_bright_max - base_star_bright_min) * max(star_norm, min_star_size_and_bright);
		float modified_size = star_size * max(star_norm, min_star_size_and_bright); 
		vec2 star_offset = vec2(
			random(cell_index + 1.),
			random(cell_index + 2.)
		) * 2. - 1.;
		float t = bright + star_blink_variance
					 * sin(TIME * star_blink_mod + star_power * 45.0 + star_offset.x * 45.0);
		float margin = modified_size * (1. - margin_value);
		star_offset = max(
			min(star_offset, vec2(margin)),
			-vec2(margin)
		);
		vec2 cell_st = (cell_uv + star_offset) * 2. - 1.;
		cell_st = cell_st * rotate2d(TAU * star_norm * rotation_mod);
		float d_star = length(min(abs(cell_st) - modified_size, 0.));
		float star_color = smoothstep(modified_size, modified_size+.1, d_star) * smoothstep(modified_size*2., modified_size*2.-.1, d_star);
		star_color = star_color * t;
		out_color.rgba += hdrout(vec4(star_color)) * texture(star_gradient, vec2(star_norm));
	}
	COLOR = out_color;
	
}

// old
//vec3 star_color = vec3(1.0 - distance(cell_uv, vec2(.5)) / .5) * t * t * t;
//vec3 star_color = vec3(1.0 - distance(cell_uv, vec2(.5)));
//star_color = star_color * t / (abs(cell_uv.x - .5) * cell_size)  * t / (abs(cell_uv.y - .5) * cell_size);
//star_color.rgb = clamp(star_color.rgb, vec3(0.), vec3(1.0));