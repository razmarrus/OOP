
Menu = Object:extend()

function Menu:new()
    self.area = Area(self)
    self.timer = Timer()
    self.font = GAME_FONT
    self.lines = {}
    self.line_y =  gh - 72
    self.main_canvas = love.graphics.newCanvas(gw, gh)

    buttons = {} --here's where you'll store all your buttons
	--buttons["quit"] = button:new(gw - 90 , gh + 40, 200, 35, love.event.quit)
    --camera:lookAt(gw/2, gh/2)
    txt = love.graphics.newText(self.font, {colors.boost_color, 
    'blue text', colors.default_color, 'white text'})
    
    self:addLine(1, {colors.black, 'Play'})
    self:addLine(1, {colors.black, 'Skill tree'})
    self:addLine(1, {colors.boost_color, 'Exit'})

    log_screen_image = love.graphics.newImage("images/log2_2.jpg")
end

function Menu:draw()

    love.graphics.draw(log_screen_image, gw/2 - log_screen_image:getWidth()/4,
    gh/2 - log_screen_image:getHeight()/4) 
        drawn = true
    
    love.graphics.setCanvas()
    love.graphics.setColor(colors.red)
    --love.graphics.draw(txt, 400, 400)
    love.graphics.rectangle('fill', gw- 90, gh - 80, 200, 35)

    love.graphics.rectangle('fill', gw - 90 , gh - 20, 200, 35)

    love.graphics.rectangle('fill', gw - 90 , gh + 40, 200, 35)

    for _, line in ipairs(self.lines) do 
        love.graphics.draw(line.text, line.x, line.y) 
    end

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    
end

function Menu:update(dt)

    if love.mouse.isDown("l") then
        local x, y = love.mouse.getPosition()
        --rest of the click code here
    end
    --self.area:update(dt)
end

function Menu:addLine(delay, text)
    --self.timer:after(delay, function() 
    	table.insert(self.lines, {x = gw - 10, y = self.line_y, 
        text = love.graphics.newText(self.font, text)}) 
      	self.line_y = self.line_y + 60
   -- end)
end
--[[
function love.mousepressed(x, y, button)
	if button == "l" then
		for i, v in pairs(buttons) do
			if x >= v.x and y >= v.y and x < v.x+v.width and y < v.y+v.height then
				v.click()
			end
		end
	end
end

function button:new(x, y, w, h, f)
	local self = {}
	self.x = x
	self.y = y
	self.width = w
	self.height = h
	self.function = f
	--self.arguments = a
	self.click = function()
		if self.function then
			if self.arguments then
				self.function(unpack(self.arguments))
			else
				self.function()
			end
		end
	end
end
]]--