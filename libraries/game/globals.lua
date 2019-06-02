--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 27.02.18
-- Time: 21:01
-- To change this template use File | Settings | File Templates.
--
FROZEN = false
HERO = 'Mage'
HP = 80
default_color = {222, 222, 222}
background_color = {16, 16, 16}
ammo_color = {123, 200, 164}
boost_color = {76, 195, 217}
hp_color = {241, 103, 69}
skill_point_color = {255, 198, 93}

camera = Camera()
draft = Draft()
timer = Timer()


-- no buffering for stdout please
io.stdout:setvbuf("no")
camera.smoother = Camera.smooth.damped(5)
skill_points = 2
BEST_SCORE = 0
CAT = false
TWO = false

FONT_SIZE = 18

do
    local object_files = {}
    utils.recursiveEnumerate('objects', object_files)
    utils.requireFiles(object_files)
    fonts = utils.loadFonts()
end


GAME_FONT = fonts.SYDNIE_STANDARD

------------------------------------------------------------------------------
-- Game State
state = require "libraries/game/state"


------------------------------------------------------------------------------
-- FUNCTIONS
function save()
    local save_data = {}
    -- Set all save data here
    save_data.skill_points = skill_points
    save_data.bought_node_indexes = bought_node_indexes
    save_data.best_score = BEST_SCORE
    bitser.dumpLoveFile('save', save_data)
end

function load()
    if love.filesystem.exists('save') then
        local save_data = bitser.loadLoveFile('save')
        skill_points = save_data.skill_points
        bought_node_indexes = save_data.bought_node_indexes 
        BEST_SCORE = save_data.best_score 
	-- Load all saved data here
    else
        first_run_ever = true
    end
end


function resize(s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
end

function flash(frames)
    state.flash_frames = frames
end

function slow(amount, duration)
    state.slow_amount = amount
    timer:tween(duration, state, {slow_amount = 1}, 'in-out-cubic')
end

function getCurrentRoom()
    return state.current_room
end

function gotoRoom(room_type, ...)
    local current_room = state.current_room
    if current_room and current_room.destroy then current_room:destroy() end

    state.current_room = _G[room_type](...)
end

function withCurrentTime(dt, f, ...)
    local t = state.slow_amount * dt
    return f(t, ...)
end

function withCurrentRoom(f, ...)
    if state.current_room then
        return f(state.current_room, ...)
    end
end

function withState(key, f, ...)
    local s = state[key]
    if s then
        return f(s, ...)
    end
end

function withAttacks(f, ...)
    return f(state.attacks, ...)
end

function withAttack(a, f, ...)
    local attack = state.attacks[a]
    if attack then
        return f(attack, ...)
    end
end

function withPlayer(f, ...)
    return withCurrentRoom(function(room, ...)
        if room.player then
            return f(room.player, ...)
        end
    end)
end

function untilCounterZero(name, f, ...)
    local counter = state[name]
    local flag = true
    if counter then
        counter = counter - 1
        if counter <= 0 then
            flag = false
            counter = nil
        end
        state[name] = counter
        if flag then
            return f(counter, ...)
        end
    end
end

function pushRotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x, -y)
end

function pushRotateScale(x, y, r, sx, sy)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1, sy or sx or 1)
    love.graphics.translate(-x, -y)
end


