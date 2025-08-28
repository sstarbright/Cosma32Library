// BY Purpbatboi2i FROM GODOTSHADERS https://godotshaders.com/shader/n64-rdp-dither-vi-post-process-effect/
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform bool enable_dither_filter = true;
uniform bool enable_horizontal_blur = true;

const vec3 LUMINANCE_VECTOR = vec3(0.299, 0.587, 0.114);
const float QUANTIZATION_FACTOR = 32.0;
const float COLOR_SCALE = 255.0;
const float INV_COLOR_SCALE = 1.0 / 255.0;
const float BLUR_MIX = 0.65;
const float BRIGHTNESS_FALLOFF = 0.5;
const float BRIGHTEN_FACTOR = 0.4;

ivec3 quantize_color(vec3 color) {
    return ivec3(clamp(color * QUANTIZATION_FACTOR - 0.0001, 0.0, 31.0));
}

vec3 get_restore_adjustment(ivec3 center_quantized, vec3 neighbor_color) {
    return vec3(sign(quantize_color(neighbor_color) - center_quantized));
}

vec3 restore_filter(vec2 uv, vec2 pixel_size) {
    vec3 center = texture(screen_texture, uv).rgb;
    if (!enable_dither_filter) {
        return center;
    }

    vec2 offsets[8];
    offsets[0] = uv + vec2(-pixel_size.x, -pixel_size.y);
    offsets[1] = uv + vec2( 0.0,         -pixel_size.y);
    offsets[2] = uv + vec2( pixel_size.x, -pixel_size.y);
    offsets[3] = uv + vec2(-pixel_size.x,  0.0);
    offsets[4] = uv + vec2( pixel_size.x,  0.0);
    offsets[5] = uv + vec2(-pixel_size.x,  pixel_size.y);
    offsets[6] = uv + vec2( 0.0,          pixel_size.y);
    offsets[7] = uv + vec2( pixel_size.x,  pixel_size.y);

    ivec3 center_quantized = quantize_color(center);
    vec3 total_adjustment = vec3(0.0);

    total_adjustment += get_restore_adjustment(center_quantized, texture(screen_texture, offsets[0]).rgb);
    total_adjustment += get_restore_adjustment(center_quantized, texture(screen_texture, offsets[1]).rgb);
    total_adjustment += get_restore_adjustment(center_quantized, texture(screen_texture, offsets[2]).rgb);
    total_adjustment += get_restore_adjustment(center_quantized, texture(screen_texture, offsets[3]).rgb);
    total_adjustment += get_restore_adjustment(center_quantized, texture(screen_texture, offsets[4]).rgb);
    total_adjustment += get_restore_adjustment(center_quantized, texture(screen_texture, offsets[5]).rgb);
    total_adjustment += get_restore_adjustment(center_quantized, texture(screen_texture, offsets[6]).rgb);
    total_adjustment += get_restore_adjustment(center_quantized, texture(screen_texture, offsets[7]).rgb);

    return (center * COLOR_SCALE + total_adjustment) * INV_COLOR_SCALE;
}

vec3 apply_horizontal_blur(vec3 base_color, vec2 uv, vec2 pixel_size) {
    if (!enable_horizontal_blur) {
        return base_color;
    }

    vec2 right_uv = uv + vec2(pixel_size.x, 0.0);
    vec3 right_color = restore_filter(right_uv, pixel_size);

    float base_lum = dot(base_color, LUMINANCE_VECTOR);
    float right_lum = dot(right_color, LUMINANCE_VECTOR);

    if (base_lum < right_lum) {
        vec3 blur_target = mix(base_color, right_color, BLUR_MIX);
        vec3 brighten = max(blur_target - base_color, vec3(0.0));
        return base_color + brighten * BRIGHTEN_FACTOR; // Stronger brightening
    } else {
        vec3 dark_smear = mix(base_color, right_color, BLUR_MIX);
        return mix(dark_smear, base_color, BRIGHTNESS_FALLOFF);
    }
}

void fragment() {
    vec2 pixel_size = 1.0 / vec2(textureSize(screen_texture, 0));

    vec3 restored_color = restore_filter(SCREEN_UV, pixel_size);
    vec3 final_color = apply_horizontal_blur(restored_color, SCREEN_UV, pixel_size);

    COLOR = vec4(final_color, 1.0);
}