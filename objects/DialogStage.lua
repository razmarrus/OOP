DialogStage = Object:extend()

function DialogStage:new()
    --self.depth = 30
    TWO = false
    undieble = false
    DIO = false

    --self.back = self.area:addGameObject('Background', gw/2, gh/2)
    if dio_killed then
        sound = love.audio.newSource("music/tobe.mp3")
        dio_im = love.graphics.newImage("images/photo_die.png")
    else
        sound = love.audio.newSource("music/SOAD_Chop_Suey_8_bit.mp3")
        dio_im = love.graphics.newImage("images/photo.png")
    end
    self.font = GAME_FONT
    sound:play()
    self.director = Director(self)

    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.depth = 60
    scene = love.graphics.newImage("images/village.png")
    first_run = false

    function love.keypressed(key, u)
        --Debug
        if key == "space" and dio_killed == false then --set to whatever key you want to use
            --debug.debug()
            gotoRoom("Stage")
        elseif key == "m" then --set to whatever key you want to use
            gotoRoom("Menu")
        end
    end

    --self.greet_text = "I greet you, my drear hero.\nMy name is Jognar Jobrock. Few mounth ago vampire named Dio has appeared here.\n
    --I hadn't cared about him much, but then..then he killed my best friend - mage Jori Jodinni!\nI'll get my revange!\n
    --    But first, we need to kill enought dio's mimions to to him. Hepl me with it! Press <- and -> right to move"
end

function DialogStage:update(dt)


end

function DialogStage:destroy()
    --DIO = false
    --sound:st
    sound:stop()
end

function DialogStage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    love.graphics.setCanvas()
    love.graphics.setFont(self.font)
    love.graphics.draw(scene, gw/2 - scene:getWidth()/2 + 240,
    gh/2 - scene:getHeight()/2 + 135) 
       drawn = true

       love.graphics.setCanvas()
       love.graphics.setColor(105, 105, 105)
       --love.graphics.rectangle('fill', 50, 50, 700, 420)
       love.graphics.setCanvas(self.main_canvas)
       love.graphics.setColor(colors.hp_color)
       
       if dio_killed then 
            love.graphics.print('So, Dio was killed, but his servants are stil alive\n\nNew hero appeared in city - he said\nhis name is Jojo.\nTry him in main stage', gw/2-50, gh/2-100, 0, 1, 1, -- gw/2 + 400, gh + 240, 0, 2, 2,
            math.floor(self.font:getWidth('So, Dio was killed, but his servants are stil alive\n\nNew hero appeared in city - he said\nhis name is Jojo.\nTry him in main stage')/2), math.floor(self.font:getHeight()/2))
       else
            love.graphics.print('I greet you, my drear hero.\nMy name is Jognar Jobrock. \nFew mounth ago vampire named Dio has appeared here.\n We must kill enought Dio\'s minions to summon him.\n Hepl me with it!\n\n Press <- and -> right to move\npress X to change hero.\nPress S while being warrior to use your shield.\nPress 1 (or 2, 3 etc.) to change projectile style\n while controlling mage', gw/2-50, gh/2-100, 0, 1, 1, -- gw/2 + 400, gh + 240, 0, 2, 2,
            math.floor(self.font:getWidth('I greet you, my drear hero.\nMy name is Jognar Jobrock. \nFew mounth ago vampire named Dio has appeared here.\n We need to kill enought dios mimions to sum him.\n Hepl me with it!\n\n Press <- and -> right to move\npress X to shange hero')/2), math.floor(self.font:getHeight()/2))
       end
       love.graphics.setCanvas()

       love.graphics.setCanvas(self.main_canvas)
       love.graphics.setColor(colors.orange)
       love.graphics.print('Press space to continue', gw/2 - 20, gh/2+ 60, 0, 1, 1, -- gw/2 + 400, gh + 240, 0, 2, 2,
       math.floor(self.font:getWidth('Press space to continue')/2), math.floor(self.font:getHeight()/2))
       love.graphics.setCanvas()


       love.graphics.setColor(255, 255, 255, 255)
       love.graphics.draw(dio_im, gw/2 - dio_im:getWidth()/2 + 540,
       gh/2 - dio_im:getHeight()/2 + 135) 
       love.graphics.setCanvas()

       love.graphics.setColor(255, 255, 255, 255)
       love.graphics.setBlendMode('alpha', 'premultiplied')
       love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
       love.graphics.setBlendMode('alpha') 

end

function DialogStage:finish()
    timer:after(1, function()
        gotoRoom('Stage')
    end)
end

