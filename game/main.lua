function love.load()

	TestImage = love.graphics.newImage("test.t3x")
	UneditedScript = love.filesystem.read("script.txt")

	Line = 1;
	LineString = tostring(Line)
	MoreLocation = UneditedScript:find("1")
	MoreLocationString = tostring(MoreLocation)
	OldMoreLocation = 0
	script = UneditedScript.sub(UneditedScript, OldMoreLocation, MoreLocation-1)
	OldMoreLocation = MoreLocation
end

function love.update()

end

function love.touchpressed(a, b, c, d, e, f)
	--love.keyboard.setTextInput()
end


function love.gamepadpressed(joystick, button)
	if button == "a" then
		--love.keyboard.setTextInput()
	end
	if button == "b" then
		ToRemove = UneditedScript:find(LineString)
		Line = 1 + Line
		LineString = tostring(Line)
		MoreLocation = UneditedScript:find(LineString)
		MoreLocationString = tostring(MoreLocation)
		script = UneditedScript.sub(UneditedScript, OldMoreLocation+1, MoreLocation-1)
		OldMoreLocation = MoreLocation
	end
end

function love.textinput(key)
	
end
	
function love.draw()
love.graphics.draw(TestImage, 0, 0)
love.graphics.print(LineString)
love.graphics.print(script,100,10)

love.graphics.print(MoreLocationString)
love.graphics.print(script, 0, 100)
end
