shader_type canvas_item;

#include "includes/glint.gdshaderinc"

uniform sampler2D noise1 : repeat_enable;
uniform sampler2D noise2 : repeat_enable;
uniform float strength;
uniform float fps;
uniform int frames = 256;
uniform vec4 base_color : source_color;
uniform vec4 mix_color : source_color;

void fragment() {
	float c = clock(TIME, float(frames), fps); //Get clock frame
	vec4 offset1 = texture(noise1, UV+c); //Get offset
	vec4 offset2 = texture(noise2,UV+c);
	vec4 offset = offset1*offset2*strength;
	//vec4 offset = vec4(0, 0, 0., 0.);
	//COLOR = texture(TEXTURE, vec2(UV.x,UV.y) + normal.xy); //Apply offset
	COLOR = texture(TEXTURE, UV + offset.xy - vec2(.5) * strength) * base_color * mix_color; //We need to remove the displacement
}
