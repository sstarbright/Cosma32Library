shader_type spatial;
render_mode unshaded, shadows_disabled;

#include "3_point.gdshaderinc"

uniform sampler2D albedo : source_color, hint_default_white, filter_nearest;
uniform bvec2 repeat = bvec2(true, true);
uniform vec2 albedo_scale = vec2(1.0, 1.0);
uniform vec2 albedo_offset = vec2(0.0, 0.0);
uniform vec3 color : source_color = vec3(1.0f,1.0f,1.0f);

void vertex() {
	COLOR = clamp(COLOR, vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0));
}

void fragment() {
	vec2 reflected_uv = vec2(NORMAL.x, -NORMAL.y);
	vec4 tex_sample = texture_3point(albedo, (reflected_uv+albedo_offset)*albedo_scale, false, repeat);
	ALBEDO.rgb = mix(COLOR.rgb, vec3(1,1,1), tex_sample.r)*color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
