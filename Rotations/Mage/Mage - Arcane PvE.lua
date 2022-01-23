--------------------------------
-- Mage - Arcane PvE
-- Version - 1.0.0
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
--------------------------------
local ni = ...

local queue = {
    "Molten Armor",
    "Arcane Brilliance",
    "Conjure Mana Gem",
    "Pause Rotation",
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
        if ni.spell.available("Molten Armor")
        and not ni.unit.buff("player", "Molten Armor") then
            ni.spell.cast("Molten Armor", "player")
        end
    end,

    ["Arcane Brilliance"] = function()
        if ni.spell.available("Arcane Brilliance")
        and not ni.unit.buff("player", "Arcane Brilliance")
        and ni.player.hasitem(17020) then
            ni.spell.cast("Arcane Brilliance", "player")
        end
    end,

    ["Conjure Mana Gem"] = function()
        if ni.spell.available("Conjure Mana Gem")
        and not ni.player.hasitem(33312)
        and not UnitAffectingCombat("player") then
            ni.spell.cast("Conjure Mana Gem")
        end
    end,

    ["Pause Rotation"] = function()
        if IsMounted()
        or not UnitAffectingCombat("player")
        or UnitIsDeadOrGhost("player") then
            return true;
        end
    end,

    ["Mana Sapphire"] = function()
        if ni.player.itemcd(33312) == 0
        and ni.player.power() < 85
        and not ni.unit.ischanneling("player") then
            ni.player.useitem(33312)
        end
    end,

    ["Evocation"] = function()
        if ni.spell.available("Evocation")
        and UnitAffectingCombat("player")
        and ni.player.power() < 20
        and not ni.player.movingfor(2) then
            ni.spell.cast("Evocation")
        end
    end,

    ["Mirror Image"] = function()
        if ni.spell.available("Mirror Image")
        and ni.unit.isboss("target")
        and not ni.unit.ischanneling("player")
        and ni.unit.debuffstacks("player", 36032) >= 3 then
            ni.spell.cast("Mirror Image")
        end
    end,

    ["Icy Veins"] = function()
        if ni.spell.available("Icy Veins")
        and ni.unit.isboss("target")
        and not ni.unit.ischanneling("player")
        and ni.unit.debuffstacks("player", 36032) >= 3 then
            ni.spell.cast("Icy Veins")
        end
    end,

    ["Arcane Power"] = function()
        if ni.spell.available("Arcane Power")
        and ni.unit.isboss("target")
        and not ni.unit.ischanneling("player")
        and ni.unit.debuffstacks("player", 36032) >= 3 then
            ni.spell.cast("Arcane Power")
        end
    end,

    ["Presence of Mind"] = function()
        if ni.spell.available("Presence of Mind")
        and ni.unit.isboss("target")
        and not ni.unit.ischanneling("player")
        and ni.unit.debuffstacks("player", 36032) >= 1 then
            ni.spell.cast("Presence of Mind", "target")
        end
    end,

    ["Arcane Missiles"] = function()
        if ni.spell.available("Arcane Missiles")
        and ni.unit.debuffstacks("player", 36032) == 4
        and ni.unit.buff("player", "Missile Barrage")
        and not ni.unit.ischanneling("player") then
            ni.spell.cast("Arcane Missiles", "target")
        end
    end,

    ["Arcane Blast"] = function()
        if ni.spell.available("Arcane Blast")
        and not ni.unit.ischanneling("player") then
            ni.spell.cast("Arcane Blast", "target")
        end
    end,
}

ni.bootstrap.rotation("Mage - Arcane PvE", queue, abilities)
