-- Logan Dean
-- 3den
-- init.lua

--[[
Matrix = require '3den.Matrix'
Shader = require '3den.Shader'
OBJLoader = require '3den.OBJLoader'
Material = require '3den.Material'
LitMaterial = require '3den.LitMaterial'
Object = require '3den.Object'
MeshObject = require '3den.MeshObject'
Scene = require '3den.Scene'
Camera = require '3den.Camera'
--]]

local Threeden = {}

for i,filename in ipairs (love.filesystem.getDirectoryItems ("3den/")) do
	local name, ext = filename:match ("(.+)%.(...)")
	if name ~= "init" and ext == "lua" then
		Threeden[name] = require ("3den."..name)
	end
end

return Threeden
