--require("script")
function love.load()
	font = love.graphics.newFont("standard")
	ScriptScript = require("script")
	ImageScript = require("image")
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
	GotoFindLine = 0
	GotoGoto = false
	DrawNext()
	--Image = love.graphics.newImage(ImageName)
	--Image = love.graphics.newImage("test.t3x")
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

	--if GotoGoto then
	--	Line = GotoFindLine
	--	GotoGoto = false
	--end

	DrawImage()

	ScriptText = ScriptContainer[Line]

	if ScriptText == nil then
		--ScriptText = "Nil"
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
			end
		end
	end

	if ScriptText:find(" ggg ") ~= nil then
		GotoStart = ScriptText:find(" ggg ")
		GotoText = ScriptText.sub(ScriptText, GotoStart+5, #ScriptText)
		ScriptText = ScriptText:sub(1, GotoStart)
		for i = 1,#ScriptContainer,1 do
			if ScriptContainer[i]:find(GotoText) then
				--GotoFindLine = i
				--GotoGoto = true

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
			--Image = love.graphics.newImage(string.sub(ImageContainer[i], 1, ImageContainer[i]:find(" "..Line.." ")-1))
			Image = love.graphics.newTexture(string.sub(ImageContainer[i], 1, ImageContainer[i]:find(" "..Line.." ")-1))
		end
	end
end

function love.textinput(key)
	
end
	
function love.draw(Screen)
if Screen ~= "bottom" then
love.graphics.draw(Image, 0, 0)
love.graphics.printf(ScriptText, font, 200, 180-(UpCount*20), 200, "center", 0, 2, 2)
end
if Screen ~= "left" and Screen ~= "right" then
--love.graphics.print(LineString,20,20)
--love.graphics.print(MoreLocationString)
if QuesitonNotfication == true then
love.graphics.printf("A = yes B = no", font, 160, 120, 150, "center", 0, 3, 3)
--love.graphics.printf(ScriptText, font, 160, 180-(UpCount*20), 150, "center", 0, 2, 2)
end
end
end