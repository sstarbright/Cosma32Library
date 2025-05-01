shader_type spatial;
render_mode vertex_lighting, shadows_disabled, blend_mix, unshaded, fog_disabled;

#include "res://Cosma32Library/Shaders/Includes/vertexSnap.gdshaderinc"
#include "res://Cosma32Library/Shaders/Includes/fresnel.gdshaderinc"

uniform vec2 vertex_snapping_resolution = vec2(960,720);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float strength = 1.0;

void vertex() {
	POSITION = snapVertex(PROJECTION_MATRIX, MODELVIEW_MATRIX, VERTEX, vertex_snapping_resolution);
}

void fragment() {
	ALBEDO = texture(SCREEN_TEXTURE, SCREEN_UV+(NORMAL.xy*strength)).rgb;
}
