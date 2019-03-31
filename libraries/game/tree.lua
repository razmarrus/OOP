tree = {}


tree[1] = {x = 485, y = 270, r= 25,  stats = { }, links = {2}}  --[[stats = {
    '4% Increased HP', 'hp_multiplier', 0.04, 
    '4% Increased Ammo', 'ammo_multiplier', 0.04
    }]]--
tree[2] = {x = 550, y = 270, r = 12, stats = {'5% Increased HP', 'hp_multiplier', 0.05}, links = {1, 3}}
tree[3] = {x = 600, y = 270, r = 12, stats = {'5% Increased HP', 'hp_multiplier', 0.05} , links = {2,4} }
tree[4] = {x = 650, y = 270, r = 12, stats = {'5% Increased HP', 'hp_multiplier', 0.05} , links = {3,5} }
tree[5] = {x = 700, y = 270, r = 12, stats = {'5% Increased HP', 'hp_multiplier', 0.05} , links = {4,6} }
tree[6] = {x = 780, y = 300, r = 20, stats = {'15% Increased HP', 'hp_multiplier', 0.15} , links = {5} }

tree[7] = {x = 420, y = 270, r = 12, stats = {'5% Increased Mana', 'mana_multiplier', 0.05}, links = {1, 8}}
tree[8] = {x = 370, y = 270, r = 12, stats = {'5% Increased Mana', 'mana_multiplier', 0.05} , links = {7,9} }
tree[9] = {x = 320, y = 270, r = 12, stats = {'5% Increased Mana', 'mana_multiplier', 0.05} , links = {8,10} }
tree[10] = {x = 270, y = 270, r = 12, stats = {'5% Increased Mana', 'mana_multiplier', 0.05} , links = {9,11} }
tree[11] = {x = 190, y = 240, r = 20, stats = {'15% Increased Mana', 'mana_multiplier', 0.15} , links = {10} }


tree[12] = {x = 340, y = 350, r = 12, stats = {'5% Increased Mana', 'mana_multiplier', 0.05}, links = {1, 13}}
tree[13] = {x = 485, y = 410, r = 20, stats = {'15% Increased HP', 'hp_multiplier', 0.15} , links = {12,14} }
tree[14] = {x = 630, y = 350, r = 12, stats = {'5% Increased Mana', 'mana_multiplier', 0.05} , links = {13} }

tree[15] = {x = 340, y = 200, r = 12, stats = {'0.5 for shield', 'shield_addition', 0.5} , links = {1,16} }
tree[16] = {x = 485, y = 140, r = 20, stats = {'1 for shield', 'shield_addition', 1} , links = {15, 17} }
tree[17] = {x = 630, y = 200, r = 12, stats = {'0.5 for shield', 'shield_addition', 0.5}, links = {16}}




