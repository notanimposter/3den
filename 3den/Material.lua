-- Logan Dean
-- 3den
-- Material.lua

function mapFromRGBA (r,g,b,a)
	local color_string = string.char(r*255,g*255,b*255,(a or 1)*255)
	return love.graphics.newImage(love.image.newImageData(1,1,"rgba8", color_string))
end

GenericMaterial = class ()
function GenericMaterial:init (shader, uniforms)
	self.uniforms = uniforms or {}
	self.shader = shader
end
function GenericMaterial:sendUniforms ()
	for k,v in pairs(self.uniforms) do
		if self.shader:hasUniform (k) then self.shader:send (k, v) end
	end
end


LitMaterial = class (GenericMaterial)
function LitMaterial:init (albedo, normal, roughness, light_position, ambient_light)
	local uniforms = {
		albedo_map = albedo or mapFromRGBA (1,1,1,1), -- default white
		normal_map = normal or mapFromRGBA (0,0,0,0), -- alpha zero to tell the shader to use the normals from the mesh
		roughness_map = roughness or mapFromRGBA (0.5,0.5,0.5,1), -- idk half I guess
		light_position = light_position or {0,0,0},
		ambient_light = ambient_light or {0.2,0.2,0.2}
	}
	GenericMaterial.init (self, Shader.LIT, uniforms)
end
