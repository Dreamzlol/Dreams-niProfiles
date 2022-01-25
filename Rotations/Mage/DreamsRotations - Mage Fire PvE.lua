--------------------------------
-- DreamsRotation - Mage - Fire PvE
-- Version - 1.0.4
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Added Scorch for crit debuff if you have no warlock, Added Fire Blast while moving
-- 1.0.2 Added Auto Target
-- 1.0.3 Added GUI
-- 1.0.4 Added Winters Chill Debuff
--       More checks for casts and pause function, no spamming or clipping of casts anymore
--       Use CastSpellByID() instead of CastSpellByName() for other localizations
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotations - Fire Mage PvE.json",
    {
        type = "title",
        text = "|cffff00ffDreamsRotations |cffffffff- Fire Mage PvE",
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff71C671Main Settings",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(1953)) .. ":26:26\124t Use Auto Target",
        tooltip = "Use the Auto Target feature if you in combat it will Auto Target the closest enemy around you",
        enabled = true,
        key = "autotarget",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(43046)) .. ":26:26\124t Use Molten Armor",
        tooltip = "Use Molten Armor if not active",
        enabled = true,
        key = "moltenarmor",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(43002)) .. ":26:26\124t Use Arcane Brilliance",
        tooltip = "Use Arcane Brilliance if not active",
        enabled = true,
        key = "arcanebrilliance",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42985)) .. ":26:26\124t Use Conjure Mana Gem",
        tooltip = "Use Conjure Mana Gem if you have no mana sapphire left and out of combat",
        enabled = true,
        key = "conjuremanagem",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42985)) .. ":26:26\124t Use Mana Sapphire at Mana %",
        tooltip = "Use Mana Sapphire at mana percentage",
        enabled = true,
        value = 85,
        key = "manasapphire",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(12051)) .. ":26:26\124t Use Evocation at Mana %",
        tooltip = "Use Evocation at mana percentage",
        enabled = true,
        value = 20,
        key = "evocation",
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff71C671Rotation Settings",
    },
    {
        type = "entry",
        text = "        \124T" .. select(3, GetSpellInfo(42859)) .. ":26:26\124t Use Scorch if no crit debuff on target",
        tooltip = "Use Scorch if no crit debuff is on the boss and no warlock or frost mage applies it",
        enabled = true,
        key = "scorch",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42873)) .. ":26:26\124t Use Fire Blast while moving",
        tooltip = "Use Fire Blast while moving",
        enabled = true,
        key = "fireblast",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(55360)) .. ":26:26\124t Use Living Bomb",
        tooltip = "Use Living Bomb on target",
        enabled = true,
        key = "livingbomb",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42891)) .. ":26:26\124t Use Pyroblast on Hot Streak proc",
        tooltip = "Use Pyroblast on Hot Streak proc",
        enabled = true,
        key = "pyroblast",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(55342)) .. ":26:26\124t Use Mirror Image",
        tooltip = "Use Mirror Image when your target is a boss",
        enabled = true,
        key = "mirrorimage",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(11129)) .. ":26:26\124t Use Combustion",
        tooltip = "Use Combustion when your target is a boss",
        enabled = true,
        key = "combustion",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42833)) .. ":26:26\124t Use Fireball",
        tooltip = "Use Fireball",
        enabled = true,
        key = "fireball",
    },
}

local function GetSetting(name)
    for k, v in ipairs(items) do
        if v.type == "entry"
        and v.key ~= nil
        and v.key == name then
            return v.value, v.enabled
        end
    end
end

local function onload()
    ni.GUI.AddFrame("DreamsRotations - Mage Fire PvE", items);
end

local function onunload()
    ni.GUI.DestroyFrame("DreamsRotations - Mage Fire PvE");
end

local queue = {
    "Molten Armor",
    "Arcane Brilliance",
    "Conjure Mana Gem",
    "Pause Rotation",
    "Auto Target",
    "Mana Sapphire",
    "Evocation",
    "Scorch",
    "Fire Blast",
    "Living Bomb",
    "Pyroblast",
    "Mirror Image",
    "Combustion",
    "Fireball",
}

local abilities = {
    --------------------------------
    -- Molten Armor - 43046
    --------------------------------
    ["Molten Armor"] = function()
        local _, enabled = GetSetting("moltenarmor")
        if enabled then
            if ni.spell.available(43046)
            and not ni.unit.buff("player", 43046) then
                ni.spell.cast(43046)
                return true;
                
            end
        end
    end,

    --------------------------------
    -- Arcane Brilliance - 43002
    -- Arcane Powder - 17020
    --------------------------------
    ["Arcane Brilliance"] = function()
        local _, enabled = GetSetting("arcanebrilliance")
        if enabled then
            if ni.spell.available(43002)
            and not ni.unit.buff("player", 43002)
            and ni.player.hasitem(17020) then
                ni.spell.cast(43002)
                return true;
            end
        end
    end,

    --------------------------------
    -- Conjure Mana Gem - 42985
    -- Mana Sapphire - 33312
    --------------------------------
    ["Conjure Mana Gem"] = function()
        local _, enabled = GetSetting("conjuremanagem")
        if enabled then
            if ni.spell.available(42985)
            and not ni.player.hasitem(33312)
            and not ni.player.ismoving("player")
            and not UnitAffectingCombat("player") then
                ni.spell.cast(42985)
                return true;
            end
        end
    end,

    --------------------------------
    -- Food - 45548
    -- Drink - 57073
    --------------------------------
    ["Pause Rotation"] = function()
        if IsMounted()
        or UnitIsDeadOrGhost("player")
        or UnitIsDeadOrGhost("target")
        or UnitUsingVehicle("player")
        or UnitInVehicle("player")
        or not UnitAffectingCombat("player")
        or ni.unit.ischanneling("player")
        or ni.unit.iscasting("player")
        or ni.unit.buff("player", 45548)
        or ni.unit.buff("player", 57073) then
            return true;
        end
    end,

    ["Auto Target"] = function()
        local _, enabled = GetSetting("autotarget")
        if enabled then
            if UnitAffectingCombat("player")
            and ((ni.unit.exists("target")
            and UnitIsDeadOrGhost("target")
            and not UnitCanAttack("player", "target"))
            or not ni.unit.exists("target")) then
                ni.player.runtext("/targetenemy")
                return true;
            end
        end
	end,

    --------------------------------
    -- Mana Sapphire - 33312
    --------------------------------
    ["Mana Sapphire"] = function()
        local value, enabled = GetSetting("manasapphire")
        if enabled then
            if ni.player.itemcd(33312) == 0
            and ni.player.power() < value then
                ni.player.useitem(33312)
                return true;
            end
        end
    end,

    --------------------------------
    -- Evocation - 12051
    --------------------------------
    ["Evocation"] = function()
        local value, enabled = GetSetting("evocation")
        if enabled then
            if ni.spell.available(12051)
            and ni.player.power() < value
            and not ni.unit.ismoving("player") then
                ni.spell.cast(12051)
                return true;
            end
        end
    end,

    --------------------------------
    -- Scorch - 42859
    -- Improved Scorch - 22959
    -- Shadow Mastery - 17800
    -- Winters Chill - 12579
    --------------------------------
    ["Scorch"] = function()
        local _, enabled = GetSetting("scorch")
        if enabled then
            if ni.spell.available(42859)
            and ni.spell.valid("target", 42859, true, true)
            and not ni.unit.debuff("target", 22959)
            and not ni.unit.debuff("target", 17800)
            and not ni.unit.debuff("target", 12579)
            and not ni.unit.ismoving("player") then
                ni.spell.cast(42859, "target")
                return true;
            end
        end
    end,

    --------------------------------
    -- Fire Blast - 42873
    --------------------------------
    ["Fire Blast"] = function()
        local _, enabled = GetSetting("fireblast")
        if enabled then
            if ni.spell.available(42873)
            and ni.spell.valid("target", 42873, true, true)
            and ni.unit.ismoving("player") then
                ni.spell.cast(42873, "target")
                return true;
            end
        end
    end,

    --------------------------------
    -- Living Bomb - 55360
    --------------------------------
    ["Living Bomb"] = function()
        local _, enabled = GetSetting("livingbomb")
        if enabled then
            if ni.spell.available(55360)
            and ni.spell.valid("target", 55360, true, true)
            and not ni.unit.debuff("target", 55360, "player") then
                ni.spell.cast(55360, "target")
                return true;
            end
        end
    end,

    --------------------------------
    -- Pyroblast - 42891
    -- Hot Streak - 48108
    --------------------------------
    ["Pyroblast"] = function()
        local _, enabled = GetSetting("pyroblast")
        if enabled then
            if ni.spell.available(42891)
            and ni.spell.valid("target", 42891, true, true)
            and ni.unit.buff("player", 48108) then
                ni.spell.cast(42891, "target")
                return true;
            end
        end
    end,

    --------------------------------
    -- Mirror Image - 55342
    --------------------------------
    ["Mirror Image"] = function()
        local _, enabled = GetSetting("mirrorimage")
        if enabled then
            if ni.spell.available(55342)
            and ni.unit.isboss("target") then
                ni.spell.cast(55342)
                return true;
            end
        end
    end,

    --------------------------------
    -- Combustion - 11129
    --------------------------------
    ["Combustion"] = function()
        local _, enabled = GetSetting("combustion")
        if enabled then
            if ni.spell.available(11129)
            and ni.unit.isboss("target") then
                ni.spell.cast(11129)
                return true;
            end
        end
    end,

    --------------------------------
    -- Fireball - 42833
    --------------------------------
    ["Fireball"] = function()
        local _, enabled = GetSetting("fireball")
        if enabled then
            if ni.spell.available(42833)
            and ni.spell.valid("target", 42833, true, true)
            and not ni.unit.ismoving("player") then
                ni.spell.cast(42833, "target")
                return true;
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Mage Fire PvE", queue, abilities, onload, onunload)