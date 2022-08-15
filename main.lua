require "sprites.t3x"
function love.load()

	rooms = {
		green	= { desc = "You are in a Green room", options = {"red", "An exit to a Red room", "blue", "An exit to a Blue Room" }},
		red		= { desc = "You are in a Red room", options = {"blue", "An exit to a Blue room", "green", "An exit to a Green Room"}},
		blue	= { desc = "You are in a Blue room", options = {"red", "An exit to a Red room", "green", "An exit to a Green Room","yellow","An exit to an Yellow Room" }},
		yellow	= { desc = "You are in an Yellow room", options = {"blue", "An exit to a Blue Room" }}
}

room = "red"

end

function love.update()

end

function love.touchpressed(a, b, c, d, e, f)
	love.keyboard.setTextInput( enable )
end


function love.gamepadpressed(joystick, button)
	if button == "a" then
		love.keyboard.setTextInput( enable )
	end
	if button == "b" then
		new image = love.graphics.newImage("sprites.t3x")
	end
end

function love.textinput(key)
	for z=1,(#rooms[room].options)/2 do
		if key == tostring(z) then
			room = rooms[room].options[(z*2)-1]
		end	
	end
end
	
function love.draw()

	love.graphics.draw(image, 0, 0);
		love.graphics.print(rooms[room].desc..". You can go to:",0,20) 
		for i=1, (#rooms[room].options)/2 do
			love.graphics.print(i.." - "..rooms[room].options[i*2],0,20+i*20) 
		end

end
