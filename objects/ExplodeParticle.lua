ExplodeParticle = GameObject:extend()

function ExplodeParticle:new(area, x, y, opts)
    ExplodeParticle.super.new(self, area, x, y, opts)

    self.color = opts.color or default_color
    self.r = utils.random(0, 2*math.pi)
    self.s = opts.s or utils.random(2, 3)
    self.v = opts.v or utils.random(75, 150)
    self.line_width = 2
    self.timer:tween(opts.d or utils.random(0.3, 0.5), self, {s = 0, v = 0, line_width = 0}, 
    'linear', function() self.dead = true end)
end



function ExplodeParticle:draw()
    pushRotate(self.x, self.y, self.r)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - self.s, self.y, self.x + self.s, self.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end


function ExplodeParticle:destroy()
    ExplodeParticle.super.destroy(self)
end
--[[
function ExplodeParticle:update(dt)
    ExplodeParticle.super.update(self, dt)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end
]]--

