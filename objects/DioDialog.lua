Dialog = Object:extend()
--[[
function Dialog:new()
    --self.area = Area(self)
    --Menu.super.new(self)
    self.timer = Timer()
    self.font = GAME_FONT
    --self.lines = {}
    self.line_y =  gh - 72
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    sound = love.audio.newSource("music/JoJoStand_Proud.mp3")
    sound:play()
    --HERO = 'Mage'
    --DIFFICULTY = 1
    log_screen_image = love.graphics.newImage("images/dio_background.png")
    button_play = Button(gw , gh 220, 200, 35, "Next")
    _G.events:hook("onBtnClick", on_click_play)
end

function on_click_play(button)
    if button == button_play then
        gotoRoom("Stage")
    elseif button == button_SkillTree then
        gotoRoom("SkillTree")
    elseif  button == button_Exit then
        love.event.quit()
    end
end


function Dialog:draw()

    love.graphics.draw(log_screen_image, gw/2 - log_screen_image:getWidth()/4,
    gh/2 - log_screen_image:getHeight()/4) 
        drawn = true
        
    button_play:draw()
    button_SkillTree:draw()
    button_Exit:draw()
end

function Dialog:update(dt)
    button_play:update(dt)
    button_SkillTree:update(dt)
    button_Exit:update(dt)
    --self.area:update(dt)
end

function Dialog:addLine(delay, text)
    --self.timer:after(delay, function() 
    	table.insert(self.lines, {x = gw - 10, y = self.line_y, 
        text = love.graphics.newText(self.font, text)}) 
      	self.line_y = self.line_y + 60
   -- end)
end

function Dialog:destroy()
    _G.events:unhook("onBtnClick", on_click_play)
    sound:stop()
end
]]--