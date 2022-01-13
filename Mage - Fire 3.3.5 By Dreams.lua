local Evocation = GetSpellInfo(12051);
local Pyroblast = GetSpellInfo(42891);
local LivingBomb = GetSpellInfo(55360);
local MirrorImage = GetSpellInfo(55342);
local Combustion = GetSpellInfo(11129);
local Fireblast = GetSpellInfo(42873);
local Fireball = GetSpellInfo(42833);
local ManaGem = GetSpellInfo(33312);

local queue = {
    "Pause",
	"Mana Gem",
	"Fireblast",
    "Evocation",
    "Pyroblast",
    "Living Bomb",
	"Mirror Image",
    "Combustion",
    "Fireball"
}

local abilities = {
    ["Pause"] = function()
    if IsMounted()
        or not UnitAffectingCombat("player")
        or not UnitExists("target")
        or UnitIsDeadOrGhost("player") then
            return true;
        end
    end,

    ["Mana Gem"] = function()
    if ni.spell.available(ManaGem)
        and ni.player.power() <= 85
        and ni.player.hasitem(33312)
        and ni.player.itemcd(33312) <= 1 then
            ni.player.useitem(33312)
            return true;
        end
    end,

    ["Evocation"] = function()
    if ni.spell.available(Evocation)
        and UnitAffectingCombat("player")
        and ni.player.power() <= 10 then
            ni.spell.cast(Evocation)
            return true;
        end
    end,

    ["Pyroblast"] = function()
    if ni.spell.available(Pyroblast)
        and ni.unit.buff("player", 48108) then
            ni.spell.cast(Pyroblast)
            return true;
        end
	end,

    ["Living Bomb"] = function()
    if ni.spell.available(LivingBomb)
        and ni.unit.debuff("target", 55360, "player") == nil then
            ni.spell.cast(LivingBomb)
            return true;
		end
	end,

    ["Mirror Image"] = function()
    if ni.spell.available(MirrorImage)
        and ni.unit.isboss("target")
        and ni.spell.available(MirrorImage) then
            ni.spell.cast(MirrorImage)
            return true;
        end
    end,

    ["Combustion"] = function()
    if ni.spell.available(Combustion)
        and ni.unit.isboss("target")
        and ni.spell.available(Combustion) then
            ni.spell.cast(Combustion)
            return true;
        end
    end,

    ["Fireblast"] = function()
    if ni.spell.available(Fireblast) 
        and not ni.unit.ischanneling("player") 
        and ni.unit.ismoving("player") then
            ni.spell.cast(Fireblast)
            return true;
        end
    end,

    ["Fireball"] = function()
    if ni.spell.available(Fireball) then
            ni.spell.cast(Fireball)
            return true;
        end
    end,
}

ni.bootstrap.rotation("Mage - Fire 3.3.5 By Dreams", queue, abilities)