--------------------------------
-- Priest - Discipline PvE
-- Version - 1.0.0
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Added Power Infusion
-- 1.0.2 Added dispelling diseases and magic debuffs
--------------------------------
local ni = ...

local queue = {
    "Inner Fire",
    "Pause Rotation",
    "Pain Suppression",
    "Power Infusion",
    "Shadowfiend",
    "Disease",
    "Dispel Magic",
    "Renew",
    "Prayer of Mending",
    "Prayer of Healing",
    "Penance",
    "Flash Heal",
    "Power Word: Shield",
}

local abilities = {
    ["Inner Fire"] = function()
        if ni.spell.available("Inner Fire")
        and not ni.unit.buff("player", "Inner Fire") then
            ni.spell.cast("Inner Fire")
        end
    end,

    ["Pause Rotation"] = function()
        if IsMounted()
        or not UnitAffectingCombat("player")
        or UnitIsDeadOrGhost("player") then
            return true;
        end
    end,

    ["Pain Suppression"] = function()
        for i = 1, #ni.members do
            if ni.members[i].hp < 20
            and ni.members[i].range
            and ni.spell.available("Pain Suppression") then
                ni.spell.cast("Pain Suppression", ni.members[i].unit)
            end
        end
    end,

    ["Power Infusion"] = function()
        if ni.spell.available("Power Infusion")
        and not ni.unit.buff("player", "Power Infusion")
        and ni.player.power() < 90 then
            ni.spell.cast("Power Infusion", "player")
        end
    end,

    ["Shadowfiend"] = function()
        if ni.spell.available("Shadowfiend")
        and ni.unit.exists("target")
        and ni.player.power() < 40 then
            ni.spell.cast("Shadowfiend", "target")
        end
    end,

    ["Disease"] = function ()
        for i = 1, #ni.members do
            if ni.members[i]:debufftype("Disease")
            and ni.members[i].range
            and ni.members[i].hp > 80
            and ni.spell.available("Cure Disease") then
                ni.spell.cast("Cure Disease", ni.members[i].unit)
            end
        end
    end,

    ["Dispel Magic"] = function ()
        for i = 1, #ni.members do
            if ni.members[i]:debufftype("Magic")
            and ni.members[i].range
            and ni.members[i].hp > 80
            and ni.spell.available("Dispel Magic") then
                ni.spell.cast("Dispel Magic", ni.members[i].unit)
            end
        end
    end,

    ["Renew"] = function ()
        for i = 1, #ni.members do
            if ni.members[i].istank
            and ni.members[i].range
            and not ni.members[i]:buff("Renew", "player")
            and ni.spell.available("Renew") then
                ni.spell.cast("Renew", ni.members[i].unit)
            end
        end
    end,

    ["Prayer of Mending"] = function ()
        for i = 1, #ni.members do
            if ni.members[i].istank
            and ni.members[i].range
            and not ni.unit.buff(ni.members[i].unit, "Prayer of Mending", "player")
            and ni.spell.available("Prayer of Mending") then
                ni.spell.cast("Prayer of Mending", ni.members[i].unit)
            end
        end
    end,

    ["Prayer of Healing"] = function ()
        local count = ni.members.below(60);
        for i = 1, #ni.members do
            if ni.members[i].range
            and count > 4
            and ni.spell.available("Prayer of Healing") then
                ni.spell.cast("Prayer of Healing", ni.members[i].unit)
            end
        end
    end,

    ["Penance"] = function ()
        for i = 1, #ni.members do
            if ni.members[i].hp < 80
            and ni.members[i].range
            and ni.spell.available("Penance") then
                ni.spell.cast("Penance", ni.members[i].unit)
            end
        end
    end,

    ["Flash Heal"] = function ()
        for i = 1, #ni.members do
            if ni.members[i].hp < 80
            and ni.members[i].range
            and ni.spell.available("Flash Heal") then
                ni.spell.cast("Flash Heal", ni.members[i].unit)
            end
        end
    end,

    ["Power Word: Shield"] = function ()
        for i = 1, #ni.members do
            if ni.members[i].hp > 80
            and ni.members[i].range
            and not ni.unit.debuff(ni.members[i].unit, "Weakened Soul", "player")
            and not ni.unit.buff(ni.members[i].unit, "Power Word: Shield", "player")
            and ni.spell.available("Power Word: Shield") then
                ni.spell.cast("Power Word: Shield", ni.members[i].unit)
            end
        end
    end,
}
ni.bootstrap.rotation("Priest - Discipline PvE", queue, abilities)