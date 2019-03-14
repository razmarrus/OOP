Player = GameObject:extend()

local SHOOT_RATE = 0.25
local BOOST_RATE = 2

local SHIP_SIZE = 12

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    person = love.graphics.newImage("images/Wizzard_pix.png")
    self.x, self.y = x, y
    self.w, self.h = SHIP_SIZE, SHIP_SIZE
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)

    self.r = -math.pi/2
    self.rv = 1.66*math.pi  --velocorty of rounding
    self.v = 2
    self.max_v = 100
    self.a = 100
    self.depth = 75
    self.max_hp = 100
    self.hp = self.max_hp
    --self.hp_stat        = Stats("hp", 100)
    self.max_mana = 150
    self.mana = 50

    self.collider:setCollisionClass('Player')

    self.timer:every(5, function() self:tick() end)
    
    input:bind('w', function() self:die() end)
   
    self.timer:every(0.24, function()
        self:shoot()
    end)

    self.timer:every(2, function()
        self.area:addGameObject('Rock', utils.random(0, gw), utils.random(0, gh))
    end)

    self.timer:every(3, function()
        self.area:addGameObject('Shooter', utils.random(0, gw), utils.random(0, gh))
    end)

end



function Player:update(dt)
    Player.super.update(self, dt)

    -- increase boost over time

    self.v = math.min(self.v + self.a*dt, self.max_v)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    

    if input:down('left') then self.r = self.r - self.rv*dt end
    if input:down('right') then self.r = self.r + self.rv*dt end

    --
--    v = self.velocity_stat:add(self.accel_stat.value*dt)
  --  self.collider:setLinearVelocity(v*math.cos(self.r), v*math.sin(self.r))

    self.v = self.v + self.a*dt
    if self.v >= self.max_v then
        self.v = self.max_v
    end
    
    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end

    if self.parent then self.x, self.y = self.parent.x, self.parent.y end

    if self.collider:enter('Collectable') then
        print(1)
    end

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()
        --self:addHP(-damage)
        --object:hit(self.damage)
        self:hit(30)
        --self:die()
    end

    if self.collider:enter('Collectable') then
        local collision_data = self.collider:getEnterCollisionData('Collectable')
        local object = collision_data.collider:getObject()
        if object:is(Mana) then
            object:die()
            if self.mana < self.max_mana then
                self.mana = self.mana + 15
                print("Mana "..self.mana)
            end
        end
    end

end


function Player:draw()
    character = {self.x,self.y}
    love.graphics.draw(person, character[1] - person:getWidth()/2, character[2] - person:getHeight()/2)
            drawn = true
    --love.graphics.circle('line', self.x, self.y, self.w)
    --love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))

end

function Player:destroy()
    Player.super.destroy(self)
end


function Player:shoot()
    local d = 1.2*self.w

    self.area:addGameObject('ShootEffect', self.x + d*math.cos(self.r), 
    self.y + d*math.sin(self.r), {player = self, d = d})

    self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), 
    self.y + 1.5*d*math.sin(self.r), {r = self.r})
end


function Player:die()
    self.dead = true 
    flash(4)

    --camera:shake(6, 60, 0.4)
    for i = 1, love.math.random(8, 12) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y) 
    end
    --state.current_room = Stage()
    state.current_room:finish()
end

function Player:tick()
    self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end


function Player:hit(damage)
    local damage = damage or 40

    self.hp = self.hp - damage

    if self.invincible then return end
    if self.hp > 0 then
        print("P: hit " .. damage)
        print("current hp " .. self.hp)
    else
        print("P: hit " .. damage)
        print("current hp " .. 0)
    end
    
    if self.hp <= 0 then
        self.hp = 0
        self:die()
        --self.area.room:addScore(self.value)
    else
        self.hit_flash = true
        self.timer:after(0.2, function() self.hit_flash = false end)
    end

    --self:addHP(-damage)

    if damage >= 30 then
        self.invincible = true
        print("P: +invincible")
        self.timer:every(0.2, function() self.visible = not self.visible end, 9)
        self.timer:after(2, function()
            self.invincible = false
            self.visible = true
            print("P: -invincible")
        end)
        flash(3)
    else
        flash(2)
    end
end

function Player:addHP(amount)
    self.hp:add(amount, function()
        self:die()
    end)
end

function Player:addMana(amount)
    self.mana:add(amount, function()
        self:die()
    end)
end
