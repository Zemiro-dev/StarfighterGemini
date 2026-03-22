shader_type canvas_item;
#include "includes/glint.gdshaderinc"
//https://godotshaders.com/shader/starfield/
uniform sampler2D gradient_texture_low;
uniform sampler2D gradient_texture_high;
uniform float progress : hint_range(0.0, 1.0, 0.001) = 0.0;
varying vec4 vertex_color; 

void vertex() {
	// this should be modulate * self_modulate, maybe other stuff, see link
	// https://forum.godotengine.org/t/how-to-get-modulate-info-in-shader-canvas-item/100455/2
	vertex_color = COLOR;
}

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
	COLOR = hdrout(out_color * vertex_color);
}
