function love.load()
	ScriptScript = require("script")
	ImageScript = require("image")
	CharacterScript = require("character")
	MusicScript = require("music")
	MusicThreading = require("MusicThreading")
	MusicThread = love.thread.newThread( MusicThreading )
	if love.system.getOS() ~= "Horizon" then
		ScreenWidth, ScreenHeight = love.graphics.getDimensions( )
	else
		if love.system.getModel() ~= "RED" or love.system.getModel() ~= "CTR" or love.system.getModel() ~= "SPR" or love.system.getModel() ~= "KTR" or love.system.getModel() ~= "FTR" or love.system.getModel() ~= "JAN" then --None of the 2/3DS models
			ScreenWidth, ScreenHeight = love.graphics.getDimensions( )
		end
	end

	font = love.graphics.newFont(28)

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

	PlayingSong = true
	LoadingMusic = false
	Line = 1
	ScriptText = ""
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

function love.touchpressed(a, x, y, d, e, f)
	DrawNext()
end

function love.keypressed( key, scancode, isrepeat )
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

	if ScriptText:find(" qqq ") ~= nil then
		QuestionStart = ScriptText:find(" qqq ")
		QuestionText = ScriptText.sub(ScriptText, QuestionStart+5, ScriptText:find(" yyy ")-1)
		YesText = ScriptText.sub(ScriptText, ScriptText:find(" yyy ")+5, ScriptText:find(" nnn ")-1)
		NoText = ScriptText.sub(ScriptText, ScriptText:find(" nnn ")+5, #ScriptText)
		ScriptText = ScriptText:sub(1, QuestionStart)
		if tonumber(QuestionText) then
			QuestionFindLine = tonumber(QuestionText)
			QuesitonNotfication = true
			if love.system.getOS() ~= "Horizon" then
				love.keyboard.setTextInput(true)
			end
		else
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
			love.graphics.draw(Character, 0, 120, 0, 0.75, 0.75)
			love.graphics.draw(SecondaryCharacter, 400-(SecondaryCharacter:getWidth()*0.75), 0+(240-(SecondaryCharacter:getHeight()*0.75)), 0, 0.75, 0.75)	
		end
		if Screen == "bottom" then --320x240
			love.graphics.printf(ScriptText, font, 0, 0, 320, "center", 0, 1, 1)
			if LoadingMusic then
				love.graphics.printf("Loading Song", font, 0, 180, 320, "center", 0, 1, 1)
			end
			if QuesitonNotfication == true then
				love.graphics.printf("A = " .. YesText .. "\nB = " .. NoText, font, 0, 180, 320, "center", 0, 1, 1)
			end
		end
	else --switch
		love.graphics.draw(Image, 0, 0)
		love.graphics.draw(Character, 0, (ScreenHeight/3.5), 0, 0.5, 0.5)
		love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()/2), (ScreenHeight/3.5), 0, 0.5, 0.5)
		love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.5, ScreenWidth, "center", 0, 1, 1)
		if LoadingMusic then
			love.graphics.printf("Loading Song", font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
		if QuesitonNotfication == true then
			love.graphics.printf("A = " .. YesText .. "\nB = " .. NoText, font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
	end
else if(screen) ~= nil then --WiiU
		love.graphics.draw(Image, 0, 0)
		love.graphics.draw(Character, 0, (ScreenHeight/3.5), 0, 0.5, 0.5)
		love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()/2), (ScreenHeight/3.5), 0, 0.5, 0.5)
		love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.5, ScreenWidth, "center", 0, 1, 1)
		if LoadingMusic then
			love.graphics.printf("Loading Song", font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
		if QuesitonNotfication == true then
			love.graphics.printf("A = " .. YesText .. "\nB = " .. NoText, font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
	end
	--pc or mobile
	love.graphics.draw(Image, 0, 0)
	love.graphics.draw(Character, 0, (ScreenHeight/3.5), 0, 0.5, 0.5)
	love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()/2), (ScreenHeight/3.5), 0, 0.5, 0.5)
	love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.5, ScreenWidth, "center", 0, 1, 1)
	if LoadingMusic then
		love.graphics.printf("Loading Song", font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
	end
	if QuesitonNotfication == true then
		love.graphics.printf("Enter = " .. YesText .. "\nSpace = " .. NoText, font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
	end
end
end