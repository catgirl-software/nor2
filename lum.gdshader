shader_type canvas_item;

uniform float amount : hint_range(0, 1);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	float lum = dot(c, vec3(0.222, 0.707, 0.701));
	COLOR.rgb = mix(vec3(lum, lum, lum), c, amount);
}