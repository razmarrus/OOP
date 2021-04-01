------------------------------------------------------------------------------
-- LIBRARIES
--dbg         = require 'libraries/mobdebug/mobdebug'
Timer       = require 'libraries/hump/timer'
Input       = require 'libraries/input/Input'
Object      = require 'libraries/classic/classic'

Camera      = require 'libraries/hump/camera'
Vector      = require 'libraries/hump/vector'
Physics     = require 'libraries/windfield'
Draft       = require 'libraries/draft/draft'
fn          = require 'libraries/moses/moses'
lume        = require 'libraries/lume/lume'
Button      = require 'libraries/button/Button'
Event       = require 'libraries/button/Events'
bitser      = require 'libraries/bitser/bitser'
require 'libraries/utf8/utf8'
--require 'libraries/lovedebug/lovedebug'

------------------------------------------------------------------------------
-- GAME LIBRARIES
CooldownTimer   = require 'libraries/game/CooldownTimer'
GameObject      = require 'libraries/game/GameObject'
Stats           = require 'libraries/game/Stats'
gameui          = require 'libraries/game/UI'
utils           = require 'libraries/game/utils'
colors          = require 'libraries/game/colors'

--gameui          = require 'libraries/game/UI'

------------------------------------------------------------------------------
-- GLOBALS
require 'libraries/game/globals'

------------------------------------------------------------------------------
-- FUNCTIONS

function love.load()

    -- this only works if initialized here . :??
    input = Input()
    load()
    input:bind("left", "left")
    input:bind("right", "right")
    input:bind('c', function() camera:shake(4, 60, 1) end)
   -- input:bind("up", "up")
   -- input:bind("down", "down")

    input:bind("f7", function()
        print("------------------------------------------------------------")
        print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = utils.type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("------------------------------------------------------------")
    end)
    _G.events = Event(false)

    love.graphics.setDefaultFilter("nearest")
    love.graphics.setLineStyle("rough")
    resize(2)
    --gotoRoom("Stage")
    --gotoRoom("MultiStage")
    --gotoRoom("SkillTree")
    gotoRoom("Menu")
    --gotoRoom("DioStage")
    --gotoRoom("DialogStage")
end


function love.update(dt)
    -- require("libraries/lovebird/lovebird").update()

    withCurrentTime(dt, function(t)
        --lurker.update()
        timer:update(t)
        camera:update(t)
    end)

    withCurrentRoom(function(room)
        room:update(dt)
    end)
end

function love.draw()
    withCurrentRoom(function(room)
        room:draw(dt)
    end)

    if current_room then
        current_room:draw()
    end
--[[
    if flash_frames then 
        flash_frames = flash_frames - 1
        if flash_frames == -1 then flash_frames = nil end
    end
    if flash_frames then
        love.graphics.setColor(background_color)
        love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
        love.graphics.setColor(255, 255, 255)
    end
--[[
    untilCounterZero("flash_frames", function()
        love.graphics.setColor(colors.background_color)
        love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
        love.graphics.setColor(255, 255, 255)
    end)
    ]]--
end



