--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

Shooter = GameObject:extend()

function Shooter:new(area, x, y, opts)
    Shooter.super.new(self, area, x, y, opts)
    self.deepth = 70
    local direction = utils.table.random({-1, 1})
    self.w, self.h = 12, 6
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = utils.random(self.h, gh - self.h)

   self.color = opts.color or colors.hp_color
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    --self.area.world:newPolygonCollider(
    --    {self.w, 0, -self.w/2, self.h, -self.w, 0, -self.w/2, -self.h})
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.collider:setAngle(direction == 1 and math.pi or 0)
    self.collider:setFixedRotation(true)
    self.v = -direction*utils.random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    shooter_image = love.graphics.newImage("images/shooter.png")
    --shooter_image = love.graphics.newImage("images/bus_pusheen.png")
    self.shootflag = false
    -- effects

    self.hit_flash = false
    self.timer:every(utils.random(3, 6), function()
             self.shootflag = true

        self.timer:after(1, function()
            withPlayer(function(player)
                self.area:addGameObject('EnemyProjectile',
                    self.x, self.y,
                    {
                        r = math.atan2(player.y - self.y, player.x - self.x),
                        v = utils.random(80, 100), s = 3.5
                    })
            end)
            self.shootflag = false
        end)
    end)

    
    self.love_activated = false
    self.love_was_activated = false
    self.love_was_unactivated = true

    -- stats

    self.hp = opts.hp or 100
    self.value = 150
end

function Shooter:destroy()
    Shooter.super.destroy(self)
end

function Shooter:die()
    self.dead = true
    for i = 1, love.math.random(4, 8) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = self.color})
    end
end

function Shooter:hit(damage)
    local damage = damage or 100

    self.hp = self.hp - damage

    if self.hp <= 0 then
        self:die()
        self.area.room:addScore(self.value)
    else
        self.hit_flash = true
        self.timer:after(0.2, function() self.hit_flash = false end)
    end
end

function Shooter:update(dt)
    Shooter.super.update(self, dt)

    
    if CAT and (not self.love_activated) then
        --print("CALMCALM")
        shooter_image = love.graphics.newImage("images/pusheen_attack.png")
        self.love_activated = true
        self.love_was_activated = true
        self.love_was_unactivated = false
    end
    --if CAT then 
    --    shooter_image = love.graphics.newImage("images/bus_pusheen.png")
    --end

    if (not CAT) and self.love_was_activated and (not self.love_was_unactivated) then      
        self.love_was_activated = false
        self.love_activated = false
        self.love_was_unactivated = true
        shooter_image = love.graphics.newImage("images/shooter.png")
    end
end

function Shooter:draw()
    if self.hit_flash then
        love.graphics.setColor(colors.default_color)
    else
       love.graphics.setColor(self.color)
    end
    if CAT then love.graphics.setColor(colors.white) end
    if self.shootflag then
        if not CAT then 
            shooter_image = love.graphics.newImage("images/creep_attack.png")
        else 
            love.graphics.setColor(colors.white)
            shooter_image = love.graphics.newImage("images/pusheen_attack.png")
        end
        local sh_im = {self.x,self.y}
        love.graphics.draw(shooter_image, sh_im[1] - shooter_image:getWidth()/2, sh_im[2] - shooter_image:getHeight()/2)
            drawn = true
    else
        if not CAT then shooter_image = love.graphics.newImage("images/shooter.png")
        else 
            shooter_image = love.graphics.newImage("images/calm.png")
        end
        local sh_im = {self.x,self.y}
        love.graphics.draw(shooter_image, sh_im[1] - shooter_image:getWidth()/2, sh_im[2] - shooter_image:getHeight()/2)
            drawn = true
    
    end
end


