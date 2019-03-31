Rock = GameObject:extend()

function Rock:new(area, x, y, opts)
    Rock.super.new(self, area, x, y, opts)

    local direction = utils.table.random({-1, 1})
    self.s = 16
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = utils.random(self.s, gh - self.s)

    self.color = opts.color or colors.hp_color
    self.points = utils.createIrregularPolyPoints(self.s/2, 8)
    barrel = love.graphics.newImage("images/Barrel.png")
    self.collider = self.area.world:newPolygonCollider(self.points)
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.v = -direction*utils.random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(utils.random(-100, 100))
    self.depth = 65
    -- effects

    self.hit_flash = false

    -- stats

    self.hp = opts.hp or 100
    self.value = 100
end

function Rock:destroy()
    Rock.super.destroy(self)
end

function Rock:die()
    self.dead = true
    for i = 1, love.math.random(4, 8) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = self.color})
    end
    if love.math.random(1, 3) >= 3 then 
        self.area:addGameObject('Mana', self.x, self.y, 
        {color = self.color})
    end
end

function Rock:hit(damage)
    local damage = damage or 100

    self.hp = self.hp - damage

    if self.hp <= 0 then
        self:die()
        self.area.room:addScore(self.value)
    else
        --self.hit_flash = true
        --self.timer:after(0.2, function() self.hit_flash = false end)
    end
end

function Rock:update(dt)
    if not FROZEN then
        Rock.super.update(self, dt)
    else 
        --self.x = self.x
        --self.y = self.y
        --print('Frozen')
    end
end

function Rock:draw()

    bar = {self.x,self.y}
    love.graphics.draw(barrel, bar[1] - barrel:getWidth()/2, bar[2] - barrel:getHeight()/2)
            drawn = true

    if self.hit_flash then
        love.graphics.setColor(colors.default_color)
    end
end


