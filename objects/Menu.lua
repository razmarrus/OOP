
Menu = Object:extend()

function Menu:new()
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
    button_dio =  Button(gw , gh - 200, 200, 35, "To dio")
    button_play = Button(gw - 110 , gh -120, 200, 35, "Play")
    button_two =  Button(gw + 110 , gh -120, 200, 35, "Play in two")
    button_SkillTree = Button(gw , gh - 60, 200, 35, "Skill Tree")
    button_Exit = Button(gw , gh, 200, 35, "Exit")
    _G.events:hook("onBtnClick", on_click_play)
end

function on_click_play(button)
    if button == button_play then
        if first_run then
            gotoRoom("DialogStage")
        else
            gotoRoom("Stage")
        end
    elseif button == button_SkillTree then
        gotoRoom("SkillTree")
    elseif button == button_two then
        gotoRoom("MultiStage")
    elseif button == button_dio then
        gotoRoom("DioStage")
    elseif  button == button_Exit then
        love.event.quit()
    end
end


function Menu:draw()

    love.graphics.draw(log_screen_image, gw/2 - log_screen_image:getWidth()/4,
    gh/2 - log_screen_image:getHeight()/4) 
        drawn = true
        
    button_play:draw()
    button_two:draw()
    button_SkillTree:draw()
    button_Exit:draw()
    button_dio:draw()
end

function Menu:update(dt)
    button_two:update(dt)
    button_play:update(dt)
    button_SkillTree:update(dt)
    button_Exit:update(dt)
    button_dio:update(dt)
    --self.area:update(dt)
end

function Menu:addLine(delay, text)
    --self.timer:after(delay, function() 
    	table.insert(self.lines, {x = gw - 10, y = self.line_y, 
        text = love.graphics.newText(self.font, text)}) 
      	self.line_y = self.line_y + 60
   -- end)
end

function Menu:destroy()
    _G.events:unhook("onBtnClick", on_click_play)
    sound:stop()
end