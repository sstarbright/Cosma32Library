shader_type spatial;
render_mode blend_add, unshaded, fog_disabled;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = COLOR.rgb;
	ALPHA = COLOR.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
