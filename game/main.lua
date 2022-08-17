function love.load()
	UneditedScript = love.filesystem.read("script.txt")
	UneditedImageList = love.filesystem.read("image.txt")
	QuestionList = love.filesystem.read("questions.txt")
	Song = love.audio.newSource("nitizyou1.mp3", "stream")
	Line = 1;
	LineString = tostring(Line)

	ImageLocation = UneditedImageList:find(" 1 ")
	ImageName = UneditedImageList.sub(UneditedImageList, 2, ImageLocation-1)
	OldImageLocation = ImageLocation

	Image = love.graphics.newImage(ImageName)

	MoreLocation = UneditedScript:find("1")
	MoreLocationString = tostring(MoreLocation)
	OldMoreLocation = 2
	script = UneditedScript.sub(UneditedScript, OldMoreLocation, MoreLocation-1)
	OldMoreLocation = MoreLocation
end

function love.update()

end

function love.touchpressed(a, b, c, d, e, f)
	DrawNext()
end


function love.gamepadpressed(joystick, button)
	if button == "y" then
		if love.audio.getActiveSourceCount == 1 then
			love.audio.stop()
		else
			love.audio.play(Song)
		end
	else
	if button == "a" then
		QuestionAwnser = "yes"
	end
	if button == "b" then
		QuestionAwnser = "no"
	end
	DrawNext()
	end
end

function DrawNext()
	ToRemove = UneditedScript:find(LineString)
	Line = 1 + Line
	LineString = tostring(Line)

	ImageLocation = UneditedImageList:find(" "..LineString.." ")
	ImageName = UneditedImageList.sub(UneditedImageList, OldImageLocation+4, ImageLocation-1)
	OldImageLocation = ImageLocation

	Image = love.graphics.newImage(ImageName)

	if QuestionList:find(LineString) then
		OldMoreLocation = UneditedScript:find(" "..LineString..".n ")
		if QuestionAwnser == "yes" then
			MoreLocation = UneditedScript:find(" "..LineString..".y ")
			OldMoreLocation = UneditedScript:find(" "..LineString..".y.s ")
			script = UneditedScript.sub(UneditedScript, OldMoreLocation+7, MoreLocation-1)
		end
		if QuestionAwnser == "no" then
			MoreLocation = UneditedScript:find(" "..LineString..".n ")
			OldMoreLocation = UneditedScript:find(" "..LineString..".n.s ")
			script = UneditedScript.sub(UneditedScript, OldMoreLocation+7, MoreLocation-1)
		end
	else
		MoreLocation = UneditedScript:find(" "..LineString.." ")
		MoreLocationString = tostring(MoreLocation)
		script = UneditedScript.sub(UneditedScript, OldMoreLocation+4, MoreLocation-1)
		OldMoreLocation = MoreLocation
	end
	QuestionAwnser = "blank"
end

function love.textinput(key)
	
end
	
function love.draw()
love.graphics.draw(Image, 0, 0)
love.graphics.print(LineString,20,20)
love.graphics.print(MoreLocationString)
love.graphics.print(script, 0, 100)
end
