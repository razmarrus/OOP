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
    HP = 80
    self.font = GAME_FONT
    MANA = 50
    self:setAttack('Neutral')
    self.r = -math.pi/2
    self.rv = 1.66*math.pi  --velocorty of rounding
    self.v = 2
    self.max_v = 100
    self.a = 100
    self.depth = 75

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

    self.hero = HERO
    self.special_skill_cooldown = 15
    self.special_skill_duration = 5
    self.special_skill_time = 10
    self.special_skill_flag = false
    if HERO == 'Mage' then
        self.hero = 'Mage'
    elseif HERO == 'Warrior' then
        self.hero = 'Warrior'
    end
    treeToPlayer(self)
    self:setStats()


    if self.hero == 'Mage' then
        self.person = love.graphics.newImage("images/Wizzard_pix.png")
    elseif self.hero == 'Warrior' then
        self.person = love.graphics.newImage("images/Viking.png")
    end
    person = self.person
    --self.hp = self.max_hp
    --self.hp_stat        = Stats("hp", 100)


    self.collider:setCollisionClass('Player')

    self.timer:every(5, function() self:tick() end)
    
    --input:bind('w', function() self:die() end)
    --input:bind('a', function()   goto_room_Menu() end)

    if self.hero == 'Mage' then
        self.timer:every(0.24, function()
            self:shoot()
        end)
    end
--[[
    self.timer:every(2, function()
        --self.area:addGameObject('Rock', utils.random(0, gw), utils.random(0, gh))
    end)

    self.timer:every(3, function()
        --self.area:addGameObject('Shooter', utils.random(0, gw), utils.random(0, gh))
    end)
    ]]--
    

end

function GM()
    print("GOD MOD")
    HP = 100
    undieble = true
end


function Player:update(dt)
    Player.super.update(self, dt)
    if self.special_skill_time < self.special_skill_cooldown then
        self.special_skill_time = self.special_skill_time + dt
    elseif self.special_skill_time == self.special_skill_cooldown then
        print("Skill awaleble")
    end

    if self.special_skill_time >= self.special_skill_duration and FROZEN == true and self.hero == 'Mage' then
        FROZEN = false
    elseif self.special_skill_time >= self.special_skill_duration and self.hero == 'Warrior' then
        undieble = false
    end

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
    self.hp = HP
    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end

    if self.parent then self.x, self.y = self.parent.x, self.parent.y end

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
        HP = self.hp
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
            elseif self.hp < self.max_hp and self.hero == 'Warrior' then
                self.hp = self.hp + 20
                HP = self.hp
                print("Hp "..self.hp)
                print("HP ADDED")
            end
        end
        if self.mana > self.max_mana then
            self.mana = self.max_mana
        end
        if self.hp > self.max_hp then
                self.hp = self.max_hp
                HP = self.max_hp
        end
    end

end


function Player:draw()
    self.character = {self.x,self.y}
    love.graphics.draw(person, self.character[1] - person:getWidth()/2, self.character[2] - person:getHeight()/2)
            drawn = true
    if undieble then
        love.graphics.circle('line', self.x, self.y, 22)
    end
    --love.graphics.circle('line', self.x, self.y, self.w)
    --love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
    if self.hero == 'Warrior' then
        if self.special_skill_time < self.special_skill_cooldown  then
            love.graphics.setColor(115, 112, 112)
        else
            love.graphics.setColor(255, 215, 0)
        end
        love.graphics.circle("fill", 150, 255, 10, 5) 
    end

end

function Player:destroy()
    Player.super.destroy(self)
end


function Player:specialSkill()

    if self.hero == 'Mage' and self.special_skill_time >= self.special_skill_cooldown then --self.hero == 'Mage' and
        FROZEN = true
        self.special_skill_time = 0
        print('something special')
    elseif self.hero == 'Warrior' and self.special_skill_time >= self.special_skill_cooldown then 
        self.special_skill_flag = true
        self.special_skill_time = 0
        undieble = true
        print('something special 4 viking')
    end
end

function Player:setStats()
    self.max_hp = (self.max_hp + self.flat_hp)*self.hp_multiplier
    self.hp = self.max_hp - 20
    HP = self.hp

    self.max_mana = (self.max_mana + self.flat_mana)*self.mana_multiplier
    self.mana = self.max_mana

    self.special_skill_duration = self.special_skill_duration + self.shield_addition
    
end


function Player:shoot()
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


function Player:die()
    self.dead = true 
    flash(4)

    --camera:shake(6, 60, 0.4)
    for i = 1, love.math.random(8, 12) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y) 
    end
    --state.current_room = Stage()
    state.current_room:finish()
end

function Player:tick()
    self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end


function Player:hit(damage)
    local damage = damage or 40
    if not undieble and self.hero == 'Mage' then
        self.hp = self.hp - damage
        HP = self.hp
    elseif self.hero == 'Warrior' and undieble then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()
        object:hit(self.damage)
    elseif self.hero == 'Warrior' then
        self.hp = self.hp - 3
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()
        --if object.collider != 'EnemyProjectile' then
        object:hit(self.damage)
        --end
    end
    HP = self.hp

    if self.invincible then return end
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
        print("P: +invincible")
        self.timer:every(0.2, function() self.visible = not self.visible end, 9)
        self.timer:after(2, function()
            self.invincible = false
            self.visible = true
            print("P: -invincible")
        end)
        flash(3)
    else
        flash(2)
    end
end

function Player:addHP(amount)
    self.hp:add(amount, function()
        self:die()
    end)
end

function Player:addMana(amount)
    --sif self.mana > 0
    self.mana = self.mana + amount
    --self.mana:add(amount, function()
    --    self:die()
    --end)
end

function Player:setAttack(attack)
    print("P: attack " .. attack)


    withState("attacks", function(attacks)
        local cooldown = attacks[attack].cooldown
        self.shoot_timer = CooldownTimer(cooldown)
        self.attack = attack

    end)
end