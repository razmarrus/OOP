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
    back = {self.x, self.y}
    love.graphics.draw(scene, back[1] - scene:getWidth()/2,
    back[2] - scene:getHeight()/2) 
        drawn = true
end