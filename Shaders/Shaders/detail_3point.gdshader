shader_type spatial;
render_mode unshaded;

#include "3_point.gdshaderinc"

uniform sampler2D albedo : source_color, hint_default_white, repeat_disable, filter_nearest;
uniform bvec2 repeat_albedo = bvec2(true, true);
uniform vec2 albedo_scale = vec2(1.0, 1.0);
uniform vec2 albedo_offset = vec2(0.0, 0.0);
uniform sampler2D detail : source_color, hint_default_white, repeat_disable, filter_nearest;
uniform bvec2 repeat_detail = bvec2(true, true);
uniform vec2 detail_scale = vec2(1.0, 1.0);
uniform vec2 detail_offset = vec2(0.0, 0.0);
uniform vec3 color : source_color = vec3(1.0f,1.0f,1.0f);

void vertex() {
	COLOR = clamp(COLOR, vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0));
}

void fragment() {
	vec4 tex_sample = texture_3point(albedo, (UV+albedo_offset)*albedo_scale, false, repeat_albedo);
	vec4 det_sample = texture_3point(detail, (UV+detail_offset)*detail_scale, false, repeat_detail);
	ALBEDO.rgb = mix(tex_sample.rgb, det_sample.rgb, det_sample.a)*COLOR.rgb*color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
