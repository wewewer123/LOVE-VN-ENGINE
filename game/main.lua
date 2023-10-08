function love.load()
	love.window.setFullscreen(true)
	utf8 = require("utf8")
	ScriptScript, Name, AskForName = unpack(require("script"))
	ImageScript = require("image")
	TouchScript = require("TouchList")
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
			ScreenWidth, ScreenHeight = love.graphics.getDimensions("left")
			if major <= 11 then
				textbox = love.graphics.newText(font, "")
			else
				textbox = love.graphics.newTextBatch(font, "")
			end
		end
	end

	font = love.graphics.newFont(28)
	NameFont = love.graphics.newFont(34)
	AnnounceFont = love.graphics.newFont(50)

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

	if love.system.getOS == "iOS" or love.system.getOS == "Android" then --idk if it works but touchscreen is touchscreen
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
	TouchStart = 0
	TouchPos = {0, 1, 2, 3}
	YesText = ""
	NoText = ""
	QuestionFindLine = 0
	QuesitonNotfication = false
	GotoStart = 0
	GotoText = ""
	MusicName = ""
	TouchPositions = {}
	RequireTouch = false
	TouchCalcTimes = 0

	DebugX=""
	DebugY=""


	DrawNext()

end
function love.update()
	CheckMusic()
	CheckKeyboard()
end

function CheckKeyboard()
	if AskForName then
		love.keyboard.setTextInput(true)
	else
		love.keyboard.setTextInput(false)
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	UseX = (x * (Image:getWidth() / ScreenWidth))
	Usex = (x / ScreenWidth) * Image:getWidth()
	UseY = (y * (Image:getHeight() / ScreenHeight))
	
	if ScreenWidth/ScreenHeight ~= Image:getWidth()/Image:getHeight() then
		if ScreenWidth/ScreenHeight > Image:getWidth()/Image:getHeight() then -- wider screen
			local scaleFactor = ScreenHeight / Image:getHeight()
			local scaledWidth = Image:getWidth() * scaleFactor
			local blackBars = (ScreenWidth - scaledWidth) / 2
			UseX = (x - blackBars) / scaleFactor
		end
		if ScreenWidth/ScreenHeight < Image:getWidth()/Image:getHeight() then -- slimmer screen
			local scaleFactor = ScreenWidth / Image:getWidth()
			local scaledHeight = Image:getHeight() * scaleFactor
			local blackBars = (ScreenHeight - scaledHeight) / 2
			UseY = (y - blackBars) / scaleFactor
		end
		UseX = math.min(math.max(0, UseX), Image:getWidth())
		UseY = math.min(math.max(0, UseY), Image:getHeight())
	end
	
	DebugX=UseX
	DebugY=UseY


	if RequireTouch then
		for i=0,TouchCalcTimes,1 do
			if tonumber(TouchPositions[1+(i*5)]) < UseX and UseX < tonumber(TouchPositions[2+(i*5)]) and tonumber(TouchPositions[3+(i*5)]) < UseY and UseY < tonumber(TouchPositions[4+(i*5)]) then
				RequireTouch = false
				Line = tonumber(TouchPositions[5+(i*5)])
				DrawNext()
			end
		end
	else
		if touchscreen then
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
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	UseX = (x * (Image:getWidth() / ScreenWidth))
	Usex = (x / ScreenWidth) * Image:getWidth()
	UseY = (y * (Image:getHeight() / ScreenHeight))
	
	if ScreenWidth/ScreenHeight ~= Image:getWidth()/Image:getHeight() then
		if ScreenWidth/ScreenHeight > Image:getWidth()/Image:getHeight() then -- wider screen
			local scaleFactor = ScreenHeight / Image:getHeight()
			local scaledWidth = Image:getWidth() * scaleFactor
			local blackBars = (ScreenWidth - scaledWidth) / 2
			UseX = (x - blackBars) / scaleFactor
		end
		if ScreenWidth/ScreenHeight < Image:getWidth()/Image:getHeight() then -- slimmer screen
			local scaleFactor = ScreenWidth / Image:getWidth()
			local scaledHeight = Image:getHeight() * scaleFactor
			local blackBars = (ScreenHeight - scaledHeight) / 2
			UseY = (y - blackBars) / scaleFactor
		end
		UseX = math.min(math.max(0, UseX), Image:getWidth())
		UseY = math.min(math.max(0, UseY), Image:getHeight())
	end
	
	DebugX=UseX
	DebugY=UseY


	if RequireTouch then
		for i=0,TouchCalcTimes,1 do
			if tonumber(TouchPositions[1+(i*5)]) < UseX and UseX < tonumber(TouchPositions[2+(i*5)]) and tonumber(TouchPositions[3+(i*5)]) < UseY and UseY < tonumber(TouchPositions[4+(i*5)]) then
				RequireTouch = false
				Line = tonumber(TouchPositions[5+(i*5)])
				DrawNext()
			end
		end
	else
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
end

function love.keypressed(key, scancode, isrepeat)
if RequireTouch ~= true then
	if AskForName then
		if key == "return" or key == "backspace" or key == "lgui" or key == "rgui" or key == "lalt" or key == "lctrl" or key == "ralt" or key == "rshift" or key == "rctrl" or key == "lshift" or key == "space" then
			if key == "return" then
				AskForName = false
				Line = Line - 1
				DrawNext()
			end

			if key == "backspace" then
				local byteoffset = utf8.offset(Name, -1)
				if byteoffset then
				Name = string.sub(Name, 1, byteoffset - 1)
				end
			end
		else 
			--if #Name ~= 0 then--if key == "lshift" then
				Name = Name .. key
			--else
			--	Name = Name .. key
			--end
		end
	else
		if key ~= "lgui" or key ~= "rgui" or key ~= "lalt" or key ~= "lctrl" or key ~= "ralt" or key ~= "rshift" or key ~= "rctrl" or key ~= "lshift" then
			MobileMode = false
			if key == "n" then
				AskForName = true
			end
			if key == "q" then
				ScriptScript.SetName()
			end
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
	end
end
end

function love.gamepadpressed(joystick, button)
if RequireTouch ~= true then
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
end

function DrawNext()
	QuesitonNotfication = false
	QuestionStart = 0
	RequireTouch = false
	UseX = 0
	UseY = 0

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
	TouchList()

	ScriptText = ScriptContainer[Line]

	if ScriptText == nil then
		MusicThread:wait()
		love.event.quit()
	end

	if ScriptText:find(" .name. ") ~= nil then
		Speaker = ScriptText.sub(ScriptText, 1, ScriptText:find(" .name. ")-1)
		if Speaker == "Name" then
			Speaker = Name
		end
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
		GotoStart = ScriptText:find(" ggg ")
		if tonumber(ScriptText.sub(ScriptText, GotoStart+5, #ScriptText)) then
			Line = tonumber(ScriptText.sub(ScriptText, GotoStart+5, #ScriptText))
			ScriptText = ScriptContainer[Line]
			--DrawImage()
			--DrawCharacter()
			--NewMusic()
			--TouchList()
			DrawNext()
		else
			GotoStart = ScriptText:find(" ggg ")
			GotoText = ScriptText.sub(ScriptText, GotoStart+5, #ScriptText)
			ScriptText = ScriptText:sub(1, GotoStart)
			for i = 1,#ScriptContainer,1 do
				if ScriptContainer[i]:find(GotoText) then
					Line = i
					ScriptText = ScriptContainer[Line]
			--DrawImage()
			--DrawCharacter()
			--NewMusic()
			--TouchList()
			DrawNext()
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
		else
			RequireTouch = false
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

function TouchList()
	for i = 1,#TouchContainer,1 do
		if TouchContainer[i]:find(" l"..Line.." ") ~= nil then
			TouchCalcTimes = 0
			s, TouchStuffStart = TouchContainer[i]:find(" l"..Line.." ")
			TouchText = string.sub(TouchContainer[i], TouchStuffStart+1, #TouchContainer[i])
			TouchRepeatText = TouchText
			s, RepeatTimes = TouchText:gsub(",", "")
			s, RepeatRepeatTimes = TouchText:gsub(":", "")
			if RepeatRepeatTimes ~= 0 then
				RepeatRepeatTimes = RepeatRepeatTimes + 1
				TouchSearch()
				for g = 1,RepeatRepeatTimes-1,1 do
					TouchRepeatText = string.gsub(TouchRepeatText, ":", "f", 1)
					TouchRepeatText = string.sub(TouchRepeatText, TouchRepeatText:find("f")+2, #TouchRepeatText)
					TouchText = TouchRepeatText
					TouchCalcTimes = g
					TouchSearch()
				end
			else
				RepeatRepeatTimes = 1
				TouchCalcTimes = 1
				TouchSearch()
			end
			if #TouchPositions >= 5 then
				RequireTouch = true;
			end
		end
	end
end

function TouchSearch()
	TouchCalcTimesUse = TouchCalcTimes*5
	for u = 1,RepeatTimes/RepeatRepeatTimes,1 do
		TouchText = string.gsub(TouchText, ",", "g", 1)
		TouchPositions[u+TouchCalcTimesUse] = string.sub(TouchText, 1, TouchText:find("g")-1)
		TouchText = string.sub(TouchText, TouchText:find("g")+1, #TouchText)
	end
end

function NewMusic()
	for i = 1,#MusicContainer,1 do
		if MusicContainer[i]:find(" "..Line.." ") ~= nil then
			if MusicName ~= string.sub(MusicContainer[i], 1, MusicContainer[i]:find(" "..Line.." ")-1) then
				love.audio.stop(Song)
				--Song = love.audio.newSource(string.sub(MusicContainer[i], 1, MusicContainer[i]:find(" "..Line.." ")-1), "stream")
				MusicThread:wait()
				MusicThread:start(string.sub(MusicContainer[i], 1, MusicContainer[i]:find(" "..Line.." ")-1))
				MusicName = string.sub(MusicContainer[i], 1, MusicContainer[i]:find(" "..Line.." ")-1)
			end
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
if AskForName ~= true then
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
			love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
			love.graphics.draw(Character, 0, (ScreenHeight/7), 0, 1, 1)
			love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()), (ScreenHeight/3), 0, 1, 1)
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
			love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
			love.graphics.draw(Character, 0, (ScreenHeight/7), 0, 1, 1)
			love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()), (ScreenHeight/3), 0, 1, 1)
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
		--pc, mobile or web
		love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
		love.graphics.draw(Character, 0, (ScreenHeight/7), 0, 1, 1)
		love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()), (ScreenHeight/3), 0, 1, 1)
		love.graphics.draw(textbox, 0, ScreenHeight/1.4, 0, ScreenWidth/textbox:getWidth(), 2)
		love.graphics.printf(Speaker, NameFont, 0, ScreenHeight/1.4, ScreenWidth, "center", 0, 1, 1)
		love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.25, ScreenWidth, "center", 0, 1, 1)

		--if DebugX ~= null then
			--love.graphics.printf(DebugX, NameFont, 0, ScreenHeight/1.4, ScreenWidth, "center", 0, 1, 1)
			--love.graphics.printf(DebugY, NameFont, 0, ScreenHeight/1.5, ScreenWidth, "center", 0, 1, 1)
		--end

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
				love.graphics.printf(NoText, font, ScreenWidth/4, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
				love.graphics.printf(YesText, font, 0-ScreenWidth/4, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			else
				love.graphics.printf("Enter = " .. YesText .. "\nSpace = " .. NoText, font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			end
		end
	end
else -- still gotta add 3ds support
	if screen ~= "bottom" then
		love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
		love.graphics.draw(textbox, (ScreenWidth-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getHeight()))/1.5, 0, math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight()))
		love.graphics.printf("Before we start, please enter your name.", AnnounceFont, 0, ScreenHeight/2, ScreenWidth, "center", 0, 1, 1)
		love.graphics.printf(Name, NameFont, 0, ScreenHeight/1.75, ScreenWidth, "center", 0, 1, 1)
	end
end
end