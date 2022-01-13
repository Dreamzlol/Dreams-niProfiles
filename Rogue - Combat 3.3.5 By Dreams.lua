local TricksOfTheTrade = GetSpellInfo(57934);
local SliceAndDice = GetSpellInfo(6774);
local Rupture = GetSpellInfo(48672);
local Eviscreate = GetSpellInfo(48668);
local SinisterStrike = GetSpellInfo(48638);
local KillingSpree = GetSpellInfo(51690);
local BladeFlurry = GetSpellInfo(13877);
local AdrenalineRush = GetSpellInfo(13750);

local queue = {
    "Pause",
    "Tricks of the Trade",
    "Slice And Dice",
    "Rupture",
    "Eviscreate",
    "Sinister Strike",
    "Hyperspeed Accelerators",
    "Killing Spree",
    "Blade Flurry",
    "Adrenaline Rush"
};

local abilities = {
    ["Pause"] = function()
		if IsMounted()
		 or not UnitAffectingCombat("player")
		 or UnitIsDeadOrGhost("player") then
			return true;
		end
	end,

    ["Start Attack"] = function()
		if UnitExists("target")
		 and UnitCanAttack("player", "target")
		 and not UnitIsDeadOrGhost("target")
		 and UnitAffectingCombat("player", "target")
         and not IsCurrentSpell(6603) then
			ni.spell.cast(6603);
		end
	end,


	["Tricks of the Trade"] = function()
        if ni.spell.available(TricksOfTheTrade)
        and ni.unit.exists("focus") then
            ni.spell.cast(TricksOfTheTrade, "focus")
            return true;
        end
	end,

	["Slice And Dice"] = function()
        if ni.spell.available(SliceAndDice)
        and GetComboPoints("player", "target") >= 2
        and ni.unit.buffremaining("player", "Slice and Dice", "player") < 4 then
            ni.spell.cast(SliceAndDice)
            return true;
        end
    end,

	["Rupture"] = function()
        if ni.spell.available(Rupture)
        and GetComboPoints("player", "target") >= 2
        and ni.unit.debuffremaining("target", "Rupture", "player") <= 4 then
            ni.spell.cast(Rupture)
            return true;
        end
    end,

	["Eviscreate"] = function()
        if ni.spell.available(Eviscreate)
		and GetComboPoints("player", "target") == 5 then
			ni.spell.cast(Eviscreate)
			return true;
        end
	end,

	["Sinister Strike"] = function()
        if ni.spell.available(SinisterStrike) then
            ni.spell.cast(SinisterStrike)
            return true;
        end
	end,

	["Hyperspeed Accelerators"] = function()
	    if ni.unit.isboss("target")
        and ni.player.slotcd(10) == 0 then
            ni.player.useinventoryitem(10)
            return true;
        end
	end,

	["Killing Spree"] = function()
    local power = ni.power.current("player")
        if ni.unit.isboss("target")
        and ni.spell.available(KillingSpree)
        and power < 50 then
            ni.spell.cast(KillingSpree)
            return true;
        end
	end,

	["Blade Flurry"] = function()
	    if ni.unit.isboss("target")
        and ni.spell.available(BladeFlurry) then
            ni.spell.cast(BladeFlurry)
            return true;
        end
	end,

	["Adrenaline Rush"] = function()
	    if ni.unit.isboss("target")
        and ni.spell.available(AdrenalineRush) then
            ni.spell.cast(AdrenalineRush)
            return true;
        end
	end,
};

ni.bootstrap.profile("Rogue - Combat 3.3.5 By Dreams", queue, abilities);