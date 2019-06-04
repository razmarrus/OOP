DioStage = Object:extend()

function DioStage:new()
    --self.depth = 30
    TWO = false
    undieble = false
    DIO = true
    RR = false
    self.score = 0
    self.score_to_skill_points = 0
    print("here")

    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.timer = Timer()
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile','Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})
    self.font = GAME_FONT
    self.dio_die = false
    
    self.cat_sound_activated = false
    self.cat_sound_was_activated = false
    self.cat_sound_was_unactivated = true
    HERO = "Warrior"
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    --self.dio = self.area:addGameObject('Dio', utils.random(0, gw), utils.random(0, gh))
    if DIO then
        self.dio = self.area:addGameObject('Dio', utils.random(0, gw), utils.random(0, gh))
    end
    self.ora_counter = 0
    self.ora_target = 20
    self.ora_time = 6

    self.back = self.area:addGameObject('Background', gw/2, gh/2)
    sound_m = love.audio.newSource("music/dio.mp3")
    
    sound_m:play()
    self.director = Director(self)

    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.depth = 60

    function love.keypressed(key, u)
        --Debug
        if key == "escape" then 
            gotoRoom("Menu")
        elseif key =='s' then
            self.player:specialSkill()
        elseif key == "space" then --set to whatever key you want to use
            self.ora_counter = self.ora_counter + 1
        end

    end
end

function DioStage:update(dt)
    self.area:update(dt)

    if self.ora_counter > self.ora_target then
        self.ora_counter = self.ora_target
    end
    --self.director:update(dt)
    if self.player.cat_flag and (not self.cat_sound_activated) then
        --sound:stop()
        --sound = love.audio.newSource("music/Nyan_Cat.mp3")
        --sound:play()
        self.cat_sound_activated = true
        self.cat_sound_was_activated = true
        self.cat_sound_was_unactivated = false
    end

    if (not self.player.cat_flag and self.cat_sound_was_activated) and (not self.cat_sound_was_unactivated) then      
        self.cat_sound_was_activated = false
        self.cat_sonnd_was_unactivated = true
        self.cat_sound_activated = false

        --sound:stop()
        --sound = love.audio.newSource("music/SOAD_Chop_Suey_8_bit.mp3")
        --sound:play()
    end

    --[[if self.dio.roda_rolla_spawn then
        self.plyer_x = gw/2
        self.player_y = gh/2
        self.player.collider:setPosition(self.x, self.y)
    end
    ]]--

    if self.score_to_skill_points > 10000 then
        self.score_to_skill_points = 0
        skill_points = skill_points + 1
        self.player.score_unchange_current = 0
    end

    if self.ora_counter >= self.ora_target then
        self.dio:die()
        self.dio_die = true
        dio_killed = true
        --timer:after(3, function()
            gotoRoom('DialogStage')
        --end)
        
    end
end

function DioStage:destroy()
    self.area:destroy()
    self.area = nil
    CAT = false 
    sound_m:stop()
    --sound:stop()
    FROZEN = false
    RR = false
    if BEST_SCORE < self.score then
        BEST_SCORE = self.score 
    end
    --save()
end

function DioStage:draw()
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

        --DIO HP
    if self.dio_die == false then
        love.graphics.setCanvas(self.main_canvas)
        local hp, max_hp = self.dio.hp, self.dio.max_hp
        
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw/2 - 152, 35, 300*(hp/max_hp), 7)
        love.graphics.setColor(r - 32, g - 32, b - 32)
        love.graphics.rectangle('line', gw/2 - 152, 35, 300, 7)

        love.graphics.print(hp .. '/' .. max_hp, gw/2 -15 , 55, 0, 1, 1, -- max_hp, gw/2 + 180 , gh + 220, 0, 2, 2,
        math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2),
        math.floor(self.font:getHeight()/2))
        love.graphics.setCanvas()
    end



    local r, g, b = unpack(colors.darkorange)
    local boost, max_boost = self.player.boost_stat, self.player.max_boost
    love.graphics.setColor(r, g, b)
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.rectangle('fill', gw/2 + 200 , gh/2 - 20, 12, 90*boost/max_boost)--(boost/max_boost))
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2 + 200, gh/2 - 20, 12, 90)
    love.graphics.setCanvas()

    --if self.player.hero == 'Mage' then
        love.graphics.setCanvas(self.main_canvas)
        local r, g, b = unpack(colors.mana_color)
        local mana, max_mana = self.player.mana, self.player.max_mana
        --local difficulty = self.director.difficulty
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
    --end
    --love.graphics.setCanvas()
    if self.dio_die == false then
        if self.dio.roda_rolla_spawn then
            sound_m:stop()
            love.graphics.setCanvas(self.main_canvas)
            local r, g, b = unpack(colors.yellow)
            love.graphics.setColor(r, g, b)

            love.graphics.print('press SPACE to ORAORAORA', gw/2 + 10, gh - 70, 0, 1, 1, -- gw/2 + 400, gh + 240, 0, 2, 2,
            math.floor(self.font:getWidth('press SPACE to ORAORAORA')/2), math.floor(self.font:getHeight()/2))

            local mana, max_mana = self.ora_counter, self.ora_target
            --local difficulty = self.director.difficulty

            love.graphics.rectangle('fill', gw/2- 130, gh - 50, 250*(mana/max_mana), 4)
            love.graphics.setColor(r - 32, g - 32, b - 32)
            love.graphics.rectangle('line', gw/2 -130, gh-50, 250, 4)
            love.graphics.setCanvas()
        end
    end


    if self.dio_die then
        love.graphics.setCanvas(self.main_canvas)
        local r, g, b = unpack(colors.yellow)
        love.graphics.setColor(r, g, b)
        love.graphics.print('WIN', gw/2 , gh/2 , 0, 2, 2, -- gw/2 + 400, gh + 240, 0, 2, 2,
        math.floor(self.font:getWidth('WIN')/2), math.floor(self.font:getHeight()/2))
    end
    --love.graphics.setColor(255, 255, 255)
    --love.graphics.setCanvas()

    --love.graphics.setColor(colors.mana_color)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha') 
    
end

function DioStage:finish()
    CAT = false 
    timer:after(1, function()
        gotoRoom('DioStage')
    end)
end

function DioStage:addScore(pt)
    self.score = self.score + pt
    self.score_to_skill_points = self.score_to_skill_points + pt
    self.player.score_unchange_current = 0
end
