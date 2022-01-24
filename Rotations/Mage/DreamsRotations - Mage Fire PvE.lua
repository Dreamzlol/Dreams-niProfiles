--------------------------------
-- DreamsRotation - Mage - Fire PvE
-- Version - 1.0.3
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Added Scorch for crit debuff if you have no warlock, Added Fire Blast while moving
-- 1.0.2 Added Auto Target
-- 1.0.3 Added GUI
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
        key = "getSetting_AutoTarget",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(43046)) .. ":26:26\124t Use Molten Armor",
        tooltip = "Use Molten Armor if not active",
        enabled = true,
        key = "getSetting_MoltenArmor",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(43002)) .. ":26:26\124t Use Arcane Brilliance",
        tooltip = "Use Arcane Brilliance if not active",
        enabled = true,
        key = "getSetting_ArcaneBrilliance",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42985)) .. ":26:26\124t Use Conjure Mana Gem",
        tooltip = "Use Conjure Mana Gem if you have no mana sapphire left",
        enabled = true,
        key = "getSetting_ConjureManaGem",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42985)) .. ":26:26\124t Use Mana Sapphire at Mana %",
        tooltip = "Use Mana Sapphire at mana percentage",
        enabled = true,
        value = 85,
        key = "getSetting_ManaSapphire",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(12051)) .. ":26:26\124t Use Evocation at Mana %",
        tooltip = "Use Evocation at mana percentage",
        enabled = true,
        value = 20,
        key = "getSetting_Evocation",
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
        tooltip = "Use Scorch if no crit debuff on boss is active and no warlock applies it",
        enabled = true,
        key = "getSetting_Scorch",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42873)) .. ":26:26\124t Use Fire Blast while moving",
        tooltip = "Use Fire Blast while moving",
        enabled = true,
        key = "getSetting_FireBlast",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(55360)) .. ":26:26\124t Use Living Bomb",
        tooltip = "Use Living Bomb on target",
        enabled = true,
        key = "getSetting_LivingBomb",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42891)) .. ":26:26\124t Use Pyroblast on Hot Streak proc",
        tooltip = "Use Pyroblast on Hot Streak proc",
        enabled = true,
        key = "getSetting_Pyroblast",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(55342)) .. ":26:26\124t Use Mirror Image",
        tooltip = "Use Mirror Image when your target is a boss",
        enabled = true,
        key = "getSetting_MirrorImage",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(11129)) .. ":26:26\124t Use Combustion",
        tooltip = "Use Combustion when your target is a boss",
        enabled = true,
        key = "getSetting_Combustion",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42833)) .. ":26:26\124t Use Fireball",
        tooltip = "Use Fireball",
        enabled = true,
        key = "getSetting_Fireball",
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
    ["Molten Armor"] = function()
        local _, enabled = GetSetting("getSetting_MoltenArmor")
        if enabled then
            if ni.spell.available("Molten Armor")
            and not ni.unit.buff("player", "Molten Armor") then
                ni.vars.debug = false
                ni.spell.cast("Molten Armor", "player")
            end
        end
    end,

    ["Arcane Brilliance"] = function()
        local _, enabled = GetSetting("getSetting_ArcaneBrilliance")
        if enabled then
            if ni.spell.available("Arcane Brilliance")
            and not ni.unit.buff("player", "Arcane Brilliance")
            and ni.player.hasitem(17020) then
                ni.spell.cast("Arcane Brilliance", "player")
            end
        end
    end,

    ["Conjure Mana Gem"] = function()
        local _, enabled = GetSetting("getSetting_ConjureManaGem")
        if enabled then
            if ni.spell.available("Conjure Mana Gem")
            and not ni.player.hasitem(33312)
            and not UnitAffectingCombat("player") then
                ni.spell.cast("Conjure Mana Gem", "player")
            end
        end
    end,

    ["Pause Rotation"] = function()
        if IsMounted()
        or not UnitAffectingCombat("player")
        or UnitIsDeadOrGhost("player") then
            return true;
        end
    end,

    ["Auto Target"] = function()
        local _, enabled = GetSetting("getSetting_AutoTarget")
        if enabled then
            if UnitAffectingCombat("player")
            and ((ni.unit.exists("target")
            and UnitIsDeadOrGhost("target")
            and not UnitCanAttack("player", "target"))
            or not ni.unit.exists("target")) then
                ni.player.runtext("/targetenemy")
            end
        end
	end,

    ["Mana Sapphire"] = function()
        local value, enabled = GetSetting("getSetting_ManaSapphire")
        if enabled then
            if ni.player.itemcd(33312) == 0
            and ni.player.power() < value then
                ni.player.useitem(33312)
            end
        end
    end,

    ["Evocation"] = function()
        local value, enabled = GetSetting("getSetting_Evocation")
        if enabled then
            if ni.spell.available("Evocation")
            and UnitAffectingCombat("player")
            and ni.player.power() < value
            and not ni.unit.ismoving("player") then
                ni.spell.cast("Evocation")
            end
        end
    end,

    ["Scorch"] = function()
        local _, enabled = GetSetting("getSetting_Scorch")
        if enabled then
            if not ni.unit.debuff("target", "Shadow Mastery")
            and not ni.unit.debuff("target", "Improved Scorch")
            and ni.spell.available("Scorch", "target")
            and not ni.unit.ischanneling("player") then
                ni.spell.cast("Scorch")
            end
        end
    end,

    ["Fire Blast"] = function()
        local _, enabled = GetSetting("getSetting_FireBlast")
        if enabled then
            if ni.spell.available("Fire Blast", "target")
            and ni.player.ismoving() then
                ni.spell.cast("Fire Blast", "target")
            end
        end
    end,

    ["Living Bomb"] = function()
        local _, enabled = GetSetting("getSetting_LivingBomb")
        if enabled then
            if ni.spell.available("Living Bomb", "target")
            and not ni.unit.debuff("target", "Living Bomb", "player")
            and not ni.unit.ischanneling("player") then
                ni.spell.cast("Living Bomb", "target")
            end
        end
    end,

    ["Pyroblast"] = function()
        local _, enabled = GetSetting("getSetting_Pyroblast")
        if enabled then
            if ni.spell.available("Pyroblast", "target")
            and ni.unit.buff("player", "Hot Streak")
            and not ni.unit.ischanneling("player") then
                ni.spell.cast("Pyroblast", "target")
            end
        end
    end,

    ["Mirror Image"] = function()
        local _, enabled = GetSetting("getSetting_MirrorImage")
        if enabled then
            if ni.spell.available("Mirror Image")
            and ni.unit.isboss("target")
            and not ni.unit.ischanneling("player") then
                ni.spell.cast("Mirror Image")
            end
        end
    end,

    ["Combustion"] = function()
        local _, enabled = GetSetting("getSetting_Combustion")
        if enabled then
            if ni.spell.available("Combustion")
            and ni.unit.isboss("target")
            and not ni.unit.ischanneling("player") then
                ni.spell.cast("Combustion")
            end
        end
    end,

    ["Fireball"] = function()
        local _, enabled = GetSetting("getSetting_Fireball")
        if enabled then
            if ni.spell.available("Fireball", "target")
            and not ni.unit.ischanneling("player") then
                ni.spell.cast("Fireball", "target")
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Mage Fire PvE", queue, abilities, onload, onunload)