shader_type canvas_item;

uniform bool is_aggresive = false;

bool should_display(vec2 uv, float time) {
	float lower_limit_a = 0.5 * abs(sin(time));
	float upper_limit_a = 1.0 - lower_limit_a;

	float lower_limit_b = 0.5 * sin(time + 5.0);
	float upper_limit_b = 1.0 - lower_limit_b;

	return (
		uv.y > lower_limit_a &&
		uv.y < upper_limit_a &&
		uv.x > lower_limit_a &&
		uv.x < upper_limit_a
	);
}

vec4 get_color(vec2 uv, float time) {
	if (should_display(uv, time)) {
		if (is_aggresive) {
			return vec4(0.9, 0.0, 0.5, 1.0);
		}
		return vec4(0.5, 0.0, 0.9, 1.0);
	}

	return vec4(0.0, 0.0, 0.0, 1.0);
}

void fragment() {
	COLOR = get_color(UV, TIME);
}
