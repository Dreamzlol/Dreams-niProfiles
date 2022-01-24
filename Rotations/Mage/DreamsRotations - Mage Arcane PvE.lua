--------------------------------
-- DreamsRotation - Mage Arcane PvE
-- Version - 1.0.2
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Added Auto Target
-- 1.0.2 Added GUI
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotations - Mage Arcane PvE.json",
    {
        type = "title",
        text = "|cffff00ffDreamsRotation |cffffffff- Arcane Mage PvE",
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
        text = "\124T" .. select(3, GetSpellInfo(42897)) .. ":26:26\124t Use Arcane Blast",
        tooltip = "Use Arcane Blast",
        enabled = true,
        key = "getSetting_ArcaneBlast",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(12472)) .. ":26:26\124t Use Icy Veins at Arcane Blast stacks",
        tooltip = "Use Icy Veins if your target is a boss and has the amount of the defined Arcane Blast stacks",
        enabled = true,
        value = 3,
        key = "getSetting_IcyVeins",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(55342)) .. ":26:26\124t Use Mirror Image at Arcane Blast stacks",
        tooltip = "Use Mirror Image if your target is a boss and has the amount of the defined Arcane Blast stacks",
        enabled = true,
        value = 3,
        key = "getSetting_MirrorImage",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(12042)) .. ":26:26\124t Use Arcane Power at Arcane Blast stacks",
        tooltip = "Use Arcane Power if your target is a boss and has the amount of the defined Arcane Blast stacks",
        enabled = true,
        value = 3,
        key = "getSetting_ArcanePower",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(12043)) .. ":26:26\124t Use Presence of Mind at Arcane Blast stacks",
        tooltip = "Use Presence of Mind if your target is a boss and has the amount of the defined Arcane Blast stacks",
        enabled = true,
        value = 2,
        key = "getSetting_PresenceOfMind",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(42846)) .. ":26:26\124t Use Arcane Missiles at Arcane Blast stacks",
        tooltip = "Use Arcane Missiles and has the amount of the defined Arcane Blast stacks",
        enabled = true,
        value = 4,
        key = "getSetting_ArcaneMissiles",
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
    ni.GUI.AddFrame("DreamsRotations - Mage Arcane PvE", items);
end

local function onunload()
    ni.GUI.DestroyFrame("DreamsRotations - Mage Arcane PvE");
end

local queue = {
    "Molten Armor",
    "Arcane Brilliance",
    "Conjure Mana Gem",
    "Pause Rotation",
    "Auto Target",
    "Mana Sapphire",
    "Evocation",
    "Icy Veins",
    "Mirror Image",
    "Arcane Power",
    "Presence of Mind",
    "Arcane Missiles",
    "Arcane Blast"
}

local abilities = {
    ["Molten Armor"] = function()
        local _, enabled = GetSetting("getSetting_MoltenArmor")
        if enabled then
            if ni.spell.available("Molten Armor")
            and not ni.unit.buff("player", "Molten Armor") then
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
                ni.spell.cast("Conjure Mana Gem")
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
            and ni.player.power() < value
            and not ni.unit.ischanneling("player") then
                ni.player.useitem(33312)
            end
        end
    end,

    ["Evocation"] = function()
        local _, enabled = GetSetting("getSetting_Evocation")
        if enabled then
            if ni.spell.available("Evocation")
            and UnitAffectingCombat("player")
            and ni.player.power() < 20
            and not ni.player.movingfor(3) then
                ni.spell.cast("Evocation")
            end
        end
    end,

    ["Mirror Image"] = function()
        local value, enabled = GetSetting("getSetting_MirrorImage")
        if enabled then
            if ni.spell.available("Mirror Image")
            and ni.unit.isboss("target")
            and not ni.unit.ischanneling("player")
            and ni.unit.debuffstacks("player", 36032) >= value then
                ni.spell.cast("Mirror Image")
            end
        end
    end,

    ["Icy Veins"] = function()
        local value, enabled = GetSetting("getSetting_IcyVeins")
        if enabled then
            if ni.spell.available("Icy Veins")
            and ni.unit.isboss("target")
            and not ni.unit.ischanneling("player")
            and ni.unit.debuffstacks("player", 36032) >= value then
                ni.spell.cast("Icy Veins")
            end
        end
    end,

    ["Arcane Power"] = function()
        local value, enabled = GetSetting("getSetting_ArcanePower")
        if enabled then
            if ni.spell.available("Arcane Power")
            and ni.unit.isboss("target")
            and not ni.unit.ischanneling("player")
            and ni.unit.debuffstacks("player", 36032) >= value then
                ni.spell.cast("Arcane Power")
            end
        end
    end,

    ["Presence of Mind"] = function()
        local value, enabled = GetSetting("getSetting_PresenceOfMind")
        if enabled then
            if ni.spell.available("Presence of Mind")
            and ni.unit.isboss("target")
            and not ni.unit.ischanneling("player")
            and ni.unit.debuffstacks("player", 36032) >= value then
                ni.spell.cast("Presence of Mind", "target")
            end
        end
    end,

    ["Arcane Missiles"] = function()
        local value, enabled = GetSetting("getSetting_ArcaneMissiles")
        if enabled then
            if ni.spell.available("Arcane Missiles")
            and ni.unit.debuffstacks("player", 36032) == value
            and ni.unit.buff("player", "Missile Barrage")
            and not ni.unit.ischanneling("player") then
                ni.spell.cast("Arcane Missiles", "target")
            end
        end
    end,

    ["Arcane Blast"] = function()
        local _, enabled = GetSetting("getSetting_ArcaneBlast")
        if enabled then
            if ni.spell.available("Arcane Blast")
            and not ni.unit.ischanneling("player") then
                ni.spell.cast("Arcane Blast", "target")
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Mage Arcane PvE", queue, abilities, onload, onunload)