shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform vec4 colour: source_color;
uniform vec4 modulate: source_color;

uniform vec3 move_direction;
uniform float speed;

void fragment() {
	vec2 new_uv = vec2(UV.x, UV.y);
	new_uv.x += (move_direction.x * speed) * TIME;
	new_uv.y += (move_direction.y * speed) * TIME;
	
	COLOR = texture(noise, new_uv);
	COLOR = (COLOR * (colour + modulate));
}
