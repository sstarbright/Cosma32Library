shader_type spatial;
render_mode unshaded, blend_mix;

#include "3_point.gdshaderinc"

uniform sampler2D albedo : source_color, hint_default_white, filter_nearest;
uniform bvec2 repeat = bvec2(true, true);
uniform vec2 albedo_scale = vec2(1.0, 1.0);
uniform vec2 albedo_offset = vec2(0.0, 0.0);
uniform vec3 color : source_color = vec3(1.0f,1.0f,1.0f);
uniform bool use_model = true;

void vertex() {
	COLOR = clamp(COLOR, vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0));
    if (use_model) {
	    MODELVIEW_MATRIX = VIEW_MATRIX * MODEL_MATRIX * mat4(
	        INV_VIEW_MATRIX[0],
	        INV_VIEW_MATRIX[1],
	        INV_VIEW_MATRIX[2],
	        vec4(0.0, 0.0, 0.0, 1.0)
	    );
	} else {
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
	        INV_VIEW_MATRIX[0],
	        INV_VIEW_MATRIX[1],
	        INV_VIEW_MATRIX[2],
	        MODEL_MATRIX[3]
	    );
	}
}

void fragment() {
	vec4 tex_sample = texture_3point(albedo, (UV+albedo_offset)*albedo_scale, false, repeat);
	ALBEDO.rgb = tex_sample.rgb*COLOR.rgb*color;
	ALPHA = tex_sample.a*COLOR.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
