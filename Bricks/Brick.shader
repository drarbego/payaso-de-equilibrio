shader_type canvas_item;

uniform bool is_aggresive = false;
uniform int health = 3;

float sawtooth(float time) {
	float health_float = float(health);
	return 0.5 * ((time - health_float * floor(time / health_float)) / health_float);
}

bool is_within(vec2 uv, vec4 outer, vec4 inner) {
	bool inside_outer = (
		uv.x > outer.x && uv.x < outer.z && uv.y > outer.y && uv.y < outer.w
	);
	bool outside_inner = !(
		uv.x > inner.x && uv.x < inner.z && uv.y > inner.y && uv.y < inner.w
	);
	return inside_outer && outside_inner;
}

vec4 get_outer(int iter, float time) {
	float range = sawtooth(time + float(iter));

	return vec4(
		abs(range), // top-left x
		abs(range), // top-left y
		1.0 - abs(range), // bottom-right x
		1.0 - abs(range) // bottom-right y
	);
}

vec4 get_color(vec2 uv, float time) {
	for(int i = 0; i < health; i++) {
		vec4 outer = get_outer(i, time);
		vec4 inner = outer + vec4(vec2(0.05), vec2(-0.05));

		if (is_within(uv, outer, inner)) {
			if (is_aggresive) {
				return vec4(0.9, 0.0, 0.5, 1.0);
			}
			return vec4(0.5, 0.0, 0.9, 1.0);
		}
	}

	return vec4(0.0, 0.0, 0.0, 1.0);
}

void fragment() {
	COLOR = get_color(UV, TIME);
}
