-- Logan Dean
-- 3den
-- Matrix.lua
-- haphazardly ported from vmini

local Matrix = class ()

local index_fix_col = {
	__index = function (row, j)
		local i = rawget(row,"i")
		local self = rawget(row,"self")
		return self.data[(i-1)*4+j]
	end,
	__newindex = function (row, j, value)
		local i = rawget(row,"i")
		local self = rawget(row,"self")
		self.data[(i-1)*4+j] = value
	end
}
local index_fix_row = {
	__index = function (self, i)
		if type (i) == "number" then
			local t = {self=self,i=i}
			setmetatable (t, index_fix_col)
			return t
		else
			return Matrix[i]
		end
	end
}

function Matrix:init (tab)
	setmetatable (self, index_fix_row)
	self.data = tab or {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}
end
function Matrix:zero ()
	self.data = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end
function Matrix:setIdentity ()
	self.data = {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}
end
function Matrix:setPerspective (fov, aspect, near, far)
	local S = 1/math.tan(fov/2)
	self:zero ()
	self.data[1] = S/aspect
	self.data[6] = S
	self.data[11] = -(far+near)/(far-near)
	self.data[15] = -1
	self.data[12] = -2*far*near / (far-near)
end
function Matrix:copyFrom (other)
	for i=1,16 do
		self.data[i] = other.data[i]
	end
end

function Matrix:setProduct (a, b)
	local C = Matrix ()
	local s
	for i=1,4 do
		for j=1,4 do
			s = 0
			for k=1,4 do
				s = s + a[i][k] * b[k][j]
			end
			C[i][j] = s
		end
	end
	self.data = C.data
end
function Matrix:multiply (other)
	self:setProduct (self, other)
end
function Matrix:setRotationX (angle)
	self:setIdentity ()
	local sin = math.sin (angle)
	local cos = math.cos (angle)
	self.data[6] = cos
	self.data[7] = -sin
	self.data[10] = sin
	self.data[11] = cos
end
function Matrix:rotateX (angle)
	local sin = math.sin (angle)
	local cos = math.cos (angle)
	for i=1,4 do
		local b = self[i][2]
		local c = self[i][3]
		self[i][2] = b*cos+c*sin
		self[i][3] = -b*sin+c*cos
	end
end
function Matrix:setRotationY (angle)
	self:setIdentity ()
	local sin = math.sin (angle)
	local cos = math.cos (angle)
	self.data[1] = cos
	self.data[3] = sin
	self.data[9] = -sin
	self.data[11] = cos
end
function Matrix:rotateY (angle)
	local sin = math.sin (angle)
	local cos = math.cos (angle)
	for i=1,4 do
		local a = self[i][1]
		local c = self[i][3]
		self[i][1] = a*cos-c*sin
		self[i][3] = a*sin+c*cos
	end
end
function Matrix:setRotationZ (angle)
	self:setIdentity ()
	local sin = math.sin (angle)
	local cos = math.cos (angle)
	self.data[1] = cos
	self.data[2] = -sin
	self.data[5] = sin
	self.data[6] = cos
end
function Matrix:rotateZ (angle)
	local sin = math.sin (angle)
	local cos = math.cos (angle)
	for i=1,4 do
		local a = self[i][1]
		local b = self[i][2]
		self[i][1] = a*cos+b*sin
		self[i][2] = -a*sin+b*cos
	end
end
function Matrix:rotate (x, y, z)
	self:rotateY (y)
	self:rotateX (x)
	self:rotateZ (z)
end
function Matrix:translate (x, y, z)
	self:setProduct (Matrix {
		1,0,0,x,
		0,1,0,y,
		0,0,1,z,
		0,0,0,1
	}, self)
	--[[
	for i=1,4 do
		local d = self[i][4]
		self[i][1] = self[i][1] + d*x
		self[i][2] = self[i][2] + d*y
		self[i][3] = self[i][3] + d*z
	end
	--]]
end
function Matrix:scale (x, y, z)
	for i=1,4 do
		self[i][1] = self[i][1] * x
		self[i][2] = self[i][2] * y
		self[i][3] = self[i][3] * z
	end
end
function Matrix:transpose ()
	local result = Matrix ()
	for i=1,4 do
		for j=1,4 do
			result[j][i] = self[i][j]
		end
	end
	self.data = result.data
end
function Matrix:inverse ()
	local inv = Matrix ()
	local data = self.data -- ported this from a different language and this made it easier
	inv.data[1] = data[6]  * data[11] * data[16] -
		data[6]  * data[12] * data[15] -
		data[10]  * data[7]  * data[16] +
		data[10]  * data[8]  * data[15] +
		data[14] * data[7]  * data[12] -
		data[14] * data[8]  * data[11]
	inv.data[5] = -data[5]  * data[11] * data[16] +
		data[5]  * data[12] * data[15] +
		data[9]  * data[7]  * data[16] -
		data[9]  * data[8]  * data[15] -
		data[13] * data[7]  * data[12] +
		data[13] * data[8]  * data[11]
	inv.data[9] = data[5]  * data[10] * data[16] -
		data[5]  * data[12] * data[14] -
		data[9]  * data[6] * data[16] +
		data[9]  * data[8] * data[14] +
		data[13] * data[6] * data[12] -
		data[13] * data[8] * data[10]
	inv.data[13] = -data[5]  * data[10] * data[15] +
		data[5]  * data[11] * data[14] +
		data[9]  * data[6] * data[15] -
		data[9]  * data[7] * data[14] -
		data[13] * data[6] * data[11] +
		data[13] * data[7] * data[10]
	inv.data[2] = -data[2]  * data[11] * data[16] +
		data[2]  * data[12] * data[15] +
		data[10]  * data[3] * data[16] -
		data[10]  * data[4] * data[15] -
		data[14] * data[3] * data[12] +
		data[14] * data[4] * data[11]
	inv.data[6] = data[1]  * data[11] * data[16] -
		data[1]  * data[12] * data[15] -
		data[9]  * data[3] * data[16] +
		data[9]  * data[4] * data[15] +
		data[13] * data[3] * data[12] -
		data[13] * data[4] * data[11]
	inv.data[10] = -data[1]  * data[10] * data[16] +
		data[1]  * data[12] * data[14] +
		data[9]  * data[2] * data[16] -
		data[9]  * data[4] * data[14] -
		data[13] * data[2] * data[12] +
		data[13] * data[4] * data[10]
	inv.data[14] = data[1]  * data[10] * data[15] -
		data[1]  * data[11] * data[14] -
		data[9]  * data[2] * data[15] +
		data[9]  * data[3] * data[14] +
		data[13] * data[2] * data[11] -
		data[13] * data[3] * data[10]
	inv.data[3] = data[2]  * data[7] * data[16] -
		data[2]  * data[8] * data[15] -
		data[6]  * data[3] * data[16] +
		data[6]  * data[4] * data[15] +
		data[14] * data[3] * data[8] -
		data[14] * data[4] * data[7]
	inv.data[7] = -data[1]  * data[7] * data[16] +
		data[1]  * data[8] * data[15] +
		data[5]  * data[3] * data[16] -
		data[5]  * data[4] * data[15] -
		data[13] * data[3] * data[8] +
		data[13] * data[4] * data[7]
	inv.data[11] = data[1]  * data[6] * data[16] -
		data[1]  * data[8] * data[14] -
		data[5]  * data[2] * data[16] +
		data[5]  * data[4] * data[14] +
		data[13] * data[2] * data[8] -
		data[13] * data[4] * data[6]
	inv.data[15] = -data[1]  * data[6] * data[15] +
		data[1]  * data[7] * data[14] +
		data[5]  * data[2] * data[15] -
		data[5]  * data[3] * data[14] -
		data[13] * data[2] * data[7] +
		data[13] * data[3] * data[6]
	inv.data[4] = -data[2] * data[7] * data[12] +
		data[2] * data[8] * data[11] +
		data[6] * data[3] * data[12] -
		data[6] * data[4] * data[11] -
		data[10] * data[3] * data[8] +
		data[10] * data[4] * data[7]
	inv.data[8] = data[1] * data[7] * data[12] -
		data[1] * data[8] * data[11] -
		data[5] * data[3] * data[12] +
		data[5] * data[4] * data[11] +
		data[9] * data[3] * data[8] -
		data[9] * data[4] * data[7]
	inv.data[12] = -data[1] * data[6] * data[12] +
		data[1] * data[8] * data[10] +
		data[5] * data[2] * data[12] -
		data[5] * data[4] * data[10] -
		data[9] * data[2] * data[8] +
		data[9] * data[4] * data[6]
	inv.data[16] = data[1] * data[6] * data[11] -
		data[1] * data[7] * data[10] -
		data[5] * data[2] * data[11] +
		data[5] * data[3] * data[10] +
		data[9] * data[2] * data[7] -
		data[9] * data[3] * data[6]
	local invdet = 1/(data[1] * inv.data[1] + data[2] * inv.data[5] + data[3] * inv.data[9] + data[4] * inv.data[13]);
	for i=1,16 do
		inv.data[i] = inv.data[i] * invdet
	end
	self.data = inv.data
end
function Matrix:prettyPrint ()
	local space = string.rep (' ', 28)
	io.write ("┌"..space.."┐\n")
	for i=1,4 do
		io.write ("│")
		for j=1,4 do
			io.write (string.format ("% 6.2f ", self[i][j]))
		end
		io.write ("│\n")
	end
	io.write ("└"..space.."┘\n")
end

return Matrix
