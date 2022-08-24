function love.load()
	UneditedScript = love.filesystem.read("script.txt")
	UneditedImageList = love.filesystem.read("image.txt")
	QuestionList = love.filesystem.read("questions.txt")
	Song = love.audio.newSource("nitizyou1.mp3", "stream")
	Line = 1
	LineString = tostring(Line)
	ImageLocation = UneditedImageList:find(" 1 ")
	ImageName = UneditedImageList.sub(UneditedImageList, 2, ImageLocation-1)
	OldImageLocation = ImageLocation

	Image = love.graphics.newImage(ImageName)

	MoreLocation = UneditedScript:find("1")
	MoreLocationString = tostring(MoreLocation)
	OldMoreLocation = 2
	script = UneditedScript.sub(UneditedScript, OldMoreLocation, MoreLocation-1)
	OldMoreLocation = MoreLocation-1
end

function love.update()

end

function love.touchpressed(a, x, y, d, e, f)
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
if QuestionList:find(LineString+1) and QuestionAwnser == "blank" then
	QuesitonNotfication = true
else
	QuesitonNotfication = false
	Line = 1 + Line
	if Line >= 11 then
		OldImageLocation=OldImageLocation+1
		OldMoreLocation=OldMoreLocation+1
	end
	if Line >= 101 then
		OldImageLocation=OldImageLocation+1
		OldMoreLocation=OldMoreLocation+1
	end

	LineString = tostring(Line)

	if QuestionList:find(" "..LineString.." ") then
		if QuestionAwnser == "yes" then
			MoreLocation = UneditedScript:find(" "..LineString..".y ")
			OldMoreLocation = UneditedScript:find(" "..LineString..".y.s ")
			if Line >= 11 then
				OldMoreLocation=OldMoreLocation+1
			end
			if Line >= 101 then
				OldMoreLocation=OldMoreLocation+1
			end
			script = UneditedScript.sub(UneditedScript, OldMoreLocation+7, MoreLocation-1)
		end
		if QuestionAwnser == "no" then
			MoreLocation = UneditedScript:find(" "..LineString..".n ")
			OldMoreLocation = UneditedScript:find(" "..LineString..".n.s ")
			if Line >= 11 then
				OldMoreLocation=OldMoreLocation+1
			end
			if Line >= 101 then
				OldMoreLocation=OldMoreLocation+1
			end
			script = UneditedScript.sub(UneditedScript, OldMoreLocation+7, MoreLocation-1)
		end
		OldMoreLocation = UneditedScript:find(" "..LineString..".n ")+2
		if script:find("goto") ~= nul then
			DidGoto = true
			script = script.sub(script, 5, OldMoreLocation-1)
			Line = tonumber(script)
			LineString = script
			OldMoreLocation = UneditedScript:find(" "..LineString..".s ")
			MoreLocation = UneditedScript:find(" "..LineString.." ")
			if Line >= 11 then
				OldMoreLocation=OldMoreLocation+1
			end
			if Line >= 101 then
				OldMoreLocation=OldMoreLocation+1
			end
			script = UneditedScript.sub(UneditedScript, OldMoreLocation+5, MoreLocation-1)
			OldMoreLocation = MoreLocation
		end
	else
		MoreLocation = UneditedScript:find(" "..LineString.." ")
		MoreLocationString = tostring(MoreLocation)
		script = UneditedScript.sub(UneditedScript, OldMoreLocation+4, MoreLocation-1)
		OldMoreLocation = MoreLocation
	end
	if script:find("quit123") ~= nul then
		love.event.quit()
	end
	QuestionAwnser = "blank"
	if DidGoto then
		OldImageLocation = UneditedImageList:find(" "..LineString..".s ")
		if Line >= 11 then
			OldImageLocation=OldImageLocation+1
		end
		if Line >= 101 then
			OldImageLocation=OldImageLocation+1
		end
	end
	if UneditedImageList:find(" "..LineString.." ") then
	ImageLocation = UneditedImageList:find(" "..LineString.." ")
	ImageName = UneditedImageList.sub(UneditedImageList, OldImageLocation+4, ImageLocation-1)
	OldImageLocation = ImageLocation
	end

	Image = love.graphics.newImage(ImageName)
	DidGoto = false
end

if QuestionList:find(LineString+1) then
	QuesitonNotfication = true
end

end

function love.textinput(key)
	
end
	
function love.draw(Screen)
if Screen ~= "bottom" then
love.graphics.draw(Image, 0, 0)
love.graphics.printf(script, 0, 180, 400, "center")
end
if Screen ~= "left" and Screen ~= "right" then
love.graphics.print(LineString,20,20)
love.graphics.print(MoreLocationString)
if QuesitonNotfication == true then
love.graphics.printf("a = yes b = no", 0, 180, 300, "center")
end
end
end