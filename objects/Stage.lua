Stage = Object:extend()

function Stage:new()
    --self.depth = 30
    TWO = false
    undieble = false
    DIO = false
    self.score = 0
    self.score_to_skill_points = 0

    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.timer = Timer()
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile','Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})
    self.font = GAME_FONT
    
    self.cat_sound_activated = false
    self.cat_sound_was_activated = false
    self.cat_sound_was_unactivated = true

    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    self.back = self.area:addGameObject('Background', gw/2, gh/2)
    sound = love.audio.newSource("music/SOAD_Chop_Suey_8_bit.mp3")
    
    sound:play()
    self.director = Director(self)

    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.depth = 60
    input:bind('q', function() 
        self.area:addGameObject('Shooter', utils.random(0, gw), utils.random(0, gh)) 
    end)  


    function love.keypressed(key, u)
        --Debug
        if key == "w" then --set to whatever key you want to use
           debug.debug()
        elseif key == "escape" then 
            gotoRoom("Menu")
        elseif key == 'x' or key == "Tab" then
            print("Change")
            if HERO == 'Mage' or HERO == 'Jojo' then
                HERO = 'Warrior'
            elseif HERO == 'Warrior' then
                HERO = 'Mage'
            end
            gotoRoom("Stage")
        elseif key =='1' then
            self.player:setAttack("Neutral")
        elseif key =='2' then
            self.player:setAttack("Double")
        elseif key =='3' then
            self.player:setAttack("Triple")
        elseif key =='4' then
            self.player:setAttack("Rapid")
        elseif key =='5' then
            self.player:setAttack("Spread")
        elseif key =='s' then
            self.player:specialSkill()
        elseif key =='6' then
            self.player:setAttack("Back")
        elseif key =='7' then
            self.player:setAttack("Side")
        elseif key =='j' then
            HERO = 'Jojo'
            gotoRoom("Stage")
        end
    end


end

function Stage:update(dt)
    self.area:update(dt)
    self.director:update(dt)
    if self.player.cat_flag and (not self.cat_sound_activated) then
        sound:stop()
        sound = love.audio.newSource("music/Nyan_Cat.mp3")
        sound:play()
        self.cat_sound_activated = true
        self.cat_sound_was_activated = true
        self.cat_sound_was_unactivated = false
    end

    if (not self.player.cat_flag and self.cat_sound_was_activated) and (not self.cat_sound_was_unactivated) then      
        self.cat_sound_was_activated = false
        self.cat_sonnd_was_unactivated = true
        self.cat_sound_activated = false

        sound:stop()
        sound = love.audio.newSource("music/SOAD_Chop_Suey_8_bit.mp3")
        sound:play()
    end

    if self.score_to_skill_points > 10000 then
        self.score_to_skill_points = 0
        skill_points = skill_points + 1
        self.player.score_unchange_current = 0
    end

end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
    CAT = false 
    sound:stop()
    if BEST_SCORE < self.score then
        BEST_SCORE = self.score 
    end
    save()
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        --love.graphics.circle('line', gw/2, gh/2, 50)
        self.area:draw()

    love.graphics.setFont(self.font)


    local r, g, b = unpack(colors.hp_color)
    local hp, max_hp = self.player.hp, self.player.max_hp
    
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', gw/2 - 52, gh - 16, 48*(hp/max_hp), 4)
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2 - 52, gh - 16, 48, 4)

    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print('HP', gw/2 - 55, gh - 16, 0, 1, 1,
    math.floor(self.font:getWidth('HP')/0.8), math.floor(self.font:getHeight()/2))
    --love.graphics.setCanvas()
    
    --love.graphics.setCanvas(self.main_canvas)
    love.graphics.print(hp .. '/' .. max_hp, gw/2 -29 , gh - 25, 0, 1, 1, -- max_hp, gw/2 + 180 , gh + 220, 0, 2, 2,
    math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2),
    math.floor(self.font:getHeight()/2))
    love.graphics.setCanvas()

    local r, g, b = unpack(colors.darkorange)
    local boost, max_boost = self.player.boost_stat, self.player.max_boost
    love.graphics.setColor(r, g, b)
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.rectangle('fill', gw/2 + 200 , gh/2 - 20, 12, 90*boost/max_boost)--(boost/max_boost))
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2 + 200, gh/2 - 20, 12, 90)
    love.graphics.setCanvas()

    --if self.player.hero == 'Mage' then
    if self.player.hero == 'Mage'  then
        love.graphics.setCanvas(self.main_canvas)
        local r, g, b = unpack(colors.mana_color)
        local mana, max_mana = self.player.mana, self.player.max_mana

        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw/2+10, gh - 16, 48*(mana/max_mana), 4)
        love.graphics.setColor(r - 32, g - 32, b - 32)
        love.graphics.rectangle('line', gw/2+10, gh-16, 48, 4)
        love.graphics.setCanvas()
    
        love.graphics.setCanvas(self.main_canvas)
        love.graphics.print('MANA', gw/2 + 80, gh - 16, 0, 1, 1, -- gw/2 + 400, gh + 240, 0, 2, 2,
        math.floor(self.font:getWidth('MANA')/2), math.floor(self.font:getHeight()/2))
        love.graphics.setCanvas()


        love.graphics.setCanvas(self.main_canvas)
        love.graphics.print(mana .. '/' .. max_mana, gw/2 + 35 , gh - 25, 0, 1, 1, --gw/2 + 315 , gh + 220, 0, 2, 2,
        math.floor(self.font:getWidth(mana .. '/' .. max_mana)/2),
        math.floor(self.font:getHeight()/2))
        love.graphics.setCanvas() 
    end
    --end
    --love.graphics.setCanvas()

    --BOOST
    
        --


    love.graphics.setColor(colors.mana_color)
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print('LEVEL', gw - 60 , 35, 0, 1, 1,
    math.floor(self.font:getWidth('LEVEL')), math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

    local difficulty = self.director.difficulty
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print( difficulty, gw - 25 , 35, 0, 1, 1,
    math.floor(self.font:getWidth(difficulty)),
    math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print('SCORE', gw - 60 , 45, 0, 1, 1,
    math.floor(self.font:getWidth('SCORE')), math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

    
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print( self.score, gw - 25 , 45, 0, 1, 1,
    math.floor(self.font:getWidth(self.score)),
    math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

    love.graphics.setColor(colors.yellow)
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print('BEST SCORE', 100 , 35, 0, 1, 1,
    math.floor(self.font:getWidth('BEST SCORE')), math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print( BEST_SCORE, 100 , 48, 0, 1, 1,
    math.floor(self.font:getWidth(BEST_SCORE)),
    math.floor(self.font:getHeight()))
    love.graphics.setCanvas()


    --love.graphics.setColor(255, 255, 255)
    --love.graphics.setCanvas()


    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha') 
    
end

function Stage:finish()
    CAT = false 
    timer:after(1, function()
        gotoRoom('Stage')
    end)
end

function Stage:addScore(pt)
    self.score = self.score + pt
    self.score_to_skill_points = self.score_to_skill_points + pt
    self.player.score_unchange_current = 0
end
