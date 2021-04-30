-- Logan Dean
-- 3den
-- Scene.lua

local Object = require '3den.Object'

local Scene = class (Object)
function Scene:init ()
	Object.init (self)
	self.children = {}
end
function Scene:addChild (child)
	table.insert (self.children, child)
end
function Scene:removeChild (child)
	table.remove (self.children, child)
end
--[[
function Scene:update (dt)
	for i,child in ipairs (self.children) do
		if child.update then child:update (dt) end
	end
end
--]]
function Scene:draw ()
	for i,child in ipairs (self.children) do
		if child.draw then child:draw () end
	end
end

return Scene
