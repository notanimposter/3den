-- Logan Dean
-- 3den
-- Object.lua

Object = class ()
function Object:init (position, euler, scale)
	self.position = position or {0,0,0}
	self.euler = euler or {0,0,0}
	self.scale = scale or {1,1,1}
	self.matrix = Matrix ()
	self:updateMatrix ()
end
function Object:updateMatrix ()
	self.matrix:setIdentity ()
	self.matrix:rotate (unpack (self.euler))
	self.matrix:scale (unpack (self.scale))
	self.matrix:translate (unpack (self.position))
end

MeshObject = class (Object)
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
