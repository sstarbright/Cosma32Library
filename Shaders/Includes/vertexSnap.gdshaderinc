const float vertex_snapping_offset = 0.8;

vec4 snapVertex(mat4 projection, mat4 model_view, vec3 position, vec2 vsnap_resolution)
{
    vec4 base_position = projection * model_view * vec4(position, 1.0);
	vec4 snapped_position = base_position;
	snapped_position.xyz = base_position.xyz / base_position.w;

	vec2 snap_resolution = floor(vsnap_resolution*(1.0 - vertex_snapping_offset));
	snapped_position.x = floor(snap_resolution.x * snapped_position.x) / snap_resolution.x;
	snapped_position.y = floor(snap_resolution.y * snapped_position.y) / snap_resolution.y;

	snapped_position.xyz *= base_position.w;
	return snapped_position;
}