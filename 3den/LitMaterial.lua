-- Logan Dean
-- 3den
-- LitMaterial.lua

local Material = require '3den.Material'
local Shader = require '3den.Shader'

local LitMaterial = class (Material)
function LitMaterial:init (albedo, normal, roughness, light_position, ambient_light)
	local uniforms = {
		albedo_map = albedo or Material.mapFromRGBA (1,1,1,1), -- default white
		normal_map = normal or Material.mapFromRGBA (0,0,0,0), -- alpha zero to tell the shader to use the normals from the mesh
		roughness_map = roughness or Material.mapFromRGBA (0.5,0.5,0.5,1), -- idk half I guess
		light_position = light_position or {0,0,0},
		ambient_light = ambient_light or {0.2,0.2,0.2}
	}
	Material.init (self, Shader.LIT, uniforms)
end

return LitMaterial
