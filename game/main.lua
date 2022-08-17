function love.load()
	UneditedScript = love.filesystem.read("script.txt")
	UneditedImageList = love.filesystem.read("image.txt")

	Line = 1;
	LineString = tostring(Line)

	ImageLocation = UneditedImageList:find(" 1 ")
	ImageName = UneditedImageList.sub(UneditedImageList, 2, ImageLocation-1)
	OldImageLocation = ImageLocation

	Image = love.graphics.newImage(ImageName)

	MoreLocation = UneditedScript:find("1")
	MoreLocationString = tostring(MoreLocation)
	OldMoreLocation = 0
	script = UneditedScript.sub(UneditedScript, OldMoreLocation, MoreLocation-1)
	OldMoreLocation = MoreLocation
end

function love.update()

end

function love.touchpressed(a, b, c, d, e, f)
	DrawNext()
end


function love.gamepadpressed(joystick, button)
	DrawNext()
end

function DrawNext()
	ToRemove = UneditedScript:find(LineString)
	Line = 1 + Line
	LineString = tostring(Line)

	ImageLocation = UneditedImageList:find(" "..LineString.." ")
	ImageName = UneditedImageList.sub(UneditedImageList, OldImageLocation+4, ImageLocation-1)
	OldImageLocation = ImageLocation

	Image = love.graphics.newImage(ImageName)

	MoreLocation = UneditedScript:find(LineString)
	MoreLocationString = tostring(MoreLocation)
	script = UneditedScript.sub(UneditedScript, OldMoreLocation+1, MoreLocation-1)
	OldMoreLocation = MoreLocation
end

function love.textinput(key)
	
end
	
function love.draw()
love.graphics.draw(Image, 0, 0)
love.graphics.print(LineString,20,20)
love.graphics.print(MoreLocationString)
love.graphics.print(script, 0, 100)
end
