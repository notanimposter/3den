class = require 'class'

--[[
local Material = require '3den.Material'
local LitMaterial = require '3den.LitMaterial'
local Shader = require '3den.Shader'
local MeshObject = require '3den.MeshObject'
local Camera = require '3den.Camera'
local Scene = require '3den.Scene'
local OBJLoader = require '3den.OBJLoader'
--]]

local Threeden = require '3den'

local tenball, light_ball, camera, scene, image_material, unlit_material, mesh
local fps
local sky_color = {0.2, 0.2, 0.2}

function love.load ()
	love.window.setMode(800, 600, {
		msaa = 16,
		vsync = 0
	})
	love.graphics.setDepthMode("lequal", true)
	love.graphics.setMeshCullMode('back')
	Threeden.Shader.init ()
	
	image_material = Threeden.LitMaterial (
		love.graphics.newImage ("textures/tenball.tga"),
		nil,
		nil,
		{-3, 2, -1},
		sky_color
	)
	unlit_material = Threeden.Material (Threeden.Shader.UNLIT,
		{
			image_texture = Threeden.Material.mapFromRGBA(1,1,1,1)
		}
	)
	mesh = love.graphics.newMesh (Threeden.OBJLoader.VERTEX_FORMAT, Threeden.OBJLoader.load ("models/sphere_uv.obj"), "triangles")
	tenball = Threeden.MeshObject ({0,0,-4}, {0, 0, 0}, {1,1,1}, mesh, image_material)
	light_ball = Threeden.MeshObject ({-3,2,-1}, {0, 0, 0}, {0.2,0.2,0.2}, mesh, unlit_material)
	camera = Threeden.Camera ({0,0,2}, {0, 0, 0})
	scene = Threeden.Scene ()
	scene:addChild (tenball)
	scene:addChild (light_ball)
	scene:addChild (camera)
end

function love.update (dt)
	fps = math.floor(1 / dt)
	tenball.euler[2] = tenball.euler[2] + math.pi * dt
	tenball:updateMatrix ()
	
	if love.keyboard.isDown('w') then
		light_ball.position[3] = light_ball.position[3] - 2 * dt
	end
	if love.keyboard.isDown('s') then
		light_ball.position[3] = light_ball.position[3] + 2 * dt
	end
	if love.keyboard.isDown('a') then
		light_ball.position[1] = light_ball.position[1] - 2 * dt
	end
	if love.keyboard.isDown('d') then
		light_ball.position[1] = light_ball.position[1] + 2 * dt
	end
	if love.keyboard.isDown('lshift') then
		light_ball.position[2] = light_ball.position[2] - 2 * dt
	end
	if love.keyboard.isDown('space') then
		light_ball.position[2] = light_ball.position[2] + 2 * dt
	end
	light_ball:updateMatrix ()
	tenball.material.uniforms.light_position = light_ball.position
end

function love.draw ()
	love.graphics.clear (unpack (sky_color))
	love.graphics.print ("FPS: "..fps, 5, 5)
	camera:drawObject (scene)
end
