function love.load()
	ScriptScript = require("script")
	ImageScript = require("image")
	if love.system.getOS() ~= "Horizon" then
		ScreenWidth, ScreenHeight = love.graphics.getDimensions( )
		font = love.graphics.newFont(28)
	else
		font = love.graphics.newFont("standard")
	end
	major, minor, revision, codename = love.getVersion( )
	Song = love.audio.newSource("nitizyou1.mp3", "stream")

	Line = 1
	ScriptText = ""
	UpCount = 0
	QuestionStart = 0
	QuestionText = ""
	QuestionFindLine = 0
	QuesitonNotfication = false
	GotoStart = 0
	GotoText = ""
	DrawNext()
end

function love.update()

end

function love.touchpressed(a, x, y, d, e, f)
	DrawNext()
end

function love.keypressed( key, scancode, isrepeat )
	if key == "t" then
		if love.audio.getActiveSourceCount ~= 0 then
			love.audio.stop()
		else
			love.audio.play(Song)
		end
	else
		if key == "return" then
			QuestionAwnser = "yes"
		end
		if key == "space" then
			QuestionAwnser = "no"
		end
	end
	DrawNext()
end

function love.gamepadpressed(joystick, button)
	if button == "y" then
		if Song:isPlaying() then
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
	QuesitonNotfication = false
	QuestionStart = 0

	if QuestionFindLine ~= 0 then
		if QuestionAwnser == "no" then
			Line = QuestionFindLine
			QuestionFindLine = 0
		end
		if QuestionAwnser == "yes" then
			QuestionFindLine = 0
		end
		if QuestionAwnser == "" then
			QuesitonNotfication = true
			do return end
		end
	end

	DrawImage()

	ScriptText = ScriptContainer[Line]

	if ScriptText == nil then
		love.event.quit()
	end

	if ScriptText:find(" qqq ") ~= nil then
		QuestionStart = ScriptText:find(" qqq ")
		QuestionText = ScriptText.sub(ScriptText, QuestionStart+5, #ScriptText)
		ScriptText = ScriptText:sub(1, QuestionStart)
		for i = 1,#ScriptContainer,1 do
			if ScriptContainer[i]:find(QuestionText) then
				QuestionFindLine = i
				QuesitonNotfication = true
				if love.system.getOS() ~= "Horizon" then
					love.keyboard.setTextInput(true)
				end
			end
		end
	end

	if ScriptText:find(" ggg ") ~= nil then
		GotoStart = ScriptText:find(" ggg ")
		GotoText = ScriptText.sub(ScriptText, GotoStart+5, #ScriptText)
		ScriptText = ScriptText:sub(1, GotoStart)
		for i = 1,#ScriptContainer,1 do
			if ScriptContainer[i]:find(GotoText) then
				Line = i
				ScriptText = ScriptContainer[Line]
				DrawImage()
			end
		end
	end

	if ScriptText:find("123quit123") ~= nil then
		love.event.quit()
	end

	Line = Line + 1

	UpCount = 0
	if #ScriptText >= 70 then
		UpCount=UpCount+1
	end
	if #ScriptText >= 105 then
		UpCount=UpCount+1
	end
	if #ScriptText >= 140 then
		UpCount=UpCount+1
	end
	if #ScriptText >= 175 then
		UpCount=UpCount+1
	end

	QuestionAwnser = ""
	QuestionText = ""
end

function DrawImage()
	for i = 1,#ImageContainer,1 do
		if ImageContainer[i]:find(" "..Line.." ") ~= nil then
			if major ~= 12 then
				Image = love.graphics.newImage(string.sub(ImageContainer[i], 1, ImageContainer[i]:find(" "..Line.." ")-1))
			else
				Image = love.graphics.newTexture(string.sub(ImageContainer[i], 1, ImageContainer[i]:find(" "..Line.." ")-1))
			end
		end
	end
end

function love.textinput(key)
	
end
	
function love.draw(Screen)
if Screen ~= nil then
	if Screen ~= "bottom" then
		love.graphics.draw(Image, 0, 0)
		love.graphics.printf(ScriptText, font, 200, 180-(UpCount*20), 200, "center", 0, 2, 2)
	end
	if Screen ~= "left" and Screen ~= "right" then
	if QuesitonNotfication == true then
		love.graphics.printf("A = yes, B = no", font, 160, 120, 150, "center", 0, 3, 3)
	end
	--love.graphics.printf(ScriptText, font, 160, 180-(UpCount*20), 150, "center", 0, 2, 2)
	end
else
	love.graphics.draw(Image, 0, 0)
	love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.5, ScreenWidth, "center", 0, 1, 1)
	if QuesitonNotfication == true then
		love.graphics.printf("Enter = yes, Space = no", font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
	end
end
end