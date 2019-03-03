Stage = Object:extend()

function Stage:new()

    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.timer = Timer()
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile','Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
   -- self.area.world:addCollisionClass('Projectile', {ignores = {'Player'}})


    --self.area:addGameObject('Player', gw/2, gh/2)
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    --input:bind('q', function() self.player.dead = true end)

    self.area.world:addCollisionClass('Enemy')

    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.timer = Timer()

    --input:bind('q', function() 

    input:bind('q', function() 
        self.area:addGameObject('Rock', utils.random(0, gw), utils.random(0, gh)) 
    end)

    

end

function Stage:update(dt)
    self.area:update(dt)

    --self.area:addGameObject('Rock', utils.random(0, gw), utils.random(0, gh)) 



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
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
