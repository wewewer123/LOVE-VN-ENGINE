MusicThread = [[
    local music = ...

    love = require("love")
    audio = require("love.audio")
    sound = require("love.sound")
    love.thread.getChannel( 'music' ):push( 1 )
    local Source = love.audio.newSource(music, "stream")
    love.thread.getChannel( 'music' ):push( Source )
]]

return MusicThread