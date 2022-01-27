--------------------------------
-- DreamsRotation - Rogue Combat PvE
-- Version - 1.0.6
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Changed priority of Rupture and Slice And Dice (High Rupture priority)
-- 1.0.2 Added Tricks of the Trade on Focus Target
-- 1.0.3 Added Auto Target
-- 1.0.4 Added GUI
-- 1.0.5 Improved overall rotation
-- 1.0.6 Added Poisons
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
        key = "autotarget",
    },
    {
        type = "entry",
        text = "\124T" .. GetItemIcon(43233) .. ":26:26\124t Use Poisons on Weapons",
        tooltip = "Use Instant Poison on Mainhand and Deadly Poison on Offhand",
        enabled = true,
        key = "poisons",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(57934)) .. ":26:26\124t Use Tricks of the Trade on Focus Target",
        tooltip = "Use Tricks of the Trade on your focus target be sure too have your focus on main tank or on a other rogue",
        enabled = true,
        key = "tricksofthetrade",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(54758)) .. ":26:26\124t Use Engineer Glove Enchant (Hyperspeed Accelerators)",
        tooltip = "Use Engineer Glove Enchant if your target is a boss",
        enabled = true,
        key = "hyperspeedaccelerators",
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
        key = "sinisterstrike",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(6774)) .. ":26:26\124t Use Slice and Dice at or more Combopoints",
        tooltip = "Use Slice and Dice if you have the amount or more than the defined combopoints",
        enabled = true,
        value = 2,
        key = "sliceanddice",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48672)) .. ":26:26\124t Use Rupture at or more Combopoints",
        tooltip = "Use Rupture if you have the amount or more than the defined combopoints",
        enabled = true,
        value = 2,
        key = "rupture",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48668)) .. ":26:26\124t Use Eviscerate at Combopoints",
        tooltip = "Use Eviscerate if you have the amount of the defined combopoints",
        enabled = true,
        value = 5,
        key = "eviscerate",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(51690)) .. ":26:26\124t Use Killing Spree",
        tooltip = "Use Killing Spree when your target is a boss",
        key = "killingspree",
        enabled = true,
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(13877)) .. ":26:26\124t Use Blade Flurry",
        tooltip = "Use Blade Flurry when your target is a boss",
        enabled = true,
        key = "bladeflurry",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(13750)) .. ":26:26\124t Use Adrenaline Rush",
        tooltip = "Use Adrenaline Rush when your target is a boss",
        enabled = true,
        key = "adrenalinerush",
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

-- Spells
local StartAttack = GetSpellInfo(6603)
local TricksOfTheTrade = GetSpellInfo(57934)
local KillingSpree = GetSpellInfo(51690)
local BladeFlurry = GetSpellInfo(13877)
local AdrenalineRush = GetSpellInfo(13750)
local SliceAndDice = GetSpellInfo(6774)
local Rupture = GetSpellInfo(48672)
local Eviscerate = GetSpellInfo(48668)
local SinisterStrike = GetSpellInfo(48638)

-- Items
local Food = GetSpellInfo(45548)
local Drink = GetSpellInfo(57073)
local InstantPoison = GetItemInfo(43231)
local DeadlyPoison = GetItemInfo(43233)


local queue = {
    "Poisons",
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
    ["Poisons"] = function()
        local _, enabled = GetSetting("poisons")
        if enabled then
            local mainHand,_,_,offHand,_,_ = GetWeaponEnchantInfo()

            if PoisonCastTime and GetTime() - PoisonCastTime > 4 then
                PoisonCastTime = nil
            end

            if not UnitAffectingCombat("player")
            and not PoisonCastTime then
                PoisonCastTime = GetTime()

                if not mainHand
                and ni.player.hasitem(InstantPoison) then
                    ni.player.useitem(InstantPoison)
                    ni.player.useinventoryitem(16)
                end

                if not offHand
                and ni.player.hasitem(DeadlyPoison) then
                    ni.player.useitem(DeadlyPoison)
                    ni.player.useinventoryitem(17)
                end
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

    ["Start Attack"] = function()
        if ni.unit.exists("target")
        and UnitCanAttack("player", "target")
        and not UnitIsDeadOrGhost("target")
        and UnitAffectingCombat("player")
        and not IsCurrentSpell(StartAttack) then
            ni.spell.cast(StartAttack)
            return true;
        end
    end,

    ["Tricks of the Trade"] = function()
        local _, enabled = GetSetting("tricksofthetrade")
        if enabled then
            if ni.spell.available(TricksOfTheTrade)
            and ni.spell.valid("focus", TricksOfTheTrade, false, true, true)
            and ni.unit.exists("focus")
            and ni.player.power() < 85 then
                ni.spell.cast(TricksOfTheTrade, "focus")
                return true;
            end
        end
    end,

    ["Hyperspeed Accelerators"] = function()
        local _, enabled = GetSetting("hyperspeedaccelerators")
        if enabled then
            if ni.unit.isboss("target")
            and ni.player.slotcd(10) == 0 then
                ni.player.useinventoryitem(10)
                return true;
            end
        end
    end,

    ["Killing Spree"] = function()
        local _, enabled = GetSetting("killingspree")
        if enabled then
            if ni.spell.available(KillingSpree)
            and ni.unit.isboss("target")
            and ni.unit.debuff("target", Rupture, "player")
            and ni.unit.buff("player", SliceAndDice)
            and ni.player.power() < 70 then
                ni.spell.cast(KillingSpree, "target")
                return true;
            end
        end
    end,

    ["Blade Flurry"] = function()
        local _, enabled = GetSetting("bladeflurry")
        if enabled then
            if ni.spell.available(BladeFlurry)
            and ni.unit.isboss("target")
            and ni.unit.debuff("target", Rupture, "player")
            and ni.unit.buff("player", SliceAndDice) then
                ni.spell.cast(BladeFlurry)
                return true;
            end
        end
    end,

    ["Adrenaline Rush"] = function()
        local _, enabled = GetSetting("adrenalinerush")
        if enabled then
            if ni.spell.available(AdrenalineRush)
            and ni.unit.isboss("target")
            and ni.unit.debuff("target", Rupture, "player")
            and ni.unit.buff("player", SliceAndDice)
            and ni.player.power() < 50 then
                ni.spell.cast(AdrenalineRush)
                return true;
            end
        end
    end,

    ["Slice and Dice"] = function()
        local value, enabled = GetSetting("sliceanddice")
        if enabled then
            if ni.spell.available(SliceAndDice)
            and GetComboPoints("player", "target") >= value
            and ni.unit.buffremaining("player", SliceAndDice, "player") <= 2 then
                ni.spell.cast(SliceAndDice)
                return true;
            end
        end
    end,

    ["Rupture"] = function()
        local value, enabled = GetSetting("rupture")
        if enabled then
            if ni.spell.available(Rupture)
            and ni.spell.valid("target", Rupture, true, true)
            and GetComboPoints("player", "target") >= value
            and ni.unit.debuffremaining("target", Rupture, "player") <= 2 then
                ni.spell.cast(Rupture, "target")
                return true;
            end
        end
    end,

    ["Eviscerate"] = function()
        local value, enabled = GetSetting("eviscerate")
        if enabled then
            if ni.spell.available(Eviscerate)
            and ni.spell.valid("target", Eviscerate, true, true)
            and GetComboPoints("player", "target") == value then
                ni.spell.cast(Eviscerate, "target")
                return true;
            end
        end
    end,

    ["Sinister Strike"] = function()
        local _, enabled = GetSetting("sinisterstrike")
        if enabled then
            if ni.spell.available(SinisterStrike)
            and ni.spell.valid("target", SinisterStrike, true, true) then
                ni.spell.cast(SinisterStrike, "target")
                return true;
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Rogue Combat PvE", queue, abilities, onload, onunload)
