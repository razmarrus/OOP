Player = GameObject:extend()

local SHOOT_RATE = 0.25
local BOOST_RATE = 2

local SHIP_SIZE = 12

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = SHIP_SIZE, SHIP_SIZE
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)

    self.r = -math.pi/2
    self.rv = 1.66*math.pi  --velocorty of rounding
    self.v = 2
    self.max_v = 100
    self.a = 100

    

    
    input:bind('w', function() self:die() end)
   
    self.timer:every(0.24, function()
        self:shoot()
    end)


    -- The Ship

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


end


function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))

 
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
end