

local GameObject = Object:extend()

function GameObject:new(area, x, y, opts)
    local opts = opts or {}
    if opts then
        for k, v in pairs(opts) do
            self[k] = v
        end
    end
    self.depth = 50

    self.area = area
    self.x = x or utils.random(0, gw)
    self.y = y or utils.random(0, gh)
    self.id = utils.UUID()
    self.dead = false
    self.timer = Timer()

    self.creation_time = love.timer.getTime()

    -- z-index
    self.depth = 50
end

function GameObject:destroy()
    -- if self.timer then self.timer:destroy() end
    --self.timer:destroy()
    if self.collider then self.collider:destroy() end
    self.collider = nil
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
    if self.collider then self.x, self.y = self.collider:getPosition() end
end

function GameObject:draw()

end

--function GameObject:__tostring()
    --return "GameObject( " .. self.id .. " @ " .. self.x .. ", " .. self.y  or 0 .. " )"
--end

return GameObject
