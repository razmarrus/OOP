MagePlayer = GameObject:extend()

local SHOOT_RATE = 0.25
local BOOST_RATE = 2

local PLAYER_SIZE = 12

function MagePlayer:new(area, x, y, opts)
    MagePlayer.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = PLAYER_SIZE, PLAYER_SIZE
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    --HP = 80
    self.font = GAME_FONT
    --MANA = 50
    self:setAttack('Neutral')
    self.r = -math.pi/2
    self.rv = 1.66*math.pi  --velocorty of rounding
    self.v = 2
    self.base_max_v = 100
    self.max_v = self.base_max_v
    self.a = 100
    self.depth = 75

    self.boosting = false
    self.boost_timer = CooldownTimer(BOOST_RATE)
    self.can_boost = true 
    self.velocity_stat  = 100
    self.accel_stat     =  100

    -- Boosting
    self.boost_stat     =  100
    self.max_boost = 150

    self.flat_hp = 0
    self.max_hp = 100
    self.hp = 80
    self.hp_multiplier = 1

    self.flat_mana = 0
    self.max_mana = 150
    self.mana = 50
    self.mana_multiplier = 1
    self.shield_addition = 0
    --hp_multiplier

    --self.hero = HERO
    self.special_skill_cooldown = 15
    self.special_skill_duration = 5
    self.special_skill_time = 10
    self.special_skill_flag = false
    
    self.cat_duration = 5
    self.cat_time = 0
    self.score_unchange_required = 5
    self.score_unchange_current = 0
    self.cat_flag = false
    --self.cat_du

    --HERO = 'Mage'

    self.hero = 'Mage'

    treeToPlayer(self)
    self:setStats()


    if self.hero == 'Mage' then
        self.person = love.graphics.newImage("images/Wizzard_pix.png")
    elseif self.hero == 'Warrior' then
        self.person = love.graphics.newImage("images/Viking.png")
    end
    self.person_buffer = self.person
    person = self.person

    self.collider:setCollisionClass('Player')

    self.timer:every(5, function() self:tick() end)

    if self.hero == 'Mage' then
        self.timer:every(0.24, function()
            self:shoot()
        end)
    end


end


function MagePlayer:update(dt)
    MagePlayer.super.update(self, dt)
    if self.boost_stat < self.max_boost then
        self.boost_stat = self.boost_stat + 10*dt
        if self.boost_stat > self.max_boost then
            self.max_boost = self.boost_stat  
        end
    end

    local boost = self.boost_stat
    local v = self.velocity_stat
    local a = self.accel_stat

    self.boost_timer(dt, function()
        self.can_boost = true
    end)


    if self.special_skill_time < self.special_skill_cooldown then
        self.special_skill_time = self.special_skill_time + dt
    elseif self.special_skill_time == self.special_skill_cooldown then
        print("Skill ready")
    end

   if self.cat_flag == true and self.score_unchange_current > self.cat_duration then
        self.cat_flag = false
        self.person =  self.person_buffer 
        person = self.person
        self.score_unchange_current = 0
        CAT = false
        
    end
    


    -- increase boost over time

    self.v = math.min(self.v + self.a*dt, self.max_v)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    
    if love.keyboard.isDown('a') then self.r = self.r - self.rv*dt end
    if love.keyboard.isDown('d') then self.r = self.r + self.rv*dt end
    --if input:down('left') then self.r = self.r - self.rv*dt end
    --if input:down('right') then self.r = self.r + self.rv*dt end

    --
--    v = self.velocity_stat:add(self.accel_stat.value*dt)
  --  self.collider:setLinearVelocity(v*math.cos(self.r), v*math.sin(self.r))

    self.v = self.v + self.a*dt
    if self.v >= self.max_v then
        self.v = self.max_v
    end
    --self.hp = HP
    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end

    if self.parent then self.x, self.y = self.parent.x, self.parent.y end

    self.max_v = self.base_max_v
    self.boosting = false

    
    if love.keyboard.isDown("w") and boost > 1 then--input:down('up') then 
        --print("UP")
        self.boosting = true
        self.max_v = 1.5* self.base_max_v 
    end
    if love.keyboard.isDown("s") and boost > 1 then--input:down('down') then 
        --print("DOWN")
        self.boosting = true
        self.max_v = 0.5* self.base_max_v 
    end


    if self.boosting and boost > 1 then
        -- decrease boost while boosting
        self.boost_stat = self.boost_stat - 50 * dt
        self.boosting = false
        self.can_boost = false
    end
    
    --self.trail_color = colors.skill_point_color 
    --if self.boosting then self.trail_color = colors.boost_color end
    
    
    
    if self.collider:enter('Collectable') then
        print(1)
    end

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()
        --self:addHP(-damage)
        --object:hit(self.damage)
        self:hit(30)
        --self:die()
    end
    
    if self.collider:enter('EnemyProjectile') and self.hero == 'Warrior' then
        self.hp = self.hp - 10
        --HP = self.hp
        if self.hp <= 0 then
            self.hp = 0
            self:die()
        end
        print("warrior hitted")
    end

    if self.collider:enter('Collectable')  then
        local collision_data = self.collider:getEnterCollisionData('Collectable')
        local object = collision_data.collider:getObject()
        if object:is(Mana) then
            object:die()
            if self.mana < self.max_mana and self.hero == 'Mage' then
                self.mana = self.mana + 15
                print("Mana "..self.mana)
            end
        end
        if self.mana > self.max_mana then
            self.mana = self.max_mana
        end
        if self.hp > self.max_hp then
                self.hp = self.max_hp
                --HP = self.max_hp
        end
    end


end


function MagePlayer:draw()
    --if CAT then love.graphics.setColor(colors.white) end
    love.graphics.setColor(colors.white)
    self.character = {self.x,self.y}
    love.graphics.draw(person, self.character[1] - person:getWidth()/2, self.character[2] - person:getHeight()/2)
            drawn = true

end

function MagePlayer:destroy()
    MagePlayer.super.destroy(self)
end


function MagePlayer:specialSkill()

    if self.hero == 'Mage' and self.special_skill_time >= self.special_skill_cooldown then --self.hero == 'Mage' and
       -- FROZEN = true
        --print()
        self.special_skill_flag = true
        self.special_skill_time = 0
        --print('something special')
    elseif self.hero == 'Warrior' and self.special_skill_time >= self.special_skill_cooldown then 
        self.special_skill_flag = true
        self.special_skill_time = 0
        undieble = true
        print('something special 4 viking')
    end
end

function MagePlayer:setStats()
    self.max_hp = (self.max_hp + self.flat_hp)*self.hp_multiplier
    self.hp = self.max_hp - 20
    --HP = self.hp

    self.max_mana = (self.max_mana + self.flat_mana)*self.mana_multiplier
    self.mana = self.max_mana

    self.special_skill_duration = self.special_skill_duration + self.shield_addition
    
end


function MagePlayer:shoot()
    local d = 1.2*self.w
    local d = 1.2*self.w

    self.area:addGameObject('ShootEffect',
        self.x + d*math.cos(self.r),
        self.y + d*math.sin(self.r),
        {player = self, d = d})

    if self.attack == 'Neutral' then
        self.area:addGameObject('Projectile',
            self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r})
    end

    if self.mana > 0 then

        if self.attack == 'Double' then
            local dr = math.pi/12
            for _, r in ipairs({self.r + dr, self.r - dr}) do
                self.area:addGameObject('Projectile',
                    self.x + 1.5*d*math.cos(r), self.y + 1.5*d*math.sin(r), {r = r, attack=self.attack})
            end
        end

        if self.attack == 'Triple' then
            local dr = math.pi/12
            for _, r in ipairs({self.r + dr, self.r, self.r - dr}) do
                self.area:addGameObject('Projectile',
                    self.x + 1.5*d*math.cos(r), self.y + 1.5*d*math.sin(r), {r = r, attack=self.attack})
            end
        end

        if self.attack == 'Rapid' then
            self.area:addGameObject('Projectile',
                self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r),
                {r = self.r, attack = self.attack})
        end

        if self.attack == 'Spread' then
            local dr = utils.random(-math.pi/12, math.pi/12)
            self.area:addGameObject('Projectile',
                self.x + 1.5*d*math.cos(self.r + dr),
                self.y + 1.5*d*math.sin(self.r + dr),
                {r = self.r + dr, attack=self.attack})
        end

        if self.attack == 'Back' then
            local dr = math.pi
            for _, r in ipairs({self.r + dr, self.r}) do
                self.area:addGameObject('Projectile',
                    self.x + 1.5*d*math.cos(r), self.y + 1.5*d*math.sin(r), {r = r, attack=self.attack})
            end
        end

        if self.attack == 'Side' then
            local dr = math.pi/2
            for _, r in ipairs({self.r + dr, self.r, self.r - dr}) do
                self.area:addGameObject('Projectile',
                    self.x + 1.5*d*math.cos(r), self.y + 1.5*d*math.sin(r), {r = r, attack=self.attack})
            end
        end
    else
        self:setAttack('Neutral')
        self.area:addGameObject('Projectile',
        self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r})
        
    end
    if self.mana < 0 then
        self.mana = 0
    end


    withAttack(self.attack, function(attack)
        self:addMana(-attack.mana)
    end)
--[[
    self.area:addGameObject('ShootEffect', self.x + d*math.cos(self.r), 
    self.y + d*math.sin(self.r), {player = self, d = d})

    self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), 
    self.y + 1.5*d*math.sin(self.r), {r = self.r})
    ]]--
end


function MagePlayer:die()
    self.hp = 0
    self.dead = true 
    --flash(4)

    --camera:shake(6, 60, 0.4)
    for i = 1, love.math.random(8, 12) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y) 
    end
    --state.current_room = Stage()
    --state.current_room:finish()
end

function MagePlayer:tick()
    self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end


function MagePlayer:hit(damage)
    local damage = damage or 40


    self.hp = self.hp - damage

    if self.hp > 0 then
        print("P: hit " .. damage)
        print("current hp " .. self.hp)
    else
        print("P: hit " .. damage)
        print("current hp " .. 0)
    end
    
    if self.hp <= 0 then
        self.hp = 0
        self:die()
        --self.area.room:addScore(self.value)
    else
        self.hit_flash = true
        self.timer:after(0.2, function() self.hit_flash = false end)
    end

    --self:addHP(-damage)

    if damage >= 30 then
        self.invincible = true
        --print("P: +invincible")
        self.timer:every(0.2, function() self.visible = not self.visible end, 9)
        self.timer:after(2, function()
            self.invincible = false
            self.visible = true
            --print("P: -invincible")
        end)
        --flash(3)
    else
        --flash(2)
    end
end


function MagePlayer:addHP(amount)
    self.hp:add(amount, function()
        self:die()
    end)
end

function MagePlayer:addMana(amount)
    --sif self.mana > 0
    self.mana = self.mana + amount
end

function MagePlayer:setAttack(attack)
    print("P: attack " .. attack)

    withState("attacks", function(attacks)
        local cooldown = attacks[attack].cooldown
        self.shoot_timer = CooldownTimer(cooldown)
        self.attack = attack

    end)
end