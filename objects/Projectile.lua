Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)
    self.damage = 100
    self.s = opts.s or 2.5
    self.v = opts.v or 200
    proj = love.graphics.newImage("images/snowball.png")
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Projectile')
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end



function Projectile:update(dt)
    Projectile.super.update(self, dt)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()

        object:hit(self.damage)
        self:die()
    end

end

function Projectile:draw()
    love.graphics.setColor(default_color)
    local pr_image = {self.x,self.y}
    --love.graphics.circle('line', self.x, self.y, self.s)
    love.graphics.draw(proj, pr_image[1] - proj:getWidth()/2, pr_image[2] - proj:getHeight()/2)
    drawn = true

end

function Projectile:destroy()
    Projectile.super.destroy(self)
end

function Projectile:die()
    self.dead = true
    self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, 
    {color = hp_color, w = 3*self.s})
end
