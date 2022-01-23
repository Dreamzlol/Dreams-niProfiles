--------------------------------
-- Mage - Fire PvE
-- Version - 1.0.2
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Added Scorch for crit debuff if you have no warlock, Added Fire Blast while moving
-- 1.0.2 Added Auto Target
--------------------------------
local ni = ...

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
        if ni.spell.available("Molten Armor")
        and not ni.unit.buff("player", "Molten Armor") then
            ni.vars.debug = false
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
            ni.spell.cast("Conjure Mana Gem", "player")
        end
    end,

    ["Pause Rotation"] = function()
        if not UnitExists("target")
		 or (UnitExists("target")
		 and (not UnitCanAttack("player", "target")
		 or UnitIsDeadOrGhost("target")))
		 or UnitChannelInfo("player")
		 or UnitIsDeadOrGhost("player")
		 or IsMounted() then
			return true;
		end
	end,

    ["Auto Target"] = function()
		if UnitAffectingCombat("player")
		 and ((ni.unit.exists("target")
		 and UnitIsDeadOrGhost("target")
		 and not UnitCanAttack("player", "target"))
		 or not ni.unit.exists("target")) then
			ni.player.runtext("/targetenemy")
		end
	end,

    ["Mana Sapphire"] = function()
        if ni.player.itemcd(33312) == 0
        and ni.player.power() < 85 then
            ni.player.useitem(33312)
        end
    end,

    ["Evocation"] = function()
        if ni.spell.available("Evocation")
        and UnitAffectingCombat("player")
        and ni.player.power() < 20
        and not ni.unit.ismoving("player") then
            ni.spell.cast("Evocation")
        end
    end,

    ["Scorch"] = function()
        if not ni.unit.debuff("target", "Shadow Mastery")
        and not ni.unit.debuff("target", "Improved Scorch")
        and ni.spell.available("Scorch", "target")
        and not ni.unit.ischanneling("player") then
            ni.spell.cast("Scorch")
        end
    end,

    ["Fire Blast"] = function()
        if ni.spell.available("Fire Blast", "target")
        and ni.player.ismoving() then
            ni.spell.cast("Fire Blast", "target")
        end
    end,

    ["Living Bomb"] = function()
        if ni.spell.available("Living Bomb", "target")
        and not ni.unit.debuff("target", "Living Bomb", "player")
        and not ni.unit.ischanneling("player") then
            ni.spell.cast("Living Bomb", "target")
        end
    end,

    ["Pyroblast"] = function()
        if ni.spell.available("Pyroblast", "target")
        and ni.unit.buff("player", "Hot Streak")
        and not ni.unit.ischanneling("player") then
            ni.spell.cast("Pyroblast", "target")
        end
    end,

    ["Mirror Image"] = function()
        if ni.spell.available("Mirror Image")
        and ni.unit.isboss("target")
        and not ni.unit.ischanneling("player") then
            ni.spell.cast("Mirror Image")
        end
    end,

    ["Combustion"] = function()
        if ni.spell.available("Combustion")
        and ni.unit.isboss("target")
        and not ni.unit.ischanneling("player") then
            ni.spell.cast("Combustion")
        end
    end,

    ["Fireball"] = function()
        if ni.spell.available("Fireball", "target")
        and not ni.unit.ischanneling("player") then
            ni.spell.cast("Fireball", "target")
        end
    end,
}

ni.bootstrap.rotation("Mage - Fire PvE", queue, abilities)
