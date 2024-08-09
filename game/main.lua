function love.load()
	utf8 = require("utf8")
	ScriptScript, Name, AskForName = unpack(require("script"))
	TouchScript = require("TouchList")
	MusicThreading = require("MusicThreading")
	MusicThread = love.thread.newThread( MusicThreading )
	major, minor, revision, codename = love.getVersion( )

	font = love.graphics.newFont(28)
	NameFont = love.graphics.newFont(30)
	AnnounceFont = love.graphics.newFont(35)

	--major = 11
	if love.system.getOS() ~= "Horizon" then
		ScreenWidth, ScreenHeight = love.graphics.getDimensions( )
		textbox = love.graphics.newImage("textbox.png")
	else
		if love.system.getModel() ~= "RED" and love.system.getModel() ~= "CTR" and love.system.getModel() ~= "SPR" and love.system.getModel() ~= "KTR" and love.system.getModel() ~= "FTR" and love.system.getModel() ~= "JAN" then --None of the 2/3DS models
			ScreenWidth, ScreenHeight = love.graphics.getDimensions( )
			textbox = love.graphics.newImage("textbox.png")
		else
			ScreenWidth, ScreenHeight = love.graphics.getDimensions("left")
			BottomScreenWidth, BottomScreenHeight = love.graphics.getDimensions("bottom")
			if major <= 11 then
				textbox = love.graphics.newText(font, "")
			else
				textbox = love.graphics.newTextBatch(font, "")
			end
		end
	end

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

	if love.system.getOS() == "iOS" or love.system.getOS() == "Android" then --idk if it works but touchscreen is touchscreen
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
	MusicName = ""
	TouchPositions = {}
	RequireTouch = false
	TouchCalcTimes = 0
	TouchScaleNumber = 0
	UseX=0
	UseY=0
	DebugX=""
	DebugY=""
	XScale=0
	YScale=0

	DrawNext()

end
function love.update()
	CheckMusic()
	CheckKeyboard()
	RewindVideo()
end

function RewindVideo()
	if Image:type() == "Video" then
		if Image:isPlaying() == false then
		Image:rewind()
		Image:play()
		end
	end
end

function CheckKeyboard()
	if AskForName then
		if love.system.getOS() == "Horizon" then
			if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --All of the 2/3DS models
				love.keyboard.setTextInput("standard", false, "Please enter your name:")
				--love.keyboard.setTextInput(true)
			end
		else
			love.keyboard.setTextInput(true)
		end
	else
		love.keyboard.setTextInput(false)
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	MouseHandeler(x, y, ScreenWidth, ScreenHeight)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	if love.system.getOS() == "Horizon" then 
		if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the 2/3DS models
			MouseHandeler(x, y, BottomScreenWidth, BottomScreenHeight)
		else
			MouseHandeler(x, y, ScreenWidth, ScreenHeight)
		end
	else
		MouseHandeler(x, y, ScreenWidth, ScreenHeight)
	end
end

function MouseHandeler(x, y, ScreenWide, ScreenHigh)
if AskForName ~= true then
	UseX = (x * (Image:getWidth() / ScreenWide))
	UseY = (y * (Image:getHeight() / ScreenHigh))
	
	if ScreenWide/ScreenHigh ~= Image:getWidth()/Image:getHeight() then
		if ScreenWide/ScreenHigh > Image:getWidth()/Image:getHeight() then -- wider screen
			local scaleFactor = ScreenHigh / Image:getHeight()
			local scaledWidth = Image:getWidth() * scaleFactor
			local blackBars = (ScreenWide - scaledWidth) / 2
			UseX = (x - blackBars) / scaleFactor
		end
		if ScreenWide/ScreenHigh < Image:getWidth()/Image:getHeight() then -- slimmer screen
			local scaleFactor = ScreenWide / Image:getWidth()
			local scaledHeight = Image:getHeight() * scaleFactor
			local blackBars = (ScreenHigh - scaledHeight) / 2
			UseY = (y - blackBars) / scaleFactor
		end
		UseX = math.min(math.max(0, UseX), Image:getWidth())
		UseY = math.min(math.max(0, UseY), Image:getHeight())
	end
	
	UseX = UseX*TouchScaleNumber
	UseY = UseY*TouchScaleNumber

	DebugX=UseX
	DebugY=UseY

	if RequireTouch then
		for i=0,TouchCalcTimes,1 do
			if tonumber(TouchPositions[1+(i*5)]) < UseX and UseX < tonumber(TouchPositions[2+(i*5)]) and tonumber(TouchPositions[3+(i*5)]) < UseY and UseY < tonumber(TouchPositions[4+(i*5)]) then
				RequireTouch = false

				print(TouchCalcTimes)
				print(#TouchPositions)
				print(TouchPositions[5+(i*5)])


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
else
	AskForName = false
	Line = Line - 1
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
				return
			end
			if key == "m" then
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
if RequireTouch ~= true and AskForName ~= true then
	MobileMode = false
	if button == "y" then
		if Song:isPlaying() then
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
else
	if AskForName then
	AskForName = false
	Line = Line - 1
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

	if Line > #ScriptContainer then
		MusicThread:wait()
		love.event.quit()
	end

	DrawImage()
	DrawCharacter()
	NewMusic()
	TouchList()

	ScriptText = ScriptContainer[Line].text

	if ScriptText == nil then
		ScriptText = " "
		--MusicThread:wait()
		--love.event.quit()
	end

	if ScriptContainer[Line].name ~= 0 and ScriptContainer[Line].name ~= nil and ScriptContainer[Line].name ~= "" then
		Speaker = ScriptContainer[Line].name
		if Speaker == "Name" or Speaker == "name" then
			Speaker = Name
		end
	else
		Speaker = ""
	end

	if ScriptContainer[Line].question ~= nil then
		YesText = ScriptContainer[Line].question[1]
		NoText = ScriptContainer[Line].question[2]
		QuestionText = ScriptContainer[Line].question[3]
		if tonumber(QuestionText) then
			QuestionFindLine = tonumber(QuestionText)
			QuesitonNotfication = true
		else
			for i = 1,#ScriptContainer,1 do
				if type(ScriptContainer[i].text) == "string" then
					if ScriptContainer[i].text:find(QuestionText) and i ~= Line then
						QuestionFindLine = i
						QuesitonNotfication = true
					end
				end
			end
		end
	end

	if ScriptContainer[Line].move ~= nil and ScriptContainer[Line].move ~= "" then
		if tonumber(ScriptContainer[Line].move) then
			Line = tonumber(ScriptContainer[Line].move)
			DrawNext()
		else
			GotoText = ScriptContainer[Line].move
			for i = 1,#ScriptContainer,1 do
				if type(ScriptContainer[i].text) == "string" then
					if ScriptContainer[i].text:find(GotoText) and i ~= Line then
						Line = i
						DrawNext()
					end
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
	if ScriptContainer[Line].bg ~= 0 and ScriptContainer[Line].bg ~= nil and ScriptContainer[Line].bg ~= "" then
		if love.system.getOS() == "Horizon" then
			if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the supported ds models
				if major <= 11 then
					Image = love.graphics.newImage(ScriptContainer[Line].bg+".t3x")
				else
					Image = love.graphics.newTexture(ScriptContainer[Line].bg+".t3x")
				end
			else
				if major <= 11 then
					Image = love.graphics.newImage(ScriptContainer[Line].bg)
				else
					Image = love.graphics.newTexture(ScriptContainer[Line].bg)
				end
			end
		else
			if major <= 11 then
				Image = love.graphics.newImage(ScriptContainer[Line].bg)
			else
				Image = love.graphics.newTexture(ScriptContainer[Line].bg)
			end
		end
	end
end

function DrawCharacter()
	if ScriptContainer[Line].char1 ~= 0 and ScriptContainer[Line].char1 ~= nil and ScriptContainer[Line].char1 ~= "" then
		if ScriptContainer[Line].char1 == "nothing" then
			if major <= 11 then
				Character = love.graphics.newText(font, "")
			else
				Character = love.graphics.newTextBatch(font, "")
			end
		else
			if love.system.getOS() == "Horizon" then
				if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the supported ds models
					if major <= 11 then
						Character = love.graphics.newImage(ScriptContainer[Line].char1+".t3x")
					else
						Character = love.graphics.newTexture(ScriptContainer[Line].char1+".t3x")
					end
				else
					if major <= 11 then
						Character = love.graphics.newImage(ScriptContainer[Line].char1)
					else
						Character = love.graphics.newTexture(ScriptContainer[Line].char1)
					end
				end
			else
				if major <= 11 then
					Character = love.graphics.newImage(ScriptContainer[Line].char1)
				else
					Character = love.graphics.newTexture(ScriptContainer[Line].char1)
				end
			end
		end
	end

	if ScriptContainer[Line].char2 ~= 0 and ScriptContainer[Line].char2 ~= nil and ScriptContainer[Line].char2 ~= "" then
		if ScriptContainer[Line].char2 == "nothing" then
			if major <= 11 then
				SecondaryCharacter = love.graphics.newText(font, "")
			else
				SecondaryCharacter = love.graphics.newTextBatch(font, "")
			end
		else
			if love.system.getOS() == "Horizon" then
				if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the supported ds models
					if major <= 11 then
						SecondaryCharacter = love.graphics.newImage(ScriptContainer[Line].char2+".t3x")
					else
						SecondaryCharacter = love.graphics.newTexture(ScriptContainer[Line].char2+".t3x")
					end
				else
					if major <= 11 then
						SecondaryCharacter = love.graphics.newImage(ScriptContainer[Line].char2)
					else
						SecondaryCharacter = love.graphics.newTexture(ScriptContainer[Line].char2)
					end
				end
			else
				if major <= 11 then
					SecondaryCharacter = love.graphics.newImage(ScriptContainer[Line].char2)
				else
					SecondaryCharacter = love.graphics.newTexture(ScriptContainer[Line].char2)
				end
			end
		end
	end
end

function TouchList()
	for i = 1,#TouchContainer,1 do
		if TouchContainer[i]:find(" l"..Line.." ") ~= nil then
			TouchCalcTimes = 0; TouchStuffStart = 0; TouchText = ""; RepeatTimes = 0; RepeatRepeatTimes = 0; TouchCalcTimesUse = ""
			s, TouchStuffStart = TouchContainer[i]:find(" l"..Line.." ")
			TouchScale(i)
			--TouchScaleNumber = 1
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

function TouchScale(i)
	if TouchContainer[i]:find(" x") ~= nil and TouchContainer[i]:find(" y") ~= nil then
		XScale = tonumber(string.sub(TouchContainer[i], TouchContainer[i]:find(" x")+2, TouchContainer[i]:find(" y")-1))
		YScale = tonumber(string.sub(TouchContainer[i], TouchContainer[i]:find(" y")+2, TouchContainer[i]:find(" l")-1))

		--if XScale/Image:getWidth() == YScale/Image:getHeight() then
			TouchScaleNumber = XScale/Image:getWidth()
		--else
		--	TouchScaleNumber = 1
		--end
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
	if ScriptContainer[Line].music ~= 0 and ScriptContainer[Line].music ~= nil and ScriptContainer[Line].music ~= "" then
		if ScriptContainer[Line].music ~= MusicName then
			love.audio.stop(Song)
			--Song = love.audio.newSource(ScriptContainer[Line].music, "static")
			--if PlayingSong then
			--	love.audio.play(Song)
			--	Song:setLooping(true)
			--end
			MusicThread:wait()
			MusicThread:start(ScriptContainer[Line].music)
			MusicName = ScriptContainer[Line].music
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
	
function love.draw(Screen)
if AskForName ~= true then
	if love.system.getOS() == "Horizon" then 
		if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the 2/3DS models
			if Screen ~= "bottom" then --400*2x240
				love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
				love.graphics.draw(Character, 0, 0+(240-(Character:getHeight()*0.75)), 0, 0.75, 0.75)
				love.graphics.draw(SecondaryCharacter, 400-(SecondaryCharacter:getWidth()*0.75), 0+(240-(SecondaryCharacter:getHeight()*0.75)), 0, 0.75, 0.75)	
				if RequireTouch then
					love.graphics.printf(Speaker, NameFont, 0, 0, 400, "center", 0, 1, 1)
					love.graphics.printf(ScriptText, font, 0, 40, 400, "center", 0, 1, 1)
				end
			end
			if Screen == "bottom" then --320x240
				if RequireTouch then
					love.graphics.draw(Image, (BottomScreenWidth-(math.min(BottomScreenWidth/Image:getWidth(), BottomScreenHeight/Image:getHeight())*Image:getWidth()))/2, (BottomScreenHeight-(math.min(BottomScreenWidth/Image:getWidth(), BottomScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(BottomScreenWidth/Image:getWidth(), BottomScreenHeight/Image:getHeight()))
					return
				end
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
			love.graphics.draw(Character, 0, (ScreenHeight/3), 0, 0.75, 0.75)
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
	else if screen ~= nil then --WiiU
			love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
			love.graphics.draw(Character, 0, (ScreenHeight/3), 0, 0.75, 0.75)
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
		love.graphics.draw(Character, 0, (ScreenHeight/3), 0, 0.75, 0.75)
		love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()), (ScreenHeight/3), 0, 0.75, 0.75)
		love.graphics.draw(textbox, 0, ScreenHeight/1.4, 0, ScreenWidth/textbox:getWidth(), 2)
		love.graphics.printf(Speaker, NameFont, 0, ScreenHeight/1.4, ScreenWidth, "center", 0, 1, 1)
		love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.25, ScreenWidth, "center", 0, 1, 1)

		--if DebugX ~= null then
		--	love.graphics.printf(DebugX, NameFont, 0, ScreenHeight/1.4, ScreenWidth, "center", 0, 1, 1)
		--	love.graphics.printf(DebugY, NameFont, 0, ScreenHeight/1.5, ScreenWidth, "center", 0, 1, 1)
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
	if screen ~= "left" and screen ~= "right" then
		if love.system.getOS() == "Horizon" then
			if love.system.getModel() ~= "RED" and love.system.getModel() ~= "CTR" and love.system.getModel() ~= "SPR" and love.system.getModel() ~= "KTR" and love.system.getModel() ~= "FTR" and love.system.getModel() ~= "JAN" then --None of the 2/3DS models
				love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
				love.graphics.draw(textbox, (ScreenWidth-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getHeight()))/6, 0, math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight()))
				love.graphics.printf("Before we start, please enter your name.", AnnounceFont, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
				love.graphics.printf(Name, NameFont, 0, ScreenHeight/3.5, ScreenWidth, "center", 0, 1, 1)
			else --2/3DS
				AskForName = false
				Line = Line - 1
				DrawNext()
			end
		else
			love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
			love.graphics.draw(textbox, (ScreenWidth-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getHeight()))/6, 0, math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight()))
			love.graphics.printf("Before we start, please enter your name.", AnnounceFont, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			love.graphics.printf(Name, NameFont, 0, ScreenHeight/3.5, ScreenWidth, "center", 0, 1, 1)
		end
	end
end
end