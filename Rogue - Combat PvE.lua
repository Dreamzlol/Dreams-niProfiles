local ni = ...

local queue = {
    "Pause",
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
    ["Pause"] = function()
        if IsMounted() or not UnitAffectingCombat("player") or not UnitExists("target") or UnitIsDeadOrGhost("player") then
            return true;
        end
    end,

    ["Start Attack"] = function()
        if UnitExists("target") and UnitCanAttack("player", "target") and not UnitIsDeadOrGhost("target") and
            UnitAffectingCombat("player") and not IsCurrentSpell(6603) then ni.spell.cast(6603); end
    end,

    ["Hyperspeed Accelerators"] = function()
        if ni.unit.isboss("target") and ni.player.slotcd(10) == 0 then
            ni.player.useinventoryitem(10)
            return true;
        end
    end,

    ["Tricks of the Trade"] = function()
        if ni.spell.available("Tricks of the Trade", "focus") and ni.unit.exists("focus") and
            IsSpellInRange("Tricks of the Trade", "focus") then
            ni.spell.cast("Tricks of the Trade", "focus")
            return true;
        end
    end,

    ["Killing Spree"] = function()
        if ni.spell.available("Killing Spree") and ni.unit.isboss("target") and
            ni.unit.debuff("target", "Rupture", "player") and ni.unit.buff("player", "Slice and Dice") and
            ni.player.power() <= 35 then
            ni.spell.cast("Killing Spree", "target")
            return true;
        end
    end,

    ["Blade Flurry"] = function()
        if ni.spell.available("Blade Flurry") and ni.unit.isboss("target") and
            ni.unit.debuff("target", "Rupture", "player") and ni.unit.buff("player", "Slice and Dice") then
            ni.spell.cast("Blade Flurry", "target")
            return true;
        end
    end,

    ["Adrenaline Rush"] = function()
        if ni.spell.available("Adrenaline Rush") and ni.unit.isboss("target") and
            ni.unit.debuff("target", "Rupture", "player") and ni.unit.buff("player", "Slice and Dice") and
            ni.player.power() <= 35 then
            ni.spell.cast("Adrenaline Rush", "target")
            return true;
        end
    end,

    ["Slice and Dice"] = function()
        if ni.spell.available("Slice and Dice") and GetComboPoints("player", "target") >= 2 and
            ni.unit.buffremaining("player", "Slice and Dice", "player") <= 3 then
            ni.spell.cast("Slice and Dice", "target")
            return true;
        end
    end,

    ["Rupture"] = function()
        if ni.spell.available("Rupture") and GetComboPoints("player", "target") >= 4 and
            ni.unit.debuffremaining("target", "Rupture", "player") <= 5 then
            ni.spell.cast("Rupture", "target")
            return true;
        end
    end,

    ["Eviscerate"] = function()
        if ni.spell.available("Eviscerate") and GetComboPoints("player", "target") > 4 then
            ni.spell.cast("Eviscerate", "target")
            return true;
        end
    end,

    ["Sinister Strike"] = function()
        if ni.spell.available("Sinister Strike") then
            ni.spell.cast("Sinister Strike", "target")
            return true;
        end
    end,
}

ni.bootstrap.rotation("Rogue - Combat PvE", queue, abilities)
