shader_type canvas_item;
#include "includes/glint.gdshaderinc"
void fragment() {
	COLOR = hdrout(vec4(0.0, 0.376, 0.949, 1.0)) * texture(TEXTURE, UV);
}