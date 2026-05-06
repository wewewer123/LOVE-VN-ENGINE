function love.load()
	_debug = false

	utf8 = require("utf8")
	ScriptScript, NameRead, AskForName = unpack(require("script"))
	MusicThreading = require("MusicThreading")
	MusicThread = love.thread.newThread( MusicThreading )
	major, minor, revision, codename = love.getVersion( )

	font = love.graphics.newFont(28)
	NameFont = love.graphics.newFont(30)
	AnnounceFont = love.graphics.newFont(35)
	
	if love._os ~= "horizon" then
		ScreenWidth, ScreenHeight = love.graphics.getDimensions( )
		textbox = love.graphics.newImage("textbox.png")
	else
		if love._console ~= "3ds" then --love.system.getModel() ~= "RED" and love.system.getModel() ~= "CTR" and love.system.getModel() ~= "SPR" and love.system.getModel() ~= "KTR" and love.system.getModel() ~= "FTR" and love.system.getModel() ~= "JAN" then --None of the 2/3DS models
			ScreenWidth, ScreenHeight = love.graphics.getDimensions( )
			textbox = love.graphics.newImage("textbox.png")
		else
			ScreenWidth, ScreenHeight = love.graphics.getDimensions("left")
			BottomScreenWidth, BottomScreenHeight = love.graphics.getDimensions("bottom")
			textbox = love.graphics.newText(font, "")
		end
	end

	Song = love.audio.newSource("silent.mp3", "stream")

	Image = love.graphics.newText(font, "")
	Character = love.graphics.newText(font, "")
	SecondaryCharacter = love.graphics.newText(font, "")

	if love.system.getOS() == "iOS" or love.system.getOS() == "Android" then --idk if it works but touchscreen is touchscreen
		MobileMode = true
	else
		MobileMode = false
	end

	Name=NameRead
	PlayingSong = true
	LoadingMusic = false
	Line = 1
	ScriptText = ""
	Speaker = ""
	QuestionFindLine = {}
	QuestionOptionText = {}
	QuesitonNotfication = false
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
	SetVars = {}

	canvas = love.graphics.newCanvas(ScreenWidth, ScreenHeight)
	if love._console then
		if love._console == "3ds" or love._console == "wiiu" then
			canvasBottom = love.graphics.newCanvas(BottomScreenWidth, BottomScreenHeight)
		end
	end

	DrawNext()

end

if love.getVersion() >= 12 then
	function love.graphics.newText(font, text)
		return love.graphics.newTextBatch(font, text)
	end
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

function love.textinput(text)
	if AskForName and love.system.getOS() == "Horizon" then
		love.keyboard.setTextInput(false)
		AskForName = false
		Name = text
		Line = Line - 1
		DrawNext()
	end
end

function CheckKeyboard()
	if AskForName then
		if love._os ~= "horizon" then
			if love._console ~= "3ds" then --All of the 2/3DS models
				love.keyboard.setTextInput(True)
				--love.keyboard.setTextInput("basic", false, "Please enter your name:")
				--love.keyboard.setTextInput(true, {type = "basic", hint = "Please enter the mc's name:"}) --type = "basic", 
				AskForName = false
				Line=Line-1
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
			if ScriptContainer[Line] then
				if ScriptContainer[Line].question then
					QuestionAwnser = getBoxNumber(#ScriptContainer[Line].question/2, x, y, nil, ScreenWidth, ScreenHeight)
				end
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

function getBoxNumber(numSquares, x, y, screen, baseWidth1, baseHeight1)
	local baseWidth, baseHeight = baseWidth1, baseHeight1 or love.graphics.getDimensions(screen)
	baseHeight = baseHeight/2
    local cols = math.ceil(math.sqrt(numSquares))
    local rows = math.ceil(numSquares / cols)
    local cellWidth = baseWidth / cols
    local cellHeight = baseHeight / rows

    local col = math.floor(x / cellWidth)
    local row = math.floor(y / cellHeight)
    local boxNumber = row * cols + col + 1

    if boxNumber > numSquares then
        return nil -- Click outside the valid boxes
    end

    return boxNumber
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
				if ScriptContainer[Line] then
					if ScriptContainer[Line].question then
						if tonumber(key) then
							if tonumber(key) <= #ScriptContainer[Line].question/2 then
								QuestionAwnser = tonumber(key)
							end
						end
					end
				end
				if key == "return" then
					QuestionAwnser = 1
				end
				if key == "space" then
					QuestionAwnser = 2
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
			QuestionAwnser = 1
		end
		if button == "b" then
			QuestionAwnser = 2
		end
		if button == "x" then
			QuestionAwnser = 3
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
	RequireTouch = false
	UseX = 0
	UseY = 0

	if QuesitonNotfication then
		if QuestionAwnser ~= "" and QuestionAwnser ~= nil then
			Line = QuestionFindLine[QuestionAwnser]
			QuestionFindLine = {}
			QuesitonNotfication = false
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

	if Line <= 0 then
		Line = 1
	end

	ScriptText = ScriptContainer[Line].text

	if ScriptText == nil then
		ScriptText = " "
		--MusicThread:wait()
		--love.event.quit()
	end

	DrawImage()
	DrawCharacter()
	NewMusic()
	TouchList()

	if ScriptContainer[Line].name ~= nil or Line == 10 then
		if ScriptContainer[Line].name == "Name" or ScriptContainer[Line].name == "name" or ScriptContainer[Line].name == "MC" or ScriptContainer[Line].name == "MCi" or ScriptContainer[Line].name == true then
			Speaker = Name
		else
			Speaker = ScriptContainer[Line].name
		end
	else
		Speaker = ""
	end

	if ScriptContainer[Line].question ~= nil then
		for i = 1,#ScriptContainer[Line].question/2,1 do
			QuestionOptionText[i] = ScriptContainer[Line].question[i*2-1] 
			if tonumber(ScriptContainer[Line].question[i*2]) then
				QuestionFindLine[i] = tonumber(ScriptContainer[Line].question[i*2])
				QuesitonNotfication = true
			else
				for u = 1,#ScriptContainer,1 do
					if ScriptContainer[u].label then
						if ScriptContainer[u].label:find(ScriptContainer[Line].question[i*2]) then
							QuestionFindLine[i] = u
							QuesitonNotfication = true
						end
					end
				end
				if QuesitonNotfication == false then
					for u = 1,#ScriptContainer,1 do
						if ScriptContainer[u].text then
							if ScriptContainer[u].text:find(ScriptContainer[Line].question[i*2]) and i ~= Line then
								QuestionFindLine[i] = u
								QuesitonNotfication = true
							end
						end
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
				if ScriptContainer[i].label then
					if ScriptContainer[i].label:find(GotoText) then
						Line = i
						DrawNext()
						return
					end
				end
			end
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

	if ScriptContainer[Line].VarSet ~= nil then
        for i = 1,#ScriptContainer[Line].VarSet,1 do
            local varName = ScriptContainer[Line].VarSet[i][1]
            local varValue = ScriptContainer[Line].VarSet[i][2]
            SetVars[varName] = varValue
        end
    end

    if ScriptContainer[Line].VarCheck ~= nil then
        for u = 1,#ScriptContainer[Line].VarCheck,1 do
            local varName = ScriptContainer[Line].VarCheck[u][1]
            local varValue = ScriptContainer[Line].VarCheck[u][2]
            local gotoLineTrue = ScriptContainer[Line].VarCheck[u][3]
            local gotoLineFalse = ScriptContainer[Line].VarCheck[u][4]

            if SetVars[varName] == varValue then
                if tonumber(gotoLineTrue) then
                    Line = tonumber(gotoLineTrue)
                    DrawNext()
                    return
                else
                    for i = 1,#ScriptContainer,1 do
                        if ScriptContainer[i].label then
                            if ScriptContainer[i].label:find(gotoLineTrue) then
                                Line = i
                                DrawNext()
                                return
                            end
                        end
                    end
                    for i = 1,#ScriptContainer,1 do
                        if type(ScriptContainer[i].text) == "string" then
                            if ScriptContainer[i].text:find(gotoLineTrue) and i ~= Line then
                                Line = i
                                DrawNext()
                                return
                            end
                        end
                    end
                end
            else
                if tonumber(gotoLineFalse) then
                    Line = tonumber(gotoLineFalse)
                    DrawNext()
                    return
                else
                    for i = 1,#ScriptContainer,1 do
                        if ScriptContainer[i].label then
                            if ScriptContainer[i].label:find(gotoLineFalse) then
                                Line = i
                                DrawNext()
                                return
                            end
                        end
                    end
                    for i = 1,#ScriptContainer,1 do
                        if type(ScriptContainer[i].text) == "string" then
                            if ScriptContainer[i].text:find(gotoLineFalse) and i ~= Line then
                                Line = i
                                DrawNext()
                                return
                            end
                        end
                    end
                end
            end
        end
    end

	if ScriptText:find("123quit123") ~= nil then
		MusicThread:wait()
		love.event.quit()
	end
	if love._console then
		love.graphics.setCanvas(canvas)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.setBlendMode("alpha")
		DrawScreen("left")
		love.graphics.setCanvas(canvasBottom)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.setBlendMode("alpha")
		DrawScreen("bottom")
		love.graphics.setCanvas()
	else
		love.graphics.setCanvas(canvas)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.setBlendMode("alpha")
		DrawScreen()
		love.graphics.setCanvas()
	end

	if QuesitonNotfication == false then
		Line = Line + 1
	end

	QuestionAwnser = ""
end

function DrawImage()
	if ScriptContainer[Line].bg ~= 0 and ScriptContainer[Line].bg ~= nil and ScriptContainer[Line].bg ~= "" and love.filesystem.getInfo ~= nil then
		if love._console then
			if love._console == "3ds" then
				Image = love.graphics.newImage(ScriptContainer[Line].bg..".t3x")
			else
				Image = love.graphics.newImage(ScriptContainer[Line].bg)
			end
		else
			Image = love.graphics.newImage(ScriptContainer[Line].bg)
		end
	end
end

function DrawCharacter()
	if ScriptContainer[Line].char1 ~= 0 and ScriptContainer[Line].char1 ~= nil and ScriptContainer[Line].char1 ~= "" and love.filesystem.getInfo(ScriptContainer[Line].char1) ~= nil then
		if ScriptContainer[Line].char1 == "nothing" then
			Character = love.graphics.newTextBatch(font, "")
		else
			if love.system.getOS() == "Horizon" and love.filesystem.getInfo(ScriptContainer[Line].char1 .. ".t3x") ~= nil then
				if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the supported ds models
					Character = love.graphics.newImage(ScriptContainer[Line].char1..".t3x")
				else
					Character = love.graphics.newImage(ScriptContainer[Line].char1)
				end
			else
				Character = love.graphics.newImage(ScriptContainer[Line].char1)
			end
		end
	end

	if ScriptContainer[Line].char2 ~= 0 and ScriptContainer[Line].char2 ~= nil and ScriptContainer[Line].char2 ~= "" and love.filesystem.getInfo(ScriptContainer[Line].char2) ~= nil then
		if ScriptContainer[Line].char2 == "nothing" then
			SecondaryCharacter = love.graphics.newTextBatch(font, "")
		else
			if love.system.getOS() == "Horizon" and love.filesystem.getInfo(ScriptContainer[Line].char1 .. ".t3x") ~= nil then
				if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the supported ds models
					SecondaryCharacter = love.graphics.newImage(ScriptContainer[Line].char2..".t3x")
				else
					SecondaryCharacter = love.graphics.newImage(ScriptContainer[Line].char2)
				end
			else
				SecondaryCharacter = love.graphics.newImage(ScriptContainer[Line].char2)
			end
		end
	end
end

function TouchList()
		if ScriptContainer[Line].positions then
			TouchCalcTimes = 0; TouchStuffStart = 0; TouchText = ""; RepeatTimes = 0; RepeatRepeatTimes = 0; TouchCalcTimesUse = ""
			TouchScale(Line)
			for i = 1,#ScriptContainer[Line].positions,1 do
				TouchPositions[i] = ScriptContainer[Line].positions[i]
			end
			if #TouchPositions >= 5 then
				RequireTouch = true;
			end
		end
end

function TouchScale(line)
		XSize = tonumber(ScriptContainer[line].Xsize)
		YSize = tonumber(ScriptContainer[line].Ysize)

		--if XScale/Image:getWidth() == YScale/Image:getHeight() then
			TouchScaleNumber = XScale/Image:getWidth()
		--else
		--	TouchScaleNumber = 1
		--end
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


function drawGrid(numSquares, screen, baseWidth1, baseHeight1)
    local baseWidth, baseHeight = love.graphics.getDimensions(screen) or baseWidth1, baseHeight1
    local cols = math.ceil(math.sqrt(numSquares)) -- get number of squares with square root (DONT CHANGE)
    local rows = math.ceil(numSquares / cols)
    local cellWidth = baseWidth / cols
    local cellHeight = baseHeight / rows

    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local boxIndex = row * cols + col + 1
            if boxIndex <= numSquares then
                local x = col * cellWidth
                local y = row * cellHeight
                love.graphics.rectangle("line", x, y, cellWidth, cellHeight)
				love.graphics.setColor(love.math.random(),love.math.random(),love.math.random(), 0.5)
				love.graphics.rectangle("fill", x, y, cellWidth, cellHeight)

                local text = QuestionOptionText[boxIndex] or ""
				love.graphics.setColor(0, 0, 0, 1)
                love.graphics.printf(text, AnnounceFont, x, y + cellHeight / 2 - 10, cellWidth, "center")
            end
        end
    end
end




function GeneralDraw(Screen)
	love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
	love.graphics.draw(Character, 0, (ScreenHeight/3), 0, 0.75, 0.75)
	love.graphics.draw(SecondaryCharacter, ScreenWidth-(SecondaryCharacter:getDimensions()), (ScreenHeight/3), 0, 0.75, 0.75)
	love.graphics.draw(textbox, 0, ScreenHeight/1.4, 0, ScreenWidth/textbox:getWidth(), 2)
	if Screen ~= "bottom" then
		love.graphics.printf(Speaker, NameFont, 0, ScreenHeight/1.4, ScreenWidth, "center", 0, 1, 1)
		love.graphics.printf(ScriptText, font, 0, ScreenHeight/1.25, ScreenWidth, "center", 0, 1, 1)
	end
	if _debug == true then
		for i = 1,#QuestionFindLine,1 do
			love.graphics.printf(QuestionOptionText[i] .. " = " .. QuestionFindLine[i], NameFont, 0, ScreenHeight/1.6-i*50, ScreenWidth, "center", 0, 1, 1)
		end

		if DebugX ~= null and DebugY ~= null and DebugX ~= 0 and DebugY ~= 0 then
			love.graphics.printf(DebugX, NameFont, 0, ScreenHeight/1.4, ScreenWidth, "center", 0, 1, 1)
			love.graphics.printf(DebugY, NameFont, 0, ScreenHeight/1.5, ScreenWidth, "center", 0, 1, 1)
		end
	end

	if LoadingMusic then
		love.graphics.printf("Loading Song", font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
	if QuesitonNotfication then
		if MobileMode then
			love.graphics.setColor(0,0,0)
			drawGrid(#QuestionOptionText, Screen, ScreenWidth, ScreenHeight/2)
			love.graphics.setColor(1,1,1)
			if false then
			love.graphics.setColor(0.10,1.00,0.40, 0.25)
			love.graphics.polygon("fill", 0,0, ScreenWidth/2,0, ScreenWidth/2,ScreenHeight/2, 0,ScreenHeight/2)
			love.graphics.setColor(1.00,0.20,0.20, 0.25)
			love.graphics.polygon("fill", ScreenWidth,0, ScreenWidth/2,0, ScreenWidth/2,ScreenHeight/2, ScreenWidth,ScreenHeight/2)
			love.graphics.setColor(1,1,1)
			love.graphics.printf(QuestionOptionText[1], font, 0-ScreenWidth/4, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			love.graphics.printf(QuestionOptionText[2], font, ScreenWidth/4, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			end
		end
	end
end

function DrawScreen(Screen)
if AskForName ~= true then
	if love._os == "horizon" then 
		if love._console == "3ds" then --Any of the 2/3DS models
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
					GeneralDraw(Screen)
					if QuesitonNotfication == true and MobileMode == false then
						for i = 1,#QuestionFindLine,1 do
							love.graphics.printf(i .. " = " .. QuestionOptionText[i], font, 0, ScreenHeight/(5)+i*50, ScreenWidth, "center", 0, 1, 1)
						end
						--love.graphics.printf(#ScriptContainer[Line].question/2 .. " = " .. QuestionOptionText[1] .. "\nSpace = " .. QuestionOptionText[2], font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
					end
					--love.graphics.printf("A = " .. QuestionOptionText[1] .. "\nB = " .. QuestionOptionText[2], font, 0, 180, 320, "center", 0, 1, 1)
				end
			end
		else --switch
			GeneralDraw(Screen)
			if QuesitonNotfication == true and MobileMode == false then
				love.graphics.printf("A = " .. QuestionOptionText[1] .. "\nB = " .. QuestionOptionText[2], font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			end
		end
	else if screen ~= nil then --WiiU
			GeneralDraw(Screen)
			if QuesitonNotfication == true and MobileMode == false then
				love.graphics.printf("A = " .. QuestionOptionText[1] .. "\nB = " .. QuestionOptionText[2], font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			end
		end
		--pc, mobile or web
		GeneralDraw(Screen)
		if QuesitonNotfication == true and MobileMode == false then
			for i = 1,#QuestionFindLine,1 do
				love.graphics.printf(i .. " = " .. QuestionOptionText[i], font, 0, ScreenHeight/(5)+i*50, ScreenWidth, "center", 0, 1, 1)
			end
			--love.graphics.printf(#ScriptContainer[Line].question/2 .. " = " .. QuestionOptionText[1] .. "\nSpace = " .. QuestionOptionText[2], font, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
		end
	end
else -- still gotta add 3ds support (still gotta implement this in its entirity)
	if screen ~= "left" and screen ~= "right" then
		if love._os == "horizon" then
			if love._console ~= "3ds" then --None of the 2/3DS models
				love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
				love.graphics.draw(textbox, (ScreenWidth-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getHeight()))/6, 0, math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight()))
				love.graphics.printf("Before we start, please enter your name:", AnnounceFont, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
				love.graphics.printf(Name, NameFont, 0, ScreenHeight/3.5, ScreenWidth, "center", 0, 1, 1)
			else --2/3DS
				--AskForName = false
				--Line = Line - 1
				--DrawNext()
			end
		else
			love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
			love.graphics.draw(textbox, (ScreenWidth-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getHeight()))/6, 0, math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight()))
			love.graphics.printf("Before we start, please enter your name:", AnnounceFont, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			love.graphics.printf(Name, NameFont, 0, ScreenHeight/3.5, ScreenWidth, "center", 0, 1, 1)
		end
	end
end
end


function love.draw(screen)
if AskForName == true then
	if screen ~= "left" and screen ~= "right" then
		if love._os == "horizon" then
			if love._console ~= "3ds" then --None of the 2/3DS models
				love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
				love.graphics.draw(textbox, (ScreenWidth-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getHeight()))/6, 0, math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight()))
				love.graphics.printf("Before we start, please enter your name:", AnnounceFont, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
				love.graphics.printf(Name, NameFont, 0, ScreenHeight/3.5, ScreenWidth, "center", 0, 1, 1)
			else --2/3DS
				AskForName = false
				Line = Line - 1
				DrawNext()
			end
		else
			love.graphics.draw(Image, (ScreenWidth-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight())*Image:getHeight()))/2, 0, math.min(ScreenWidth/Image:getWidth(), ScreenHeight/Image:getHeight()))
			love.graphics.draw(textbox, (ScreenWidth-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getWidth()))/2, (ScreenHeight-(math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight())*textbox:getHeight()))/6, 0, math.min(ScreenWidth/textbox:getWidth(), ScreenHeight/textbox:getHeight()))
			love.graphics.printf("Before we start, please enter your name:", AnnounceFont, 0, ScreenHeight/4, ScreenWidth, "center", 0, 1, 1)
			love.graphics.printf(Name, NameFont, 0, ScreenHeight/3.5, ScreenWidth, "center", 0, 1, 1)
		end
	end
else
	if love._console then
		if love._console == "3ds" then
			if screen == "left" or screen == "right" then
				DrawScreen("left")
				--love.graphics.setBlendMode("alpha", "premultiplied")
				--love.graphics.setColor(1, 1, 1, 1)
				--love.graphics.draw(canvas, 0,0)
			elseif screen == "bottom" then
				--love.graphics.setBlendMode("alpha")
				DrawScreen("bottom")
				--love.graphics.draw(canvasBottom, 0,0)
			end
		else
			--love.graphics.setBlendMode("alpha", "premultiplied")
   			--love.graphics.setColor(1, 1, 1, 1)
    		--love.graphics.draw(canvas, 0,0)
			DrawScreen()
		end
	else
		love.graphics.setBlendMode("alpha", "premultiplied")
    	love.graphics.setColor(1, 1, 1, 1)
    	love.graphics.draw(canvas, 0,0)
	end
end	
end