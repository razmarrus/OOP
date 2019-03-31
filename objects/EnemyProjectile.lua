EnemyProjectile = GameObject:extend()

function EnemyProjectile:new(area, x, y, opts)
    EnemyProjectile.super.new(self, area, x, y, opts)

    self.s = opts.s or 2.5
    self.v = opts.v or 200
    EnemyProjectile_image = love.graphics.newImage("images/fireball.png")

    self.color = colors.hp_color

    self.value = 30
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setCollisionClass('EnemyProjectile')
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    self.name = 'EnemyProjectile'

    -- stats

    self.damage = opts.damage or 10
end

function EnemyProjectile:destroy()
    EnemyProjectile.super.destroy(self)
end

function EnemyProjectile:die()
    self.dead = true
    self.area.room:addScore(self.value)
    self.area:addGameObject('ProjectileDeathEffect', self.x, self.y,
        {color = colors.hp_color, w = 3*self.s})
end

function EnemyProjectile:hit(damage)
    self:die()
end

function EnemyProjectile:update(dt)
    EnemyProjectile.super.update(self, dt)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end

    if self.collider:enter('Player') then
        local collision_data = self.collider:getEnterCollisionData('Player')
        local object = collision_data.collider:getObject()

        self:die()
        object:hit(self.damage)

    end
end

function EnemyProjectile:draw()
    utils.pushRotate(self.x, self.y, self.r)
    local epr_image = {self.x,self.y}
    --love.graphics.circle('line', self.x, self.y, self.s)
    love.graphics.draw(EnemyProjectile_image, epr_image[1] - EnemyProjectile_image:getWidth()/2, epr_image[2] - EnemyProjectile_image:getHeight()/2)
    drawn = true

    love.graphics.setLineWidth(self.s - self.s/4)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - 2*self.s, self.y, self.x, self.y)
    love.graphics.setColor(colors.hp_color) -- change half the projectile line to another color
    love.graphics.line(self.x, self.y, self.x + 2*self.s, self.y)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
    
end


