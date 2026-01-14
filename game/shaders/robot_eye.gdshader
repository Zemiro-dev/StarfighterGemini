shader_type canvas_item;
#include "includes/glint.gdshaderinc"

uniform sampler2D eye;
uniform vec4 swap_out : source_color;
uniform vec4 swap_in_on : source_color;
uniform vec3 swap_in_on_add : source_color;
uniform vec4 swap_in_off : source_color;
uniform int progress_style : hint_enum("LeftToRight") = 0;
uniform float progress : hint_range(0.0, 1.0, 0.001) = 1.0;
uniform float threshold : hint_range(0.0, 1.0, 0.001) = .005;

void fragment() {
	vec4 eye_color = texture(eye, UV);
	vec4 out_color = texture(TEXTURE, UV);
	if (length(out_color - swap_out) < threshold) {
		if (progress_style == 0) {
			if (UV.x < progress) {
				if (eye_color.a > .001) {
					out_color = vec4(eye_color.rgb, eye_color.a);
				} else {
					out_color = vec4(swap_in_on.rgb + swap_in_on_add, swap_in_on.a);
				}
			} else {
				out_color = swap_in_off;
			}			
		}
	}
	COLOR = out_color;
}
