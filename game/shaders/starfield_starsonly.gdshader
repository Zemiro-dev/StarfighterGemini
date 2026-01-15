// Port of Stars Shader by gerardogc2378
// https://godotshaders.com/shader/stars-shader/
// LICENSE: CC0
shader_type canvas_item;

#include "includes/glint.gdshaderinc"

uniform vec4 bg_color: source_color;
uniform float cell_size = 100.0;
uniform float star_cutoff = .5;
uniform vec2 px_offset = vec2(-256.);
/* Scroll Speed */
uniform vec2 speed = vec2(100., 0.);
uniform float star_size = .3;
uniform float margin_value = 1.;

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
	vec2 cell_index = floor(px);
	vec2 cell_uv = fract(px);
	vec4 out_color = vec4(0.0);
	float star_power = random(cell_index);
	if (star_power > star_cutoff) {
		float t = 1. + 0.2 * sin(TIME * 8.0 + (star_power - star_cutoff) / (1.0 - star_cutoff) * 45.0);
		float modified_size = star_size * star_power; 
		vec2 star_offset = vec2(
			random(cell_index + 1.),
			random(cell_index + 2.)
		) * 2. - 1.;
		float margin = modified_size * (1. - margin_value);
		star_offset = max(
			min(star_offset, vec2(margin)),
			-vec2(margin)
		);
		vec2 cell_st = (cell_uv + star_offset) * 2. - 1.;
		float d_star = length(min(abs(cell_st) - modified_size, 0.));
		vec3 star_color = vec3(smoothstep(modified_size, modified_size+.1, d_star) * smoothstep(modified_size*2., modified_size*2.-.1, d_star));
		star_color = star_color * t;
		out_color.rgb += star_color;
	}
	out_color.a = 1.0;
	COLOR = hdrout(out_color);
	
}

// old
//vec3 star_color = vec3(1.0 - distance(cell_uv, vec2(.5)) / .5) * t * t * t;
//vec3 star_color = vec3(1.0 - distance(cell_uv, vec2(.5)));
//star_color = star_color * t / (abs(cell_uv.x - .5) * cell_size)  * t / (abs(cell_uv.y - .5) * cell_size);
//star_color.rgb = clamp(star_color.rgb, vec3(0.), vec3(1.0));