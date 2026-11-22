shader_type canvas_item;

// Captures everything drawn behind the water node
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Noise texture used to distort the water
uniform sampler2D noise_tex : repeat_enable;

// Customizable properties in the Inspector
uniform vec4 water_tint : source_color = vec4(0.1, 0.5, 0.8, 0.45);
uniform vec4 foam_color : source_color = vec4(0.85, 0.95, 1.0, 0.9);
uniform vec2 scroll_speed = vec2(0.05, 0.02);
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.015;
uniform float foam_thickness : hint_range(0.0, 0.2) = 0.03;

void fragment() {
	// Scroll UV coordinates over time
	vec2 scrolled_uv = UV + (TIME * scroll_speed);
	
	// Sample the noise texture (values are 0.0 to 1.0, shift to -0.5 to 0.5)
	vec2 noise = texture(noise_tex, scrolled_uv).rg - vec2(0.5);
	
	// Distort the screen coordinates to refract objects behind the water
	vec2 distorted_screen_uv = SCREEN_UV + (noise * distortion_strength);
	vec4 bg_color = texture(SCREEN_TEXTURE, distorted_screen_uv);
	
	// Blend the distorted background with the water tint
	vec4 final_color = mix(bg_color, water_tint, water_tint.a);
	
	// Add a wavy foam line at the top surface (where UV.y is near 0.0)
	float wave_offset = noise.x * 0.02;
	if (UV.y + wave_offset < foam_thickness) {
		final_color = foam_color;
	}
	
	COLOR = final_color;
}
