shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float interlacing_speed = 1000.0;

void fragment() {
	vec2 mod_uv = SCREEN_UV;
	if (int(mod_uv.y * 1.0/SCREEN_PIXEL_SIZE.y) % 2 == 0 && (sin(TIME*interlacing_speed) + 1.0) > 1.0){
		mod_uv.x = mod_uv.x + SCREEN_PIXEL_SIZE.x;
	}
	COLOR = texture(SCREEN_TEXTURE, mod_uv);
}
