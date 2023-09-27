function love.load()
	ScriptScript = require("script")
	ImageScript = require("image")
	CharacterScript = require("character")
	MusicScript = require("music")
	MusicThreading = require("MusicThreading")
	MusicThread = love.thread.newThread( MusicThreading )
	if love.system.getOS() ~= "Horizon" then
		ScreenWidth, ScreenHeight = love.graphics.getDimensions( )
		textbox = love.graphics.newImage("textbox.png")
	else
		if love.system.getModel() ~= "RED" or love.system.getModel() ~= "CTR" or love.system.getModel() ~= "SPR" or love.system.getModel() ~= "KTR" or love.system.getModel() ~= "FTR" or love.system.getModel() ~= "JAN" then --None of the 2/3DS models
			ScreenWidth, ScreenHeight = love.graphics.getDimensions( )
			textbox = love.graphics.newImage("textbox.png")
		else
			if major <= 11 then
				textbox = love.graphics.newText(font, "")
			else
				textbox = love.graphics.newTextBatch(font, "")
			end
		end
	end

	font = love.graphics.newFont(28)
	NameFont = love.graphics.newFont(34)

	major, minor, revision, codename = love.getVersion( )
	Song = love.audio.newSource("silent.mp3", "stream")
	if major <= 11 then
		Image = love.graphics.newText(font, "")
		Character = love.graphics.newText(font, "")
		SecondaryCharacter = love.graphics.newText(font, "")
	else
		Image = love.graphics.newTextBatch(font, "")
		Character = love.graphics.newTextBatch(font, "")
		SecondaryCharacter = love.graphics.newTextBatch(font, "")
	end

	if love.system.getOS == "ios" or love.system.getOS == "android" then --idk if it works but touchscreen is touchscreen
		MobileMode = true
	else
		MobileMode = false
	end

	PlayingSong = true
	LoadingMusic = false
	Line = 1
	ScriptText = ""
	Speaker = ""
	QuestionStart = 0
	QuestionText = ""
	YesText = ""
	NoText = ""
	QuestionFindLine = 0
	QuesitonNotfication = false
	GotoStart = 0
	GotoText = ""

	DrawNext()

end
function love.update()
	CheckMusic()
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	if love.system.getOS() ~= "Horizon" and love.system.getOS() ~= "Cafe" then
		MobileMode = true
		if 0 < x and x < ScreenWidth/2 and 0 < y and y < ScreenHeight/2 then
			QuestionAwnser = "yes"
		end
		if ScreenWidth/2 < x and x < ScreenWidth and 0 < y and y < ScreenHeight/2 then
			QuestionAwnser = "no"
		end
	end
	DrawNext()
end

function love.keypressed(key, scancode, isrepeat)
	MobileMode = false
	if key == "t" then
		if Song:isPlaying() then
			love.audio.stop(Song)
			PlayingSong = false
		else
			love.audio.play(Song)
			PlayingSong = true
		end
	else
		if key == "return" then
			QuestionAwnser = "yes"
		end
		if key == "space" then
			QuestionAwnser = "no"
		end
		DrawNext()
	end
end

function love.gamepadpressed(joystick, button)
	MobileMode = false
	if button == "y" then
		if PlayingSong then
			love.audio.stop(Song)
			PlayingSong = false
		else
			love.audio.play(Song)
			PlayingSong = true
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
	DrawCharacter()
	NewMusic()

	ScriptText = ScriptContainer[Line]

	if ScriptText == nil then
		MusicThread:wait()
		love.event.quit()
	end

	if ScriptText:find(" .name. ") ~= nil then
		Speaker = ScriptText.sub(ScriptText, 1, ScriptText:find(" .name. ")-1)
		ScriptText = ScriptText:sub(ScriptText:find(" .name. ")+7, #ScriptText)
	else
		Speaker = ""
	end

	if ScriptText:find(" qqq ") ~= nil then
		QuestionStart = ScriptText:find(" qqq ")
		QuestionText = ScriptText.sub(ScriptText, QuestionStart+5, ScriptText:find(" yyy ")-1)
		YesText = ScriptText.sub(ScriptText, ScriptText:find(" yyy ")+5, ScriptText:find(" nnn ")-1)
		NoText = ScriptText.sub(ScriptText, ScriptText:find(" nnn ")+5, #ScriptText)
		ScriptText = ScriptText:sub(1, QuestionStart)
		if tonumber(QuestionText) then
			QuestionFindLine = tonumber(QuestionText)
			QuesitonNotfication = true
		else
			for i = 1,#ScriptContainer,1 do
				if ScriptContainer[i]:find(QuestionText) then
					QuestionFindLine = i
					QuesitonNotfication = true
				end
			end
		end
	end

	if ScriptText:find(" ggg ") ~= nil then
		if tonumber(ScriptText.sub(ScriptText, GotoStart+5, #ScriptText)) then
			Line = tonumber(ScriptText.sub(ScriptText, GotoStart+5, #ScriptText))
			ScriptText = ScriptContainer[Line]
			DrawImage()
			DrawCharacter()
			NewMusic()
		else
			GotoStart = ScriptText:find(" ggg ")
			GotoText = ScriptText.sub(ScriptText, GotoStart+5, #ScriptText)
			ScriptText = ScriptText:sub(1, GotoStart)
			for i = 1,#ScriptContainer,1 do
				if ScriptContainer[i]:find(GotoText) then
					Line = i
					ScriptText = ScriptContainer[Line]
					DrawImage()
					DrawCharacter()
					NewMusic()
				end
			end
		end
	end

	if ScriptText:find("123quit123") ~= nil then
		MusicThread:wait()
		love.event.quit()
	end

	Line = Line + 1

	QuestionAwnser = ""
	QuestionText = ""
end

function DrawImage()
	for i = 1,#ImageContainer,1 do
		if ImageContainer[i]:find(" "..Line.." ") ~= nil then
			if string.sub(ImageContainer[i], 1, ImageContainer[i]:find(" "..Line.." ")-1) == "nothing" then
				if major <= 11 then
					Image = love.graphics.newText(font, "")
				else
					Image = love.graphics.newTextBatch(font, "")
				end
			else
				if major <= 11 then
					Image = love.graphics.newImage(string.sub(ImageContainer[i], 1, ImageContainer[i]:find(" "..Line.." ")-1))
				else
					Image = love.graphics.newTexture(string.sub(ImageContainer[i], 1, ImageContainer[i]:find(" "..Line.." ")-1))
				end
			end
		end
	end
end

function DrawCharacter()
	for i = 1,#CharacterContainer,1 do
		if CharacterContainer[i]:find(" "..Line.." ") ~= nil then
			if string.sub(CharacterContainer[i], 1, CharacterContainer[i]:find(" "..Line.." ")-1) == "nothing" then
				if major <= 11 then
					Character = love.graphics.newText(font, "")
				else
					Character = love.graphics.newTextBatch(font, "")
				end
			else
				if major <= 11 then
					Character = love.graphics.newImage(string.sub(CharacterContainer[i], 1, CharacterContainer[i]:find(" "..Line.." ")-1))
				else
					Character = love.graphics.newTexture(string.sub(CharacterContainer[i], 1, CharacterContainer[i]:find(" "..Line.." ")-1))
				end
			end
		end
	end
	for i = 1,#SecondaryCharacterContainer,1 do
		if SecondaryCharacterContainer[i]:find(" "..Line.." ") ~= nil then
			if string.sub(SecondaryCharacterContainer[i], 1, SecondaryCharacterContainer[i]:find(" "..Line.." ")-1) == "nothing" then
				if major <= 11 then
					SecondaryCharacter = love.graphics.newText(font, "")
				else
					SecondaryCharacter = love.graphics.newTextBatch(font, "")
				end
			else
			if major <= 11 then
				SecondaryCharacter = love.graphics.newImage(string.sub(SecondaryCharacterContainer[i], 1, SecondaryCharacterContainer[i]:find(" "..Line.." ")-1))
			else
				SecondaryCharacter = love.graphics.newTexture(string.sub(SecondaryCharacterContainer[i], 1, SecondaryCharacterContainer[i]:find(" "..Line.." ")-1))
			end
		end
	end
end
end

function NewMusic()
	for i = 1,#MusicContainer,1 do
		if MusicContainer[i]:find(" "..Line.." ") ~= nil then
			love.audio.stop(Song)
			--Song = love.audio.newSource(string.sub(MusicContainer[i], 1, MusicContainer[i]:find(" "..Line.." ")-1), "stream")
			MusicThread:wait()
			MusicThread:start(string.sub(MusicContainer[i], 1, MusicContainer[i]:find(" "..Line.." ")-1))
		end
	end
end

function CheckMusic()
	info = love.thread.getChannel( 'music' ):pop()
	if info then
		if tonumber(info) then
			LoadingMusic = true
		else
		Song = info
		LoadingMusic = false
			if PlayingSong then
				love.audio.play(Song)
				Song:setLooping(true)
				PlayingSong = true
			else
				love.audio.stop()
				Song:setLooping(true)
				PlayingSong = false
			end
		end
	end
end

function love.textinput(key)
	
end
	
function love.draw(Screen)
if love.system.getOS() == "Horizon" then 
	if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the 2/3DS models
		if Screen ~= "bottom" then --400*2x240
			love.graphics.draw(Image, 0, 0)
			love.graphics.draw(Character, 0, 0+(240-(SecondaryCharacter:getHeight()*0.75)), 0, 0.75, 0.75)
			love.graphics.draw(SecondaryCharacter, 400-(SecondaryCharacter:getWidth()*0.75), 0+(240-(SecondaryCharacter:getHeight()*0.75)), 0, 0.75, 0.75)	
		end
		if Screen == "bottom" then --320x240
			love.graphics.printf(Speaker, NameFont, 0, 0, 320, "center", 0, 1, 1)
			love.graphics.printf(ScriptText, font, 0, 40, 320, "center", 0, 1, 1)
			if LoadingMusic then
				love.graphics.printf("Loading Song", font, 0, 180, 320, "center", 0, 1, 1)
			end
			if QuesitonNotfication == true then
				love.graphics.printf("A = " .. YesText .. "\nB = " .. NoText, font, 0, 180, 320, "center", 0, 1, 1)
			end
		end
	else --switch
		love.graphics.draw(Image, 0, 0)
		love.graphics.draw(Character, 0, (ScreenHeight/7), 0, 1, 1)
		love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()), (ScreenHeight/7), 0, 1, 1)
		love.graphics.draw(textbox, 0, ScreenHeight/1.4, 0, 1, 2)
		love.graphics.printf(Speaker, NameFont, 0, ScreenHeight/1.4, ScreenWidth, "center", 0, 1, 1)
		love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.25, ScreenWidth, "center", 0, 1, 1)
		if LoadingMusic then
			love.graphics.printf("Loading Song", font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
		if QuesitonNotfication == true then
			love.graphics.printf("A = " .. YesText .. "\nB = " .. NoText, font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
	end
else if(screen) ~= nil then --WiiU
		love.graphics.draw(Image, 0, 0)
		love.graphics.draw(Character, 0, (ScreenHeight/7), 0, 1, 1)
		love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()), (ScreenHeight/7), 0, 1, 1)
		love.graphics.draw(textbox, 0, ScreenHeight/1.4, 0, 1, 2)
		love.graphics.printf(Speaker, NameFont, 0, ScreenHeight/1.4, ScreenWidth, "center", 0, 1, 1)
		love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.25, ScreenWidth, "center", 0, 1, 1)
		if LoadingMusic then
			love.graphics.printf("Loading Song", font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
		if QuesitonNotfication == true then
			love.graphics.printf("A = " .. YesText .. "\nB = " .. NoText, font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
	end
	--pc or mobile
	love.graphics.draw(Image, 0, 0)
	love.graphics.draw(Character, 0, (ScreenHeight/7), 0, 1, 1)
	love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()), (ScreenHeight/7), 0, 1, 1)
	love.graphics.draw(textbox, 0, ScreenHeight/1.4, 0, 1, 2)
	love.graphics.printf(Speaker, NameFont, 0, ScreenHeight/1.4, ScreenWidth, "center", 0, 1, 1)
	love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.25, ScreenWidth, "center", 0, 1, 1)
	if LoadingMusic then
		love.graphics.printf("Loading Song", font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
	end
	if QuesitonNotfication == true then
		if MobileMode then
			love.graphics.setColor(0.10,1.00,0.40, 0.25)
			love.graphics.polygon("fill", 0,0, ScreenWidth/2,0, ScreenWidth/2,ScreenHeight/2, 0,ScreenHeight/2)

			love.graphics.setColor(0,0,0)
			--love.graphics.polygon("line", 0,0, ScreenWidth/2,0, ScreenWidth/2,ScreenHeight/2, 0,ScreenHeight/2)
			--love.graphics.polygon("line", 10,10, ScreenWidth/2-10,10, ScreenWidth/2-10,ScreenHeight/2-10, 10,ScreenHeight/2-10)
			--for i = 1,10,1 do --def gotta change this but the headaches that it produces makes me be fine with waiting.
			--love.graphics.polygon("line", i,i, ScreenWidth/2-i,i, ScreenWidth/2-i,ScreenHeight/2-i, i,ScreenHeight/2-i)
			--end

			love.graphics.setColor(1.00,0.20,0.20, 0.25)
			love.graphics.polygon("fill", ScreenWidth,0, ScreenWidth/2,0, ScreenWidth/2,ScreenHeight/2, ScreenWidth,ScreenHeight/2)

			--love.graphics.setColor(0,0,0)
			--for i = 1,10,1 do --def gotta change this but the headaches that it produces makes me be fine with waiting.
			--	love.graphics.polygon("line", ScreenWidth-i,i, ScreenWidth/2-i,i, ScreenWidth/2-i,ScreenHeight/2-i, ScreenWidth-i,ScreenHeight/2-i)
			--end
			--love.graphics.polygon("line", ScreenWidth,0, ScreenWidth/2,0, ScreenWidth/2,ScreenHeight/2, ScreenWidth,ScreenHeight/2)

			love.graphics.setColor(1,1,1)
			love.graphics.printf(NoText, font, 0-ScreenWidth/4, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			love.graphics.printf(YesText, font, ScreenWidth/4, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		else
			love.graphics.printf("Enter = " .. YesText .. "\nSpace = " .. NoText, font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
	end
end
end