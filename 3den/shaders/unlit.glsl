#pragma language glsl3
uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform Image image_texture;
#ifdef VERTEX
	vec4 position (mat4 mat, vec4 vert) {
		return projectionMatrix * viewMatrix * modelMatrix * vert;
	}
#endif
#ifdef PIXEL
	vec4 effect (vec4 color, Image mesh_tex, vec2 texture_coords, vec2 screen_coords) {
		vec4 texcolor = Texel (image_texture, texture_coords);
		if (texcolor.a < 0.001) discard;
		return texcolor;
	}
#endif
