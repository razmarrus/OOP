Dio = GameObject:extend()

function Dio:new(area, x, y, opts)
    Shooter.super.new(self, area, x, y, opts)
    self.deepth = 70
    self.w, self.h = 12, 6
    self.v = 100
    self.x = 230-- self.x + (dx / distance * self.v )
    self.y = 150 --self.y + (dy / distance * self.v )
   
    self.x_prev = 0
    self.y_prev = 0

   self.color = colors.white--opts.color or colors.hp_color
   love.graphics.setColor(colors.white)
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    --self.area.world:newPolygonCollider(
    --    {self.w, 0, -self.w/2, self.h, -self.w, 0, -self.w/2, -self.h})
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.collider:setAngle(direction == 1 and math.pi or 0)
    self.collider:setFixedRotation(true)
    self.shoottime = 0
    --self.v = -direction*utils.random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    dio_image = love.graphics.newImage("images/dio.png")
    self.first_spawn = false
    self.second_spawn = false
    self.first_plank = 200
    self.second_plank = 100
    self.roda_rolla_plank = 50
    self.roda_rolla_spawn = false

    self.special_skill_cooldown = 15
    self.special_skill_duration = 5
    self.special_skill_time = 10
    self.special_skill_flag = false


    -- stats
    self.max_hp = 300
    self.hp = self.max_hp
    self.value = 150
end

function Dio:destroy()
    Dio.super.destroy(self)
end

function Dio:die()
    self.dead = true
    for i = 1, love.math.random(4, 8) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = self.color})
    end
end

function Dio:hit(damage)
    local damage = damage or 40
    print("dio hitted")
    if self.roda_rolla_spawn == false then
        self.hp = self.hp - damage
    end

    if self.hp <= 0 and self.roda_rolla_spawn == false then
        self:die()
    end
end


 function Dio:update(dt)
    Dio.super.update(self, dt)
    local dx = (player_x - self.x) * (self.v * dt)
    local dy = (player_y - self.y) * (self.v * dt)
    
	self.x = self.x + (dx * dt)
	self.y = self.y + (dy * dt)
    --[[local dx = player_x - self.x
    local dy = player_y - self.y
    local distance = math.sqrt(dx*dx+dy*dy)


    self.x = self.x + (dx / distance * self.v * dt)
    self.y = self.y + (dy / distance * self.v * dt)
    ]]--
    self.collider:setPosition(self.x, self.y)

    if self.special_skill_time < self.special_skill_cooldown then
        self.special_skill_time = self.special_skill_time + dt
    elseif (self.special_skill_time > self.special_skill_cooldown and FROZEN == false) or self.roda_rolla_spawn then
        FROZEN = true
        if self.roda_rolla_spawn == false then
            sound = love.audio.newSource("music/zawarudo.mp3")
            sound:play()
        end
        
        self.special_skill_time = 0
        --print("Skill ready")
    end

    
    if FROZEN and self.roda_rolla_spawn == false then
        self.shoottime = self.shoottime + dt
        if self.shoottime > 0.5 then
            self.shoottime = 0
            withPlayer(function(player)
                self.area:addGameObject('EnemyProjectile',
                    self.x, self.y,
                    {
                        r = math.atan2(player_y - self.y, player_x - self.x),
                        v = utils.random(80, 100), s = 3.5
                    })
            end)
        end
    end

    --if FROZEN and self.special_skill_time < self.special_skill_duration rhen

    if self.special_skill_time >= self.special_skill_duration and FROZEN and self.roda_rolla_spawn == false then
        FROZEN = false
        self.special_skill_time = 0
    end

    if self.hp <= self.first_plank and self.first_spawn  == false then 
        self.first_spawn = true
        for i = 1, 7 do
            self.area:addGameObject('Rock', utils.random(0, gw), utils.random(0, gh))
            self.area:addGameObject('Rock', utils.random(0, gw), utils.random(0, gh)) 
            self.area:addGameObject('Shooter', utils.random(0, gw), utils.random(0, gh)) 
        end
    end

    if self.hp <= self.second_plank and self.second_spawn  == false then 
        self.second_spawn = true
        for i = 1, 7 do
            self.area:addGameObject('Rock', utils.random(0, gw), utils.random(0, gh))
            self.area:addGameObject('Rock', utils.random(0, gw), utils.random(0, gh)) 
            self.area:addGameObject('Shooter', utils.random(0, gw), utils.random(0, gh)) 
        end
    end
    

    if self.hp <= self.roda_rolla_plank and self.roda_rolla_spawn == false then 
        self.roda_rolla_spawn = true 
        dio_image = love.graphics.newImage("images/rodarolla.png")
        sound = love.audio.newSource("music/oraora.mp3")
        sound:play()
        RR = true
        --print(player_x, player_y)
        self.x =  gw/2 -7
        self.y =  gh/2 -7
        self.collider:setPosition(self.x, self.y)
    end
    

    if self.roda_rolla_spawn then
        
        self.x = gw/2 -7 - love.math.random(1, 10)
        self.y = gh/2 -7 - love.math.random(1, 10)
        self.collider:setPosition(self.x, self.y)
        camera:shake(100, 100, 2)
    end

 end

function Dio:draw()
    bar = {self.x,self.y}
    --love.graphics.draw(dio_image, self.x, self.y, self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.draw(dio_image, bar[1] - dio_image:getWidth()/2, bar[2] - dio_image:getHeight()/2)
            drawn = true

end



