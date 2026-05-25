shader_type canvas_item;

uniform int color_depth : hint_range(2, 32) = 8;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.3;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);
    
    float depth = float(color_depth);
    color.rgb = floor(color.rgb * depth) / depth;
    
    vec2 pixel = floor(FRAGCOORD.xy);
    float dither = mod(pixel.x + pixel.y, 2.0) * dither_strength * 0.05;
    color.rgb += dither;
    
    COLOR = color;
}