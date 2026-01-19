shader_type canvas_item;
#include "includes/glint.gdshaderinc"

uniform float zoom = 1.0;
uniform float feedback_override : hint_range(0., 1., 0.01) = 0.0;

uniform float mix_value : hint_range(0.0, 1.0, .01) = 0.5;

uniform vec2 offset0 = vec2(0.0, 0.0);
uniform vec2 speed0 = vec2(0.05);
uniform float animation_speed0 = .05;
uniform sampler2D _curve0 : repeat_disable, filter_linear;
uniform sampler2D _gradient0;
uniform sampler3D _noise0 : repeat_enable;

uniform vec2 offset1 = vec2(0.0, 0.0);
uniform vec2 speed1 = vec2(.05);
uniform float animation_speed1 = .05;
uniform sampler2D _curve1 : repeat_disable, filter_linear;
uniform sampler2D _gradient1;
uniform sampler3D _noise1 : repeat_enable;

uniform vec2 energy_offset0 = vec2(0.0, 0.0);
uniform vec2 energy_speed0 = vec2(.05);
uniform float energy_animation_speed0 = .05;
uniform sampler2D _energy_curve0 : repeat_disable, filter_linear;
uniform sampler2D _energy_gradient0;
uniform sampler3D _energy_noise0 : repeat_enable;

void fragment() {
	vec2 uv = UV * zoom;
	
	float noise0 = texture(_noise0, vec3(uv + offset0 + TIME * speed0, TIME * animation_speed0)).r;
	noise0 = texture(_curve0, vec2(noise0)).r;
	vec4 color0 = texture(_gradient0, vec2(noise0));
	
	float noise1 = texture(_noise1, vec3(uv + offset1 + TIME * speed1, TIME * animation_speed1)).r;
	noise1 = texture(_curve1, vec2(noise1)).r;
	noise1 *= max(noise0, feedback_override);
	vec4 color1 = texture(_gradient1, vec2(noise1));
	
	vec4 base_color = mix(color0, color1, mix_value);
	
	//float energy_noise0 = texture(_energy_noise0, vec3(uv + energy_offset0 + TIME * energy_speed0, TIME * energy_animation_speed0)).r;
	//energy_noise0 = texture(_energy_curve0, vec2(energy_noise0)).r;
	//energy_noise0 *= max(noise0, noise1);
	//vec4 energy_color = texture(_energy_gradient0, vec2(energy_noise0));	
	//vec4 color = vec4(max(base_color.rgb, energy_color.rgb), base_color.a);
	
	vec4 color = base_color;
	COLOR = hdrout(vec4(color));
}