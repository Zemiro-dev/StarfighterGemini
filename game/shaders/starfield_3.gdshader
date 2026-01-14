// Star Nest by Pablo Roman Andrioli
// Ported to Godot by Zemiro
// License: MIT
shader_type canvas_item;

#include "includes/glint.gdshaderinc"

uniform int iterations = 17;
uniform float formuparam: hint_range(0.0, 1.0, .001) = 0.53;

uniform int volsteps = 20;
uniform float stepsize = 0.1;

uniform float zoom = 0.8000;
uniform float tile = 0.850;
uniform float speed = 0.010;

uniform float brightness = 0.0015;
uniform float darkmatter = 0.300;
uniform float distfading = 0.730;
uniform float saturation = 0.850;

uniform vec2 rotation = vec2(0.0);
uniform vec2 scroll = vec2(0.0);
/** 
* Hollows out the stars some to prvent glitter
*/
uniform float hollow_star: hint_range(0.0, 0.002, 0.00001) = 0.00036;

void fragment() {
	vec2 resolution = 5.0 / SCREEN_PIXEL_SIZE;
	
	vec2 realScroll = vec2(scroll.x + TIME * speed, scroll.y);
	vec2 uv = FRAGCOORD.xy / resolution.xy + realScroll;
	uv.y *= resolution.y / resolution.x;
	vec3 dir = vec3(uv * zoom, 1.0);
	float time = 1. * speed + .25;
	
	float a1 = .5 + rotation.x / resolution.x * 2.0;
	float a2 = .8 * rotation.y / resolution.y * 2.0;
	mat2 rot1 = mat2(vec2(cos(a1), sin(a1)), vec2(-sin(a1), cos(a1)));
	mat2 rot2 = mat2(vec2(cos(a2), sin(a2)), vec2(-sin(a2), cos(a2)));
	dir.xz *= rot1;
	dir.xy *= rot2;
	vec3 from = vec3(1., 0.5, 0.5);
	from += vec3(time * 2., time, -2.);
	from.xz *= rot1;
	from.xy *= rot2;
	
	float s = 0.1, fade = 1.0;
	vec3 v = vec3(0.);
	for (int r = 0; r < volsteps; r++) {
		vec3 p = from + s * dir * .5;
		p = abs(vec3(tile) - mod(p, tile * 2.0)); // tiling fold
		float pa, a = pa = 0.;
		for (int i = 0; i < iterations; i++) {
			//p = abs(p) / dot(p,p) - formuparam; // original magic formula
			p = abs(p) / max(dot(p,p), hollow_star) - formuparam; // the magic formula, magic was .0016
			a += abs(length(p) - pa);
			pa = length(p);
		}
		float dm = max(0., darkmatter - a * a * .001); // dark matter
		a *= a * a; // add contrast
		if (r > 6) {
			fade *= 1.0 - dm; // dark matter, don't render near it
		}
		v += fade;
		v += vec3(s, s * s, s * s * s * s) * a * brightness * fade; // coloring based on distance
		fade *= distfading;
		s += stepsize;
	}
	v = mix(vec3(length(v)), v, saturation); //color adjust
	COLOR = hdrout(vec4(v * .01, 1.0));
}