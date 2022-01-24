--------------------------------
-- DreamsRotation Rogue - Combat PvE
-- Version - 1.0.4
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Changed priority of Rupture and Slice And Dice (High Rupture priority)
-- 1.0.2 Added Tricks of the Trade on Focus Target
-- 1.0.3 Added Auto Target
-- 1.0.4 Added GUI
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotations - Rogue Combat PvE.json",
    {
        type = "title",
        text = "|cffff00ffDreamsRotations |cffffffff- Rogue Combat PvE",
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
        text = "\124T" .. select(3, GetSpellInfo(2764)) .. ":26:26\124t Use Auto Target",
        tooltip = "Use the Auto Target feature if you in combat it will Auto Target the closest enemy around you",
        enabled = true,
        key = "getSetting_AutoTarget",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(57934)) .. ":26:26\124t Use Tricks of the Trade on Focus Target",
        tooltip = "Use Tricks of the Trade on your focus target be sure too have your focus on main tank or on a other rogue",
        enabled = true,
        key = "getSetting_TricksOfTheTrade",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(54758)) ..
            ":26:26\124t Use Engineer Glove Enchant (Hyperspeed Accelerators)",
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
        text = "\124T" .. select(3, GetSpellInfo(6774)) .. ":26:26\124t Use Slice and Dice at or more Combopoints",
        tooltip = "Use Slice and Dice if you have the amount or more than the defined combopoints",
        enabled = true,
        value = 2,
        key = "getSetting_SliceAndDice",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48672)) .. ":26:26\124t Use Rupture at or more Combopoints",
        tooltip = "Use Rupture if you have the amount or more than the defined combopoints",
        enabled = true,
        value = 2,
        key = "getSetting_Rupture",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48668)) .. ":26:26\124t Use Eviscerate at Combopoints",
        tooltip = "Use Eviscerate if you have the amount of the defined combopoints",
        enabled = true,
        value = 5,
        key = "getSetting_Eviscerate",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(51690)) .. ":26:26\124t Use Killing Spree",
        tooltip = "Use Killing Spree when your target is a boss",
        key = "getSetting_KillingSpree",
        enabled = true,
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
    ni.GUI.AddFrame("DreamsRotations - Rogue Combat PvE", items);
end

local function onunload()
    ni.GUI.DestroyFrame("DreamsRotations - Rogue Combat PvE");
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
                return true;
            end
        end
	end,

    ["Start Attack"] = function()
        if ni.unit.exists("target")
        and UnitCanAttack("player", "target")
        and not UnitIsDeadOrGhost("target")
        and UnitAffectingCombat("player")
        and not IsCurrentSpell(6603) then
            ni.spell.cast(6603)
            return true;
        end
    end,

    ["Tricks of the Trade"] = function()
        local _, enabled = GetSetting("getSetting_TricksOfTheTrade")
        if enabled then
            if ni.spell.valid("focus", "57934", false, true, true)
            and ni.spell.available("Tricks of the Trade")
            and ni.unit.exists("focus") and ni.player.power() < 85 then
                ni.spell.cast("Tricks of the Trade", "focus")
                return true;
            end
        end
    end,

    ["Hyperspeed Accelerators"] = function()
        local _, enabled = GetSetting("getSetting_HyperspeedAccelerators")
        if enabled then
            if ni.unit.isboss("target")
            and ni.player.slotcd(10) == 0 then
                ni.player.useinventoryitem(10)
                return true;
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
                return true;
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
                return true;
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
                return true;
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
                return true;
            end
        end
    end,

    ["Eviscerate"] = function()
        local value, enabled = GetSetting("getSetting_Eviscerate")
        if enabled then
            if ni.spell.available("Eviscerate")
            and GetComboPoints("player", "target") == value then
                ni.spell.cast("Eviscerate", "target")
                return true;
            end
        end
    end,

    ["Sinister Strike"] = function()
        local _, enabled = GetSetting("getSetting_SinisterStrike")
        if enabled then
            if ni.spell.available("Sinister Strike") then
                ni.spell.cast("Sinister Strike", "target")
                return true;
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Rogue Combat PvE", queue, abilities, onload, onunload)
