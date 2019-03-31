SkillTree = Object:extend()


require 'libraries/game/tree'

bought_node_indexes = { 1, 2 }

function SkillTree:new()
    --self.camera = Camera
    self.main_canvas = love.graphics.newCanvas(gw, gh)


    self.font = GAME_FONT

    self.nodes = {}
    self.lines = {}
    for id, node, r in ipairs(tree) do 
        --print(node.r)
        table.insert(self.nodes, Node(id, node.x, node.y, node.r)) 
    end
    for id, node in ipairs(tree) do 
        for _, linked_node_id in ipairs(node.links) do
            table.insert(self.lines, Line(id, linked_node_id))
        end
    end
end

function treeToPlayer(player)
   -- for _, node in ipairs(self.nodes) do
    for _, index in ipairs(bought_node_indexes) do
        --local stats = node[index].stats --local stats = tree[index].stats
        local stats = tree[index].stats
        for i = 1, #stats, 3 do
            local attribute, value = stats[i+1], stats[i+2]
            player[attribute] = player[attribute] + value
        end
    end
end


function SkillTree:update(dt)
    --self.area:update(dt)
    for _, game_object in ipairs(self.nodes) do 
        game_object:update() 
    end
    
    function love.keypressed(key, u)
        --Debug
        if key == "escape" then 
            gotoRoom("Menu")
        end
    end


end

function SkillTree:draw(dt)

    for _, game_object in ipairs(self.lines) do 
        game_object:draw() 
    end

        
    for _, game_object in ipairs(self.nodes) do 
        game_object:draw() 
       -- print("Heres")
    end

    love.graphics.setFont(self.font)

    love.graphics.setCanvas()
            -- Stats rectangle
            local font = self.font
            love.graphics.setFont(font)
            for _, node in ipairs(self.nodes) do
                if node.hot then
                    --print("HOT!")
                    local stats = tree[node.id].stats
                    -- Figure out max_text_width to be able to set the proper rectangle width
                    local max_text_width = 0
                    for i = 1, #stats, 3 do
                        if font:getWidth(stats[i]) > max_text_width then
                            max_text_width = font:getWidth(stats[i])
                        end
                    end
                    -- Draw rectangle
                    local mx, my = love.mouse.getPosition() 
                    mx, my = mx/sx, my/sy
                    love.graphics.setColor(0, 0, 0, 222)
                    love.graphics.rectangle('fill', mx, my, 
                    16 + max_text_width, font:getHeight() + (#stats/3)*font:getHeight())
                    -- Draw text
                    love.graphics.setColor(default_color)
                    for i = 1, #stats, 3 do
                        love.graphics.print(stats[i], math.floor(mx + 8), 
                          math.floor(my + font:getHeight()/2 + math.floor(i/3)*font:getHeight()))
                    end
                else 
                    local mx, my = love.mouse.getPosition() 
                end
            end
            love.graphics.setColor(default_color)
        love.graphics.setCanvas()

        love.graphics.setColor(colors.yellow)
        love.graphics.setCanvas()
        love.graphics.print('Points left', 200 , 55, 0, 2, 2,
        math.floor(self.font:getWidth('Points left')), math.floor(self.font:getHeight()))
        love.graphics.setCanvas()
    
  
        love.graphics.setCanvas()
        love.graphics.print( skill_points, 240 , 55, 0, 2, 2,
        math.floor(self.font:getWidth(skill_points)),
        math.floor(self.font:getHeight()))
        love.graphics.setCanvas()
        love.graphics.setColor(255, 255, 255, 255)

end

function SkillTree:canNodeBeBought(id_given)
        for id, node in ipairs(tree) do 
            if id == id_given then
                --print("Here " .. id)
                for _, linked_node_id in ipairs(node.links) do
                    if fn.any(bought_node_indexes, linked_node_id) and skill_points > 0 then return true end
                end
            end
        end
end

function SkillTree:destroy()
    save()
end

