SkillTree = Object:extend()

function SkillTree:new()
    --self.area = Area(self)
    --self.area:addPhysicsWorld()
    --self.timer = Timer()
    --self.camera = Camera
      
    self.main_canvas = love.graphics.newCanvas(gw, gh)


    tree = {}
    tree[1] = {x =450, y = 150}
    tree[2] = {x = 500, y = 150}

    self.nodes = {}
    for _, node in ipairs(tree) do table.insert(self.nodes, Node(node.x, node.y)) end
end

function SkillTree:update(dt)
    --self.area:update(dt)

    
    function love.keypressed(key, u)
        --Debug
        if key == "escape" then 
            gotoRoom("Menu")
        end
    end

   --[[ if input:down('left_click') then
        local mx, my = camera:getMousePosition(sx, sy, 0, 0, sx*gw, sy*gh)
        local dx, dy = mx - self.previous_mx, my - self.previous_my
        camera:move(-dx, -dy)
    end
    self.previous_mx, self.previous_my = camera:getMousePosition(sx, sy, 0, 0, sx*gw, sy*gh)
    ]]--
    --[[
    if input:pressed('zoom_in') then 
        self.timer:tween('zoom', 0.2, camera, {scale = camera.scale + 0.4}, 'in-out-cubic') 
    end
    if input:pressed('zoom_out') then 
        self.timer:tween('zoom', 0.2, camera, {scale = camera.scale - 0.4}, 'in-out-cubic') 
    end]]--

end

function SkillTree:draw(dt)
    --love.graphics.setCanvas(self.main_canvas)
    --love.graphics.clear()
    --love.graphics.circle('line', self.nodes[1].x, self.nodes[1].y, 12)
    
    for _, game_object in ipairs(self.nodes) do 
        game_object:draw() 
       -- print("Heres")
    end
       --[[
    for i = 1, #self.nodes do
        self.nodes[i]:draw()
    end
    ]]--
end

