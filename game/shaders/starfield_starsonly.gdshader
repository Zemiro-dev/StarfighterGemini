// Port of Stars Shader by gerardogc2378
// https://godotshaders.com/shader/stars-shader/
// LICENSE: CC0
shader_type canvas_item;

uniform vec4 bg_color: source_color;
uniform float cell_count = 10.0;
uniform float cell_size = 100.0;
uniform float star_cutoff = .5;
uniform vec2 px_offset = vec2(-256.);
/* Scroll Speed */
uniform vec2 speed = vec2(100., 0.);

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
	vec4 out_color = bg_color;
	float star_power = random(cell_index);
	if (star_power > star_cutoff) {
		out_color.rgb += vec3(star_power);
	}


	//if (starValue > prob)
	//{
		//vec2 center = size * pos + vec2(size, size) * 0.5;
		//float t = 0.9 + 0.2 * sin(TIME * 8.0 + (starValue - prob) / (1.0 - prob) * 45.0);
		//color = 1.0 - distance(FRAGCOORD.xy, center) / (0.5 * size);
		//color = color * t / (abs(FRAGCOORD.y - center.y)) * t / (abs(FRAGCOORD.x - center.x));
	//}
	//else if (rand(SCREEN_UV.xy / 20.0) > 0.996)
	//{
		//float r = rand(SCREEN_UV.xy);
		//color = r * (0.85 * sin(TIME * .25 * (r * 5.0) + 720.0 * r) + 0.95);
	//}
	COLOR = out_color;
	
}

/* Scrolling Tile creation*/
/* Tiles appear pretty reused, need to figure out how to get this into glint, but not atm*/
	//vec2 current_offset = px_offset + TIME * speed;
	//vec2 resolution = vec2(1.0 / min(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)); //Gets a box based on widest side
	//vec2 px = (FRAGCOORD.xy + current_offset) / resolution;
	//px *= resolution.x / cell_size;
	//vec2 cell_index = floor(px);
	//vec2 cell_uv = fract(px);
	//vec4 out_color = bg_color;
	//float star_power = random(cell_index);
	//if (star_power > star_cutoff) {
		//out_color.rgb += vec3(star_power);
	//}