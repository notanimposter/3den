-- Logan Dean
-- 3den
-- Shader.lua

Shader = {}
function Shader.init ()
	for i,filename in ipairs (love.filesystem.getDirectoryItems ("3den/shaders")) do
		local shadername = filename:match ("(.+).glsl$")
		if shadername ~= nil then
			shadername = shadername:upper ()
			io.write ("Compiling shader: "..shadername.."...")
			local src = love.filesystem.read ("3den/shaders/"..filename)
			Shader[shadername] = love.graphics.newShader(src)
			print ("Done!")
		end
	end
end
