-- Logan Dean
-- 3den
-- Object.lua

local Matrix = require '3den.Matrix'

local Object = class ()
function Object:init (position, euler, scale)
	self.position = position or {0,0,0}
	self.euler = euler or {0,0,0}
	self.scale = scale or {1,1,1}
	self.matrix = Matrix ()
	self:updateMatrix ()
end
function Object:updateMatrix (parentsMatrix)
	if parentsMatrix then
		self.matrix:copyFrom (parentsMatrix)
	else
		self.matrix:setIdentity ()
	end
	self.matrix:rotate (unpack (self.euler))
	self.matrix:scale (unpack (self.scale))
	self.matrix:translate (unpack (self.position))
end

return Object
