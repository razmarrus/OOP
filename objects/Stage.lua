Stage = Object:extend()

function Stage:new()
    --self.depth = 30
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.timer = Timer()
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile','Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})
    self.font = GAME_FONT
    self.back = self.area:addGameObject('Background', gw/2, gh/2)
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    --sound = love.audio.newSource("music/SOAD_Chop_Suey_8_bit.mp3")
    --sound:play()

    self.main_canvas = love.graphics.newCanvas(gw, gh)

    input:bind('q', function() 
        self.area:addGameObject('Shooter', utils.random(0, gw), utils.random(0, gh)) 
    end)  

    function love.keypressed(key, u)
        --Debug
        if key == "w" then --set to whatever key you want to use
           debug.debug()
        end
     end

end

function Stage:update(dt)
    self.area:update(dt)

end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
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
    
    love.graphics.setCanvas()
    love.graphics.print('HP', gw-120 , gh+240, 0, 1, 1,
    math.floor(self.font:getWidth('HP')/2), math.floor(self.font:getHeight()/2))
    love.graphics.setCanvas()

    love.graphics.setCanvas(self.main_canvas)
    local r, g, b = unpack(colors.mana_color)
    local mana, max_mana = self.player.mana, self.player.max_mana
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', gw/2+10, gh - 16, 48*(mana/max_mana), 4)
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', gw/2+10, gh-16, 48, 4)
    love.graphics.setCanvas()


    love.graphics.print(hp .. '/' .. max_hp, gw/2 - 52 + 24, gh - 6, 0, 1, 1,
    math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2),
    math.floor(self.font:getHeight()/2))
    love.graphics.setCanvas()

    --love.graphics.setColor(255, 255, 255)
    --love.graphics.setCanvas()


    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha') 
    
end

function Stage:finish()
    timer:after(1, function()
        gotoRoom('Stage')
    end)
end
