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
-- 1.0.6 Save someone eyes cyka blyat... (rly dude why not?) -- Kaylemine
--------------------------------
local ni        = ...
local ni.spell  = SP
local ni.unit   = UN
local ni.player = PL
local TNE       = ni.backend.GetFunction("TargetNearestEnemy")

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


SB = {
    MoltenArmor      = 43046,
    ArcaneBrilliance = 43002,
    ConjureManaGem   = 42985,
    Evocation        = 12051,
    MirrorImage      = 55342,
    Scorch           = 42859,
    FireBlast        = 42873,
    LivingBomb       = 55360,
    Pyroblast        = 42891,
    Combustion       = 11129,
    Fireball         = 42833,
    ImprovedScorch   = 22959,
    ShadowMastery    = 17800,
    WintersChill     = 12579,
    HotStreak        = 48108,
    Food             = 45548,
    Drink            = 57073
}
-- Items
local ManaSapphire = GetItemInfo(33312)
local ArcanePowder = GetItemInfo(17020)

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
        if SP.available(SB.MoltenArmor)
        and not UN.buff("player", SB.MoltenArmor) then
            SP.cast(SB.MoltenArmor)
            return true;
        end
    end
    end,

    ["Arcane Brilliance"] = function()
    local _, enabled = GetSetting("arcanebrilliance")
    if enabled then
        if SP.available(SB.ArcaneBrilliance)
        and not UN.buff("player", SB.ArcaneBrilliance)
        and PL.hasitem(ArcanePowder) then
            SP.cast(SB.ArcaneBrilliance)
            return true;
        end
    end
    end,

    ["Conjure Mana Gem"] = function()
    local _, enabled = GetSetting("conjuremanagem")
    if enabled then
        if SP.available(SB.ConjureManaGem)
        and not PL.hasitem(ManaSapphire)
        and not PL.ismoving("player")
        and not UnitAffectingCombat("player") then
            SP.cast(SB.ConjureManaGem)
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
    or UN.ischanneling("player")
    or UN.iscasting("player")
    or UN.buff("player", SB.Food)
    or UN.buff("player", SB.Drink) then
        return true;
    end
    end,

    ["Auto Target"] = function()
    local _, enabled = GetSetting("autotarget")
    if enabled then
        if UnitAffectingCombat("player")
        and ((UN.exists("target")
        and UnitIsDeadOrGhost("target")
        and not UnitCanAttack("player", "target"))
        or not UN.exists("target")) then
            PL.runtext("/targetenemy") -- <-- probably unsafe i think
			-- TNE();  <-- test me on 3.3.5 cuz idk is that exist on 335
            return true;
        end
    end
    end,

    ["Mana Sapphire"] = function()
    local value, enabled = GetSetting("manasapphire")
    if enabled then
        if PL.itemcd(ManaSapphire) == 0
        and PL.power() < value then
            PL.useitem(ManaSapphire)
            return true;
        end
    end
    end,

    ["Evocation"] = function()
    local value, enabled = GetSetting("evocation")
    if enabled then
        if SP.available(SB.Evocation)
        and PL.power() < value
        and not UN.ismoving("player") then
            SP.cast(SB.Evocation)
            return true;
        end
    end
    end,

    ["Scorch"] = function()
    local _, enabled = GetSetting("scorch")
    if enabled then
        if SP.available(SB.Scorch)
        and SP.valid("target", SB.Scorch, true, true)
        and not UN.debuff("target", SB.ImprovedScorch)
        and not UN.debuff("target", SB.ShadowMastery)
        and not UN.debuff("target", SB.WintersChill)
        and not UN.ismoving("player") then
            SP.cast(SB.Scorch, "target")
            return true;
        end
    end
    end,

    ["Fire Blast"] = function()
    local _, enabled = GetSetting("fireblast")
    if enabled then
        if SP.available(SB.FireBlast)
        and SP.valid("target", SB.FireBlast, true, true)
        and UN.ismoving("player") then
            SP.cast(SB.FireBlast, "target")
            return true;
        end
    end
    end,

    ["Living Bomb"] = function()
    local _, enabled = GetSetting("livingbomb")
    if enabled then
        if SP.available(SB.LivingBomb)
        and SP.valid("target", SB.LivingBomb, true, true)
        and not UN.debuff("target", SB.LivingBomb, "player") then
            SP.cast(SB.LivingBomb, "target")
            return true;
        end
    end
    end,

    ["Pyroblast"] = function()
    local _, enabled = GetSetting("pyroblast")
    if enabled then
        if SP.available(SB.Pyroblast)
        and SP.valid("target", SB.Pyroblast, true, true)
        and UN.buff("player", SB.HotStreak) then
            SP.cast(SB.Pyroblast, "target")
            return true;
        end
    end
    end,

    ["Mirror Image"] = function()
    local _, enabled = GetSetting("mirrorimage")
    if enabled then
        if SP.available(SB.MirrorImage)
        and UN.isboss("target") then
            SP.cast(SB.MirrorImage)
            return true;
        end
    end
    end,

    ["Combustion"] = function()
    local _, enabled = GetSetting("combustion")
    if enabled then
        if SP.available(SB.Combustion)
        and UN.isboss("target") then
            SP.cast(SB.Combustion)
            return true;
        end
    end
    end,

    ["Fireball"] = function()
    local _, enabled = GetSetting("fireball")
    if enabled then
        if SP.available(SB.Fireball)
        and SP.valid("target", SB.Fireball, true, true)
        and not UN.ismoving("player") then
            SP.cast(SB.Fireball, "target")
            return true;
        end
    end
    end,
	
}
ni.bootstrap.profile("DreamsRotations - Mage Fire PvE", queue, abilities, onload, onunload)
