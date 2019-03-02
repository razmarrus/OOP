Player = GameObject:extend()
--[[
function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    
    self.r = -math.pi/2
    self.rv = 1.66*math.pi  --velocorty of rounding
    self.v = 2
    self.max_v = 100
    self.a = 100

    self.x, self.y = x, y
    self.w, self.h = 12, 12
    --self.area = area  --!!!!!!
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)  --binding


end

function Player:update(dt)
    Player.super.update(self, dt)

    if input:down('left') then self.r = self.r - self.rv*dt end
    if input:down('right') then self.r = self.r + self.rv*dt end

    self.v = math.min(self.v + self.a*dt, self.max_v)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    
    self.v = self.v + self.a*dt
    if self.v >= self.max_v then
        self.v = self.max_v
    end

end

function Player:draw()
    --love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))

end
]]--

--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

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



end


function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))

 
end


