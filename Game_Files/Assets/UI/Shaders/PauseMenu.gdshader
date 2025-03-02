shader_type canvas_item;

uniform vec4 color_over : source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
   vec4 blurredeffect = textureLod(SCREEN_TEXTURE, SCREEN_UV, 2.0);
   blurredeffect.a = 255.0;
   vec4 fin = mix(blurredeffect, color_over, 0);
   COLOR = fin;
}
