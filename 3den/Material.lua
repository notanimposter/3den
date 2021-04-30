-- Logan Dean
-- 3den
-- Material.lua

local Material = class ()
function Material:init (shader, uniforms)
	self.uniforms = uniforms or {}
	self.shader = shader
end
function Material:sendUniforms ()
	for k,v in pairs(self.uniforms) do
		if self.shader:hasUniform (k) then self.shader:send (k, v) end
	end
end

function Material.mapFromRGBA (r,g,b,a)
	local color_string = string.char(r*255,g*255,b*255,(a or 1)*255)
	return love.graphics.newImage(love.image.newImageData(1,1,"rgba8", color_string))
end

return Material
