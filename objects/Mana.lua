Mana = GameObject:extend()


function Mana:new(area, x, y, opts)
    Mana.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.depth = 65
    self.mana = 10
    self.w, self.h = 8, 8

    m_portion = love.graphics.newImage("images/Mana_po.png")

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')

    self.collider:setFixedRotation(false)
    self.r = utils.random(0, math.pi)
    self.v = utils.random(10, 20)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    self.collider:applyAngularImpulse(utils.random(-24, 24))

end


function Mana:upadte(dt)
    Mana.super.update(self, dt)

    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    withPlayer(function(target)
        local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
        local angle = math.atan2(target.y - self.y, target.x - self.x)
        local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
        local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
        self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
    end)
end



function Mana:draw()
    Ma = {self.x,self.y}
    love.graphics.draw(m_portion, Ma[1] - person:getWidth()/2, Ma[2] - m_portion:getHeight()/2)
            drawn = true
end


function Mana:destroy()
    Mana.super.destroy(self)
end

function Mana:die()
    self.dead = true
    self.area:addGameObject('InfoText', self.x, self.y, {text = '+MANA', color = colors.mana_color})

end