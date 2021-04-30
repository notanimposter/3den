-- Logan Dean
-- 3den
-- Camera.lua

local Object = require '3den.Object'
local Shader = require '3den.Shader'
local Matrix = require '3den.Matrix'

local Camera = class (Object)
function Camera:init (position, euler, fov, near, far, aspect)
	self.viewMatrix = Matrix ()
	self.projectionMatrix = Matrix ()
	self.fov = fov or math.pi/2
	self.near = near or 0.1
	self.far = far or 100
	self.aspect = aspect or love.graphics.getWidth () / love.graphics.getHeight ()
	Object.init (self, position, euler)
end
function Camera:updateMatrix ()
	Object.updateMatrix (self)
	self.viewMatrix:copyFrom (self.matrix)
	self.viewMatrix:transpose ()
	self.viewMatrix:inverse ()
	self.viewMatrix:transpose ()
	
	self.projectionMatrix:setPerspective (self.fov, self.aspect, self.near, self.far)
end
function Camera:drawObject (object)
	for k,shader in pairs (Shader) do
		if k ~= "init" then
			shader:send ("viewMatrix", self.viewMatrix.data)
			shader:send ("projectionMatrix", self.projectionMatrix.data)
		end
	end
	if object.draw then object:draw () end
end

return Camera
