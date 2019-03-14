Background = GameObject:extend()

function Background:new(area, x, y, opts)
    Background.super.new(self, area, x, y, opts)
    self.depth = 10
    self.x, self.y = x, y
     -- фон для нашей сцены
    scene = love.graphics.newImage("images/grass.png")

end

function Background:destroy()
    ShootEffect.super.destroy(self)
end

function Background:update(dt)
    Background.super.update(self, dt)
end

function Background:draw()
    --love.graphics.setColor({0,0,255})
    
    love.graphics.draw(scene, gw/2 - scene:getWidth()/2,
    gh/2 - scene:getHeight()/2) 
       drawn = true
end