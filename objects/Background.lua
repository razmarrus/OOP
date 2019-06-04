Background = GameObject:extend()

function Background:new(area, x, y, opts)
    Background.super.new(self, area, x, y, opts)
    self.depth = 10
    self.x, self.y = x, y
    self.font = GAME_FONT
     -- фон для нашей сцены
    if DIO then
        scene = love.graphics.newImage("images/d_back.png")
    else
        scene = love.graphics.newImage("images/grass.png")
    end
    
    self.love_activated = false
    self.love_was_activated = false
    self.love_was_unactivated = true

end

function Background:destroy()
    ShootEffect.super.destroy(self)
end

function Background:update(dt)
    Background.super.update(self, dt)

    if CAT and (not self.love_activated) then
        scene = love.graphics.newImage("images/cat_back.png")
        self.love_activated = true
        self.love_was_activated = true
        self.love_was_unactivated = false
    end

    if (not CAT) and self.love_was_activated and (not self.love_was_unactivated) then      
        self.love_was_activated = false
        self.love_was_unactivated = true
        self.love_activated = false
        scene = love.graphics.newImage("images/grass.png")
    end

end

function Background:draw()
    --love.graphics.setColor({0,0,255})
    
    love.graphics.draw(scene, gw/2 - scene:getWidth()/2,
    gh/2 - scene:getHeight()/2) 
       drawn = true
       

       --love.graphics.print('HP', gw/2 + 120, gh + 240, 0, 1, 1,
       --math.floor(self.font:getWidth('HP')/2), math.floor(self.font:getHeight()/2))

       
end