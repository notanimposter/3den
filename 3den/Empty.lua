-- Logan Dean
-- 3den
-- Empty.lua

local Object = require '3den.Object'

local Empty = class (Object)
function Empty:init ()
	self.children = {}
	Object.init (self)
end
function Empty:addChild (child)
	table.insert (self.children, child)
	child:updateMatrix (self.matrix)
end
function Empty:removeChild (child)
	for i,against in ipairs (self.children) do
		if child == against then
			table.remove (self.children, i)
		end
	end
	child:updateMatrix ()
end
function Empty:updateMatrix (parentsMatrix)
	Object.updateMatrix(self, parentsMatrix)
	for i,child in ipairs (self.children) do
		child:updateMatrix (self.matrix)
	end
end
function Empty:update (dt)
	for i,child in ipairs (self.children) do
		if child.update then child:update (dt) end
	end
end
function Empty:draw ()
	for i,child in ipairs (self.children) do
		if child.draw then child:draw () end
	end
end

return Empty
