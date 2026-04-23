shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float candle_radius = 0.32;
uniform float aspect_ratio = 1.307;
uniform float darkness_floor = 0.15;
uniform float desaturation = 0.20;

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);

	// Desaturate 35%
	float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));
	vec3 desaturated = mix(color.rgb, vec3(lum), desaturation);

	// Sepia shadow tint: push darks toward warm amber
	vec3 sepia = vec3(lum * 1.08, lum * 0.88, lum * 0.60);
	vec3 tinted = mix(desaturated, sepia, (1.0 - lum) * 0.25);

	// Candlelight: circular glow centred on screen (player is always centred)
	vec2 uv = SCREEN_UV - 0.5;
	uv.x *= aspect_ratio;
	float dist = length(uv);
	float candle = smoothstep(candle_radius, candle_radius * 0.1, dist);

	// Warm tint for lit area — applied to original color to preserve saturation
	// brightness_boost fades from 1.3 at centre to 1.0 at the radius edge
	float brightness_boost = 1.0 + candle * 0.3;
	vec3 warm = color.rgb * vec3(1.18, 0.92, 0.60) * brightness_boost;
	vec3 lit = mix(tinted, warm, candle);

	// Darkness beyond candle radius
	float darkness = mix(darkness_floor, 1.0, candle);

	COLOR = vec4(lit * darkness, 1.0);
}
