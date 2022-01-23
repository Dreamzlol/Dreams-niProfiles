--------------------------------
-- DreamsRotation Rogue - Combat PvE
-- Version - 1.0.4
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Changed priority of Rupture and Slice And Dice
-- 1.0.2 Added Tricks on Focus Target
-- 1.0.3 Added Auto Target
-- 1.0.4 Added GUI
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotation - Rogue Combat PvE.json",
    {
        type = "title",
        text = "|cffff6060DreamsRotation |cffffffff- Rogue Combat PvE",
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
        text = "\124T" .. select(3, GetSpellInfo(6603)) .. ":26:26\124t Use Auto Target",
        tooltip = "Use the Auto Target feature, if you in combat it will Auto Target the closest enemy around you",
        enabled = true,
        key = "getSetting_AutoTarget",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(57934)) .. ":26:26\124t Use Tricks of the Trade on Focus",
        tooltip = "Use Tricks of the Trade on your focus target, be sure too have your focus on main tank or rogue buddy",
        enabled = true,
        key = "getSetting_TricksOfTheTrade",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(54758)) .. ":26:26\124t Use Engineer Glove Enchant (Hyperspeed Accelerators)",
        tooltip = "Use Engineer Glove Enchant if your target is a boss",
        enabled = true,
        key = "getSetting_HyperspeedAccelerators",
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
        text = "\124T" .. select(3, GetSpellInfo(48638)) .. ":26:26\124t Use Sinister Strike",
        tooltip = "Use Sinister Strike as combopoint builder",
        enabled = true,
        key = "getSetting_SinisterStrike",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(6774)) .. ":26:26\124t Use Slice and Dice at Combopoints",
        tooltip = "Use Slice and Dice at the defined Combopoints",
        enabled = true,
        key = "getSetting_SliceAndDice",
        value = 2,
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48672)) .. ":26:26\124t Use Rupture at Combopoints",
        tooltip = "Use Rupture at the defined Combopoints",
        enabled = true,
        key = "getSetting_Rupture",
        value = 2,
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48668)) .. ":26:26\124t Use Eviscerate at Combopoints",
        tooltip = "Use Eviscerate at the defined Combopoints",
        enabled = true,
        key = "getSetting_Eviscerate",
        value = 5,
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff71C671Cooldown Settings",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(51690)) .. ":26:26\124t Use Killing Spree",
        tooltip = "Use Killing Spree when your target is a boss",
        enabled = true,
        key = "getSetting_KillingSpree",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(13877)) .. ":26:26\124t Use Blade Flurry",
        tooltip = "Use Blade Flurry when your target is a boss",
        enabled = true,
        key = "getSetting_BladeFlurry",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(13750)) .. ":26:26\124t Use Adrenaline Rush",
        tooltip = "Use Adrenaline Rush when your target is a boss",
        enabled = true,
        key = "getSetting_AdrenalineRush",
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
    ni.GUI.AddFrame("DreamsRotation - Rogue Combat PvE", items);
end

local function onunload()
    ni.GUI.DestroyFrame("DreamsRotation - Rogue Combat PvE");
end

local queue = {
    "Pause Rotation",
    "Auto Target",
    "Start Attack",
    "Tricks of the Trade",
    "Hyperspeed Accelerators",
    "Killing Spree",
    "Blade Flurry",
    "Adrenaline Rush",
    "Slice and Dice",
    "Rupture",
    "Eviscerate",
    "Sinister Strike",
}

local abilities = {
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

    ["Start Attack"] = function()
        if ni.unit.exists("target")
        and UnitCanAttack("player", "target")
        and not UnitIsDeadOrGhost("target")
        and UnitAffectingCombat("player")
        and not IsCurrentSpell(6603) then
            ni.spell.cast(6603);
        end
    end,

    ["Tricks of the Trade"] = function()
        local _, enabled = GetSetting("getSetting_TricksOfTheTrade")
        if enabled then
            if ni.spell.valid("focus", "57934", false, true, true)
            and ni.spell.available("Tricks of the Trade")
            and ni.unit.exists("focus") and ni.player.power() < 85 then
                ni.spell.cast("Tricks of the Trade", "focus")
            end
        end
    end,

    ["Hyperspeed Accelerators"] = function()
        local _, enabled = GetSetting("getSetting_HyperspeedAccelerators")
        if enabled then
            if ni.unit.isboss("target")
            and ni.player.slotcd(10) == 0 then
                ni.player.useinventoryitem(10)
            end
        end
    end,

    ["Killing Spree"] = function()
        local _, enabled = GetSetting("getSetting_KillingSpree")
        if enabled then
            if ni.spell.available("Killing Spree")
            and ni.unit.isboss("target")
            and ni.unit.debuff("target", "Rupture", "player")
            and ni.unit.buff("player", "Slice and Dice")
            and ni.player.power() < 60 then
                ni.spell.cast("Killing Spree", "target")
            end
        end
    end,

    ["Blade Flurry"] = function()
        local _, enabled = GetSetting("getSetting_BladeFlurry")
        if enabled then
            if ni.spell.available("Blade Flurry")
            and ni.unit.isboss("target")
            and ni.unit.debuff("target", "Rupture", "player")
            and ni.unit.buff("player", "Slice and Dice") then
                ni.spell.cast("Blade Flurry", "target")
            end
        end
    end,

    ["Adrenaline Rush"] = function()
        local _, enabled = GetSetting("getSetting_AdrenalineRush")
        if enabled then
            if ni.spell.available("Adrenaline Rush")
            and ni.unit.isboss("target")
            and ni.unit.debuff("target", "Rupture", "player")
            and ni.unit.buff("player", "Slice and Dice")
            and ni.player.power() < 40 then
                ni.spell.cast("Adrenaline Rush", "target")
            end
        end
    end,

    ["Slice and Dice"] = function()
        local value, enabled = GetSetting("getSetting_SliceAndDice")
        if enabled then
            if ni.spell.available("Slice and Dice")
            and GetComboPoints("player", "target") >= value
            and ni.unit.buffremaining("player", "Slice and Dice", "player") <= 2 then
                ni.spell.cast("Slice and Dice", "target")
                return true;
            end
        end
    end,

    ["Rupture"] = function()
        local value, enabled = GetSetting("getSetting_Rupture")
        if enabled then
            if ni.spell.available("Rupture")
            and GetComboPoints("player", "target") >= value
            and ni.unit.debuffremaining("target", "Rupture", "player") <= 2 then
                ni.spell.cast("Rupture", "target")
            end
        end
    end,

    ["Eviscerate"] = function()
        local value, enabled = GetSetting("getSetting_Eviscerate")
        if enabled then
            if ni.spell.available("Eviscerate")
            and GetComboPoints("player", "target") == value then
                ni.spell.cast("Eviscerate", "target")
            end
        end
    end,

    ["Sinister Strike"] = function()
        local _, enabled = GetSetting("getSetting_SinisterStrike")
        if enabled then
            if ni.spell.available("Sinister Strike") then
                ni.spell.cast("Sinister Strike", "target")
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotation - Rogue Combat PvE", queue, abilities, onload, onunload)