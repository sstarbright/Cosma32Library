// DKO's 3point GLSL shader
// https://www.shadertoy.com/view/Ws2fWV
// Be sure your texture import is set to "Nearest Neighbor"
vec2 norm2denorm(sampler2D tex, vec2 uv)
{
    return uv * vec2(textureSize(tex, 0)) - 0.5;
}

ivec2 denorm2idx(vec2 d_uv)
{
    return ivec2(floor(d_uv));
}

ivec2 norm2idx(sampler2D tex, vec2 uv)
{
    return denorm2idx(norm2denorm(tex, uv));
}

vec2 idx2norm(sampler2D tex, ivec2 idx)
{
    vec2 denorm_uv = vec2(idx) + 0.5;
    vec2 size = vec2(textureSize(tex, 0));
    return denorm_uv / size;
}

vec4 texel_fetch(sampler2D tex, ivec2 idx, bvec2 repeat)
{
    vec2 uv = idx2norm(tex, idx);
	if (repeat.x) {
		uv.x = mod(uv.x, 1.0f);
	}
	if (repeat.y) {
		uv.y = mod(uv.y, 1.0f);
	}
    return texture(tex, uv);
}


/*
 * Unlike Nintendo's documentation, the N64 does not use
 * the 3 closest texels.
 * The texel grid is triangulated:
 *
 *     0 .. 1        0 .. 1
 *   0 +----+      0 +----+
 *     |   /|        |\   |
 *   . |  / |        | \  |
 *   . | /  |        |  \ |
 *     |/   |        |   \|
 *   1 +----+      1 +----+
 *
 * If the sampled point falls above the diagonal,
 * The top triangle is used; otherwise, it's the bottom.
 */

vec4 texture_3point(sampler2D tex, vec2 uv, bool flip, bvec2 repeat)
{
    vec2 denorm_uv = norm2denorm(tex, uv);
    ivec2 idx_low = denorm2idx(denorm_uv);
    vec2 ratio = denorm_uv - vec2(idx_low);


    bool lower_flag;
    ivec2 corner0;
    ivec2 corner1;
    ivec2 corner2;
	if(flip){
	    // this uses one diagonal orientation
	    // using conditional, might not be optimal
	    lower_flag = 1.0 < (ratio.x + ratio.y);
	    corner0 = lower_flag ? ivec2(1, 1) : ivec2(0, 0);
	    corner1 = ivec2(0, 1);
	    corner2 = ivec2(1, 0);
	} else{
	    // orient the triangulated mesh diagonals the other way
	    lower_flag = (ratio.x - ratio.y) > 0.0;
	    corner0 = lower_flag ? ivec2(1, 0) : ivec2(0, 1);
	    corner1 = ivec2(0, 0);
	    corner2 = ivec2(1, 1);
	}
    ivec2 idx0 = idx_low + corner0;
    ivec2 idx1 = idx_low + corner1;
    ivec2 idx2 = idx_low + corner2;

    vec4 t0 = texel_fetch(tex, idx0, repeat);
    vec4 t1 = texel_fetch(tex, idx1, repeat);
    vec4 t2 = texel_fetch(tex, idx2, repeat);

    // This is standard (Crammer's rule) barycentric coordinates calculation.
    vec2 v0 = vec2(corner1 - corner0);
    vec2 v1 = vec2(corner2 - corner0);
    vec2 v2 = ratio   - vec2(corner0);
    float den = v0.x * v1.y - v1.x * v0.y;
    /*
     * Note: the abs() here is necessary because we don't guarantee
     * the proper order of vertices, so some signed areas are negative.
     * But since we only interpolate inside the triangle, the areas
     * are guaranteed to be positive, if we did the math more carefully.
     */
    float lambda1 = abs((v2.x * v1.y - v1.x * v2.y) / den);
    float lambda2 = abs((v0.x * v2.y - v2.x * v0.y) / den);
    float lambda0 = 1.0 - lambda1 - lambda2;

    return lambda0*t0 + lambda1*t1 + lambda2*t2;
}