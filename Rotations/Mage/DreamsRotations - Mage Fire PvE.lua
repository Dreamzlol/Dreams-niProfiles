--------------------------------
-- DreamsRotation - Mage - Fire PvE
-- Version - 1.0.5
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
-- 1.0.5 Improved overall rotation
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

-- Spells
local MoltenArmor = GetSpellInfo(43046)
local ArcaneBrilliance = GetSpellInfo(43002)
local ConjureManaGem = GetSpellInfo(42985)
local Evocation = GetSpellInfo(12051)
local MirrorImage = GetSpellInfo(55342)
local Scorch = GetSpellInfo(42859)
local FireBlast = GetSpellInfo(42873)
local LivingBomb = GetSpellInfo(55360)
local Pyroblast = GetSpellInfo(42891)
local Combustion = GetSpellInfo(11129)
local Fireball = GetSpellInfo(42833)
local ImprovedScorch = GetSpellInfo(22959)
local ShadowMastery = GetSpellInfo(17800)
local WintersChill = GetSpellInfo(12579)
local HotStreak = GetSpellInfo(48108)

-- Items
local ManaSapphire = GetItemInfo(33312)
local ArcanePowder = GetItemInfo(17020)
local Food = GetSpellInfo(45548)
local Drink = GetSpellInfo(57073)

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
        local _, enabled = GetSetting("moltenarmor")
        if enabled then
            if ni.spell.available(MoltenArmor)
            and not ni.unit.buff("player", MoltenArmor) then
                ni.spell.cast(MoltenArmor)
                return true;
            end
        end
    end,

    ["Arcane Brilliance"] = function()
        local _, enabled = GetSetting("arcanebrilliance")
        if enabled then
            if ni.spell.available(ArcaneBrilliance)
            and not ni.unit.buff("player", ArcaneBrilliance)
            and ni.player.hasitem(ArcanePowder) then
                ni.spell.cast(ArcaneBrilliance)
                return true;
            end
        end
    end,

    ["Conjure Mana Gem"] = function()
        local _, enabled = GetSetting("conjuremanagem")
        if enabled then
            if ni.spell.available(ConjureManaGem)
            and not ni.player.hasitem(ManaSapphire)
            and not ni.player.ismoving("player")
            and not UnitAffectingCombat("player") then
                ni.spell.cast(ConjureManaGem)
                return true;
            end
        end
    end,

    ["Pause Rotation"] = function()
        if IsMounted()
        or UnitIsDeadOrGhost("player")
        or UnitIsDeadOrGhost("target")
        or UnitUsingVehicle("player")
        or UnitInVehicle("player")
        or not UnitAffectingCombat("player")
        or ni.unit.ischanneling("player")
        or ni.unit.iscasting("player")
        or ni.unit.buff("player", Food)
        or ni.unit.buff("player", Drink) then
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

    ["Mana Sapphire"] = function()
        local value, enabled = GetSetting("manasapphire")
        if enabled then
            if ni.player.itemcd(ManaSapphire) == 0
            and ni.player.power() < value then
                ni.player.useitem(ManaSapphire)
                return true;
            end
        end
    end,

    ["Evocation"] = function()
        local value, enabled = GetSetting("evocation")
        if enabled then
            if ni.spell.available(Evocation)
            and ni.player.power() < value
            and not ni.unit.ismoving("player") then
                ni.spell.cast(Evocation)
                return true;
            end
        end
    end,

    ["Scorch"] = function()
        local _, enabled = GetSetting("scorch")
        if enabled then
            if ni.spell.available(Scorch)
            and ni.spell.valid("target", Scorch, true, true)
            and not ni.unit.debuff("target", ImprovedScorch)
            and not ni.unit.debuff("target", ShadowMastery)
            and not ni.unit.debuff("target", WintersChill)
            and not ni.unit.ismoving("player") then
                ni.spell.cast(Scorch, "target")
                return true;
            end
        end
    end,

    ["Fire Blast"] = function()
        local _, enabled = GetSetting("fireblast")
        if enabled then
            if ni.spell.available(FireBlast)
            and ni.spell.valid("target", FireBlast, true, true)
            and ni.unit.ismoving("player") then
                ni.spell.cast(FireBlast, "target")
                return true;
            end
        end
    end,

    ["Living Bomb"] = function()
        local _, enabled = GetSetting("livingbomb")
        if enabled then
            if ni.spell.available(LivingBomb)
            and ni.spell.valid("target", LivingBomb, true, true)
            and not ni.unit.debuff("target", LivingBomb, "player") then
                ni.spell.cast(LivingBomb, "target")
                return true;
            end
        end
    end,

    ["Pyroblast"] = function()
        local _, enabled = GetSetting("pyroblast")
        if enabled then
            if ni.spell.available(Pyroblast)
            and ni.spell.valid("target", Pyroblast, true, true)
            and ni.unit.buff("player", HotStreak) then
                ni.spell.cast(Pyroblast, "target")
                return true;
            end
        end
    end,

    ["Mirror Image"] = function()
        local _, enabled = GetSetting("mirrorimage")
        if enabled then
            if ni.spell.available(MirrorImage)
            and ni.unit.isboss("target") then
                ni.spell.cast(MirrorImage)
                return true;
            end
        end
    end,

    ["Combustion"] = function()
        local _, enabled = GetSetting("combustion")
        if enabled then
            if ni.spell.available(Combustion)
            and ni.unit.isboss("target") then
                ni.spell.cast(Combustion)
                return true;
            end
        end
    end,

    ["Fireball"] = function()
        local _, enabled = GetSetting("fireball")
        if enabled then
            if ni.spell.available(Fireball)
            and ni.spell.valid("target", Fireball, true, true)
            and not ni.unit.ismoving("player") then
                ni.spell.cast(Fireball, "target")
                return true;
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Mage Fire PvE", queue, abilities, onload, onunload)
