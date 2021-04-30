-- Logan Dean
-- 3den
-- MeshObject.lua

local Object = require '3den.Object'

local MeshObject = class (Object)
function MeshObject:init (position, euler, scale, mesh, material)
	Object.init (self, position, euler, scale)
	self.material = material
	self.mesh = mesh
end
function MeshObject:draw ()
	love.graphics.setShader (self.material.shader)
	self.material:sendUniforms ()
	self.material.shader:send ("modelMatrix", self.matrix.data)
	love.graphics.draw (self.mesh)
	love.graphics.setShader ()
end

return MeshObject
