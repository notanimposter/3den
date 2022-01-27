#pragma language glsl3

uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;

uniform Image albedo_map;
uniform Image normal_map;
uniform Image roughness_map;

uniform vec3 ambient_light = vec3 (0.2, 0.2, 0.2);
uniform vec3 light_position;
uniform vec3 light_color = vec3 (1,1,1);

varying vec3 lightPos_relative;
varying vec3 frag_norm;
varying vec3 cameraPos_relative;

#ifdef VERTEX
	attribute vec3 VertexNormal;
	vec4 position (mat4 mat, vec4 vert) {
		mat4 inverseModelMatrix = inverse (modelMatrix);
		lightPos_relative = (inverseModelMatrix * vec4 (light_position,1)).xyz;
		cameraPos_relative = - (viewMatrix * modelMatrix * vert).xyz;

		frag_norm = mat3(transpose (inverseModelMatrix)) * VertexNormal;
		return projectionMatrix * viewMatrix * modelMatrix * vert;
	}
#endif
#ifdef PIXEL
	vec4 effect (vec4 color, Image mesh_tex, vec2 texture_coords, vec2 screen_coords) {
		vec4 albedo = Texel(albedo_map, texture_coords);
		if (albedo.a < 0.001) discard;
		vec4 normal = Texel (normal_map, texture_coords);
		vec4 roughness = Texel (roughness_map, texture_coords);

		if (normal.a < 0.001) normal = vec4 (frag_norm, 1); // use vertex normals if the map has alpha zero

		vec3 lightDir = normalize (light_position);
		vec3 normalDir = normalize (normal.xyz);
		vec3 camDir = normalize (cameraPos_relative);
		vec3 halfwayDir = normalize (lightDir + camDir);

		float lambert = max (0.0 , dot (lightDir, normalDir));
		vec3 diffuse = lambert * light_color;

		float spec = pow (max (dot (normalDir, halfwayDir), 0.0), 32.0);
		vec3 specular = (1 - roughness.rgb) * spec * light_color;

		vec3 frag_color = (diffuse + ambient_light) * albedo.rgb + specular; // i think this is right?

		return vec4 (frag_color, albedo.a);
	}
#endif
