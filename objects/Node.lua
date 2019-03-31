Node = Object:extend()

function Node:new(id, x, y, r)
    self.id = id
    self.x, self.y = x, y
    self.r = r
    self.w = self.r
    self.hot = false
    
end

function Node:update(dt)
    local mx, my = love.mouse.getPosition()  --getMousePosition(sx, sy, 0, 0, sx*gw, sy*gh)
    if mx >= self.x - self.r and mx <= self.x + self.r and 
       my >= self.y - self.r and my <= self.y + self.r then 
          self.hot = true
          --print("HOTHOT!")
    else self.hot = false  end

    
    if fn.any(bought_node_indexes, self.id) then self.bought = true
    else self.bought = false end


    x, y = love.mouse.getPosition()
    local left_click = love.mouse.isDown(1)

    if self.hot and left_click  then 

        if SkillTree:canNodeBeBought(self.id) then
            if not fn.any(bought_node_indexes, self.id) then
                table.insert(bought_node_indexes, self.id)
                skill_points = skill_points - 1
            end
        end
    end


end

function Node:draw()

    local r, g, b = unpack(colors.default_color)
    love.graphics.setColor(colors.background_color)
    love.graphics.circle('fill', self.x, self.y, self.w)
    if self.bought then love.graphics.setColor(r, g, b, 255)
    else     love.graphics.setColor(colors.ammo_color) end--love.graphics.setColor(r, g, b, 32) end
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.setColor(r, g, b, 255)
end