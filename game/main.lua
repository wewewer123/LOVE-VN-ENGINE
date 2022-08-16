--require "sprites.t3x"
function love.load()

	TestImage = love.graphics.newImage("test.t3x")
	script = love.filesystem.read("script.txt")

	MoreLocation = script:find("More")
end

function love.update()

end

function love.touchpressed(a, b, c, d, e, f)
	love.keyboard.setTextInput( enable )
end


function love.gamepadpressed(joystick, button)
	if button == "a" then
		love.keyboard.setTextInput( enable )
	end
end

function love.textinput(key)
	
end
	
function love.draw()
love.graphics.draw(TestImage, 0, 0)
love.graphics.print(script,0,0)
EditedScript = tostring(love.filesystem.read("script.txt", MoreLocation-1))
--love.graphics.print(script:gsub(EditedScript))
love.graphics.print(love.filesystem.read("script.txt", MoreLocation-1), 0, 100)
end
