-- Logan Dean
-- 3den
-- LoadOBJ.lua

local function joinTables (...)
	local joined = {}
	for i,arg in ipairs ({...}) do
		for j,v in ipairs (arg) do
			table.insert (joined,v)
		end
	end
	return joined
end

local function splitString(self, sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

local OBJLoader = {}

OBJLoader.VERTEX_FORMAT = {
	{"VertexPosition", "float", 3},
	{"VertexTexCoord", "float", 2},
	{"VertexNormal", "float", 3}
}

function OBJLoader.load (filename)
	local vertsSoFar = {}
	local uvsSoFar = {[0] = {0,0}}
	local normalsSoFar = {[0] = {0,0,0}} -- the zeroes are important
	
	-- basically a list of all the verts in face order. not sure what
	-- to call this data structure so I'm gonna call it a clungus
	local vertexClungus = {}
	for line in love.filesystem.lines (filename) do
		if string.sub (line,1,1) ~= "#" then
			tokens = splitString (line, " ")
			
			-- if I pass the tokens in I could probably move this outside of the function
			local switch = {
				-- I'm sure I'll implement all these things eventually (lol)
				mtllib = function () end,
				usemtl = function () end,
				o = function () end,
				g = function () end,
				s = function () end,
				l = function () end,
				v = function ()
					table.insert (vertsSoFar, {
						tonumber (tokens[2]),
						tonumber (tokens[3]),
						tonumber (tokens[4])
					})
				end,
				vt = function ()
					table.insert (uvsSoFar, {
						tonumber (tokens[2]),
						tonumber (tokens[3]),
					})
				end,
				vn = function ()
					table.insert (normalsSoFar, {
						tonumber (tokens[2]),
						tonumber (tokens[3]),
						tonumber (tokens[4])
					})
				end,
				f = function ()
					-- TODO THIS ASSUMES FACES COME LAST TODO TODO FIX THIS TODO NOT SAFE
					-- but faces almost always come last, so until I fix it:
					for abc=2,#tokens do
						if string.sub (tokens[abc],1,1) == "#" then
							break
						end
						-- I hate myself for naming this variable this
						local vvtvn = splitString (tokens[abc], '/')
						local vertexIndex = tonumber(vvtvn[1] or 0)
						local uvIndex = tonumber(vvtvn[2] or 0)
						local normalIndex = tonumber(vvtvn[3] or 0)
						-- build the clungus
						table.insert (vertexClungus, joinTables (
							vertsSoFar[vertexIndex],
							uvsSoFar[uvIndex],
							normalsSoFar[normalIndex]
						))
					end
				end
			}
			setmetatable (switch, {__index = function (x)
				return function () end -- might want to handle these errors at some point
			end})
			switch[tokens[1]] ()
		end
	end
	return vertexClungus
end

return OBJLoader
