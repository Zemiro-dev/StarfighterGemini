shader_type canvas_item;
#include "includes/glint.gdshaderinc"

uniform vec3 effect_color: source_color = vec3(0.2, 0.3, 0.8);
uniform int octave_count: hint_range(1, 20) = 10;
uniform float amp_start = 0.5;
uniform float amp_coeff = 0.5;
uniform float freq_coeff = 2.0;
uniform float speed = 0.5;
uniform float zoom = 1.0;


float hash12(vec2 x) {
    return fract(cos(mod(dot(x, vec2(13.9898, 8.141)), 3.14)) * 43758.5453);
}

float random (vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

vec2 hash22(vec2 uv) {
    uv = vec2(dot(uv, vec2(127.1,311.7)),
              dot(uv, vec2(269.5,183.3)));
    return 2.0 * fract(sin(uv) * 43758.5453123) - 1.0;
}

float noise(vec2 uv) {
    vec2 iuv = floor(uv);
    vec2 fuv = fract(uv);
    vec2 blur = smoothstep(0.0, 1.0, fuv);
    return mix(mix(dot(hash22(iuv + vec2(0.0,0.0)), fuv - vec2(0.0,0.0)),
                   dot(hash22(iuv + vec2(1.0,0.0)), fuv - vec2(1.0,0.0)), blur.x),
               mix(dot(hash22(iuv + vec2(0.0,1.0)), fuv - vec2(0.0,1.0)),
                   dot(hash22(iuv + vec2(1.0,1.0)), fuv - vec2(1.0,1.0)), blur.x), blur.y) + 0.5;
}

float fbm(vec2 uv, int octaves) {
    float value = 0.0;
    float amplitude = amp_start;
    for (int i = 0; i < octaves; i++) {
        value += amplitude * noise(uv);
        uv *= freq_coeff;
        amplitude *= amp_coeff;
    }
    return value;
}

void fragment() {
    vec2 uv = UV * zoom;
	vec3 color = vec3(0.0);
	
	vec2 q = vec2(0.);
	q.x = fbm(uv, octave_count);
	q.y = fbm(uv + vec2(1.0), octave_count);
	
    vec2 r = vec2(0.);
    r.x = fbm( uv + 1.0*q + vec2(1.7,9.2)+ 0.15*TIME, octave_count);
    r.y = fbm( uv + 1.0*q + vec2(8.3,2.8)+ 0.126*TIME, octave_count);
	
	float f = fbm(uv+r, octave_count);
	
	color = mix(vec3(0.101961,0.619608,0.666667),
	        vec3(0.666667,0.666667,0.498039),
	        clamp((f*f)*4.0,0.0,1.0));

    color = mix(color,
                vec3(0,0,0.164706),
                clamp(length(q),0.0,1.0));

    color = mix(color,
                vec3(0.666667,1,1),
                clamp(length(r.x),0.0,1.0));
	
    COLOR = hdrout(vec4(color, 1.0));
}

//void fragment() {
    //vec2 uv = UV * zoom;
    ////// st += st * abs(sin(TIME*0.1)*3.0);
    //uv += 2.0 * fbm(uv + TIME * speed, octave_count) - 1.0;
    //float dist = abs(uv.x);
    ////vec3 color = effect_color * mix(0.0, 0.05, hash12(vec2(TIME))) / dist;
	//vec3 color = dist * effect_color;
    //COLOR = hdrout(vec4(color, 1.0));
//}