#version 450

in vec2 texCoords;

out vec4 out_Color;

uniform sampler2D uiTexture;

void main(void){
	out_Color = texture(uiTexture, texCoords);
}