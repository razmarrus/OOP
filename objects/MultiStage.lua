MultiStage = Object:extend()

function MultiStage:new()
    --self.depth = 30
    undieble = false
    TWO = true
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
    self.warr_score = 0
    self.mage_score = 0

    self.warr_player = self.area:addGameObject('WarrPlayer', gw/2+40, gh/2)
    self.mage_player = self.area:addGameObject('MagePlayer', gw/2-40, gh/2)
    --self.player = self.area:addGameObject('MagePlayer', gw/2-40, gh/2)
    --self.player = self.area:addGameObject('Player', gw/2-20, gh/2)
    self.back = self.area:addGameObject('Background', gw/2, gh/2)
    sound = love.audio.newSource("music/SOAD_Chop_Suey_8_bit.mp3")
    
    sound:play()
    self.director = Director(self)

    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.depth = 60


    function love.keypressed(key, u)
        --Debug
        if key == "escape" then 
            gotoRoom("Menu")
        elseif key =='1' then
            self.mage_player:setAttack("Neutral")
        elseif key =='2' then
            self.mage_player:setAttack("Double")
        elseif key =='3' then
            self.mage_player:setAttack("Triple")
        elseif key =='4' then
            self.mage_player:setAttack("Rapid")
        elseif key =='5' then
            self.mage_player:setAttack("Spread")
        elseif key =='6' then
            self.mage_player:setAttack("Back")
        elseif key =='7' then
            self.mage_player:setAttack("Side")
        elseif key =='l' then
            self.warr_player:specialSkill()
        end
    end


end

function MultiStage:update(dt)

    if self.mage_player.hp <= 0 and self.warr_player.hp <= 0 then
        self:finish()
    end
    self.area:update(dt)
    self.director:update(dt)


    if self.score_to_skill_points > 10000 then
        self.score_to_skill_points = 0
        skill_points = skill_points + 1
        self.player.score_unchange_current = 0
    end

end

function MultiStage:destroy()
    self.area:destroy()
    self.area = nil
    CAT = false 
    sound:stop()
    if BEST_SCORE < self.score then
        BEST_SCORE = self.score 
    end
    save()
end

function MultiStage:draw()
    
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        --love.graphics.circle('line', gw/2, gh/2, 50)
        self.area:draw()

    love.graphics.setFont(self.font)

    local r, g, b = unpack(colors.mpurple)
    local hp, max_hp = self.mage_player.hp, self.mage_player.max_hp
    --love.graphics.setColor(colors.purple)
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', gw/2 - 152, gh - 16, 48*(hp/max_hp), 4)
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2 - 152, gh - 16, 48, 4)

    --love.graphics.setCanvas()
    
    --love.graphics.setCanvas(self.main_canvas)
    love.graphics.print(hp .. '/' .. max_hp, gw/2 - 130 , gh - 25, 0, 1, 1, -- max_hp, gw/2 + 180 , gh + 220, 0, 2, 2,
    math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2),
    math.floor(self.font:getHeight()/2))
    love.graphics.setCanvas()

    local r, g, b = unpack(colors.mpurple)
    local boost, max_boost = self.mage_player.boost_stat, self.mage_player.max_boost
    love.graphics.setColor(r, g, b)
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.rectangle('fill', 10  , gh/2 - 20, 12, 90*boost/max_boost)--(boost/max_boost))
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', 10 , gh/2 - 20, 12, 90)
    love.graphics.setCanvas()

    local r, g, b = unpack(colors.darkorange)
    local boost, max_boost = self.warr_player.boost_stat, self.warr_player.max_boost
    love.graphics.setColor(r, g, b)
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.rectangle('fill', gw/2 + 200 , gh/2 - 20, 12, 90*boost/max_boost)--(boost/max_boost))
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2 + 200, gh/2 - 20, 12, 90)
    love.graphics.setCanvas()

    local r, g, b = unpack(colors.hp_color)
    local hp, max_hp = self.warr_player.hp, self.warr_player.max_hp
    love.graphics.setColor(r, g, b)
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.rectangle('fill', gw/2+40, gh - 16, 48*(hp/max_hp), 4)
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2+40, gh-16, 48, 4)
    love.graphics.setCanvas()

    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print('Warrior', gw/2 + 120, gh - 16, 0, 1, 1, -- gw/2 + 400, gh + 240, 0, 2, 2,
    math.floor(self.font:getWidth('Warrior')/2), math.floor(self.font:getHeight()/2))
    love.graphics.setCanvas()


    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print(hp .. '/' .. max_hp, gw/2 + 65 , gh - 25, 0, 1, 1, --gw/2 + 315 , gh + 220, 0, 2, 2,
    math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2),
    math.floor(self.font:getHeight()/2))
    love.graphics.setCanvas() 

    --if self.player.hero == 'Mage' then
        love.graphics.setCanvas(self.main_canvas)
        local r, g, b = unpack(colors.mana_color)
        local mana, max_mana = self.mage_player.mana, self.mage_player.max_mana
        local difficulty = self.director.difficulty
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw/2 - 80, gh - 16, 48*(mana/max_mana), 4)
        love.graphics.setColor(r - 32, g - 32, b - 32)
        love.graphics.rectangle('line', gw/2 -80, gh-16, 48, 4)
        love.graphics.setCanvas()
    
        love.graphics.setCanvas(self.main_canvas)
        love.graphics.print('Mage', gw/2 - 155, gh - 16, 0, 1, 1,
        math.floor(self.font:getWidth('Mage')/0.8), math.floor(self.font:getHeight()/2))
        love.graphics.setCanvas()


        love.graphics.setCanvas(self.main_canvas)
        love.graphics.print(mana .. '/' .. max_mana, gw/2 -60 , gh - 25, 0, 1, 1, --gw/2 + 315 , gh + 220, 0, 2, 2,
        math.floor(self.font:getWidth(mana .. '/' .. max_mana)/2),
        math.floor(self.font:getHeight()/2))
        love.graphics.setCanvas() 
    --end
    --love.graphics.setCanvas()

    --BOOST
    
        --


    love.graphics.setColor(colors.mana_color)
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print('LEVEL', gw/2 , 35, 0, 1, 1,
    math.floor(self.font:getWidth('LEVEL')), math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

    
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print( difficulty, gw/2 + 50 , 35, 0, 1, 1,
    math.floor(self.font:getWidth(difficulty)),
    math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print('SCORE', gw/2 , 45, 0, 1, 1,
    math.floor(self.font:getWidth('SCORE')), math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

    
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.print( self.score, gw/2 + 50, 45, 0, 1, 1,
    math.floor(self.font:getWidth(self.score)),
    math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

        
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.setColor(colors.mana_color)
    love.graphics.print( self.mage_score, 40 , 45, 0, 1, 1,
    math.floor(self.font:getWidth(self.mage_score)),
    math.floor(self.font:getHeight()))
    love.graphics.setCanvas()

    
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.setColor(colors.hp_color)
    love.graphics.print( self.warr_score, gw - 40 , 45, 0, 1, 1,
    math.floor(self.font:getWidth(self.warr_score)),
    math.floor(self.font:getHeight()))
    love.graphics.setCanvas()




    --love.graphics.setColor(255, 255, 255)
    --love.graphics.setCanvas()
    

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha') 
    
end

function MultiStage:finish()
    CAT = false 
    timer:after(1, function()
        gotoRoom('MultiStage')
    end)
end

function MultiStage:addScore(pt)
    self.score = self.score + pt
    self.score_to_skill_points = self.score_to_skill_points + pt
    --self.player_mage.score_unchange_current = 0
end

function MultiStage:addScoreMage(pt)
    self.mage_score = self.mage_score + pt
    --self.score_to_skill_points = self.score_to_skill_points + pt
    --self.player_mage.score_unchange_current = 0
end

function MultiStage:addScoreWarr(pt)
    self.warr_score = self.warr_score + pt
    --self.score_to_skill_points = self.score_to_skill_points + pt
    --self.player_mage.score_unchange_current = 0
end


